## services
locals {
  services = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
  ])
}

resource "google_project_service" "project" {
  project                    = var.project
  for_each                   = local.services
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = false
}

## db
module "sql_db_mysql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "5.0.1"

  name             = var.sqldb_name
  project_id       = var.project
  region           = var.region
  zone             = var.zone
  database_version = "MYSQL_5_7"
  additional_users = [
    {
      name     = var.sqldb_additional_username
      password = var.sqldb_additional_password
      host     = "%"
    }
  ]
  availability_type   = null
  deletion_protection = false

}

# sa cloudsql client
resource "google_service_account" "service_account" {
  account_id   = "cloudsql-client"
  display_name = "Cloud SQL Client"
}

resource "google_project_iam_member" "project" {
  project = var.project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

## elk
resource "google_container_cluster" "gke" {
  name     = var.gke_cluster_name
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  initial_node_count = 1

  node_config {
    machine_type = "e2-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# store db details & sa key as kubernetes_secret
# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}
data "google_container_cluster" "gke" {
  name     = var.gke_cluster_name
  location = var.zone
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_secret" "cloudsql_db_credentials" {
  metadata {
    name = "cloudsql-db-credentials"
  }

  data = {
    username                 = var.sqldb_additional_username
    password                 = var.sqldb_additional_password
    database                 = var.sqldb_additional_databasename
    port                     = "3306"
    instance_connection_name = module.sql_db_mysql.instance_connection_name
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_secret" "cloudsql_client_sa" {
  metadata {
    name = "cloudsql-client-sa"
  }
  data = {
    "service_account.json" = base64decode(google_service_account_key.service_account_key.private_key)
  }
}


## cloud build
resource "google_cloudbuild_trigger" "app_build" {
  github {
    owner = var.cloudbuild_github_account
    name  = var.cloudbuild_github_repo
    push {
      branch = "gcp"
    }
  }

  substitutions = {
    _CUSTOM_REGION    = var.region
    _CUSTOM_ZONE      = var.zone
    _CUSTOM_CLUSTER   = var.gke_cluster_name
    _CLOUD_SQL_DBNAME = var.sqldb_name
  }

  filename = "cloudbuild.yaml"
}