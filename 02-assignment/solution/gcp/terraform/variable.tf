variable "project" {
  description = "Project Id"
  type        = string
  default     = "composed-yen-312813"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-central1-a"
}

variable "sqldb_name" {
  description = "Sqldb Additional Username"
  type        = string
  default     = "assinment02-sample-db"
}

variable "sqldb_additional_username" {
  description = "Sqldb Additional Username"
  type        = string
  default     = "pitcher_user"
}

variable "sqldb_additional_password" {
  description = "Sqldb Additional Password"
  default     = "pitchers_password"
  sensitive   = true
}

variable "sqldb_additional_databasename" {
  description = "Sqldb Additional Database Name"
  default     = "pitchersData"
}

variable "cloudbuild_github_account" {
  description = "Sample app - GitHub account name"
  default     = "patelmanjeet"
}

variable "cloudbuild_github_repo" {
  description = "Sample app - GitHub repo name"
  default     = "python_sample_app"
}

variable "gke_cluster_name" {
  description = "GKE Cluster Name"
  default     = "gke-cluster"
}