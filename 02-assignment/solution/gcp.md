# Solution - Assignment-1 - Docker, Kubernetes, AWS/GCP/Azure, EKS/GKE/AKE, RDS/Cloud SQL/Azure Database, Terraform

## GCP

#### Fork/Create branche this repo to create own workspace -
https://github.com/patelmanjeet/python_sample_app/tree/gcp


#### Setup mysql database & kubernetes cluster
Create service account for terrform user or user gcloud auth to setup auth for terrform - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started
```
cd gcp/terraform/
terraform init
terraform plan
terraform apply
```
Terraform will create
- cloud sql db
- gke cluster
- cloudsql-client-sa & kubernetes_secret - kubernetes secret contain  cloudsql connection detail and cloudsql proxy sa key
- cloud build with repo https://github.com/patelmanjeet/python_sample_app/tree/gcp


#### Import db/init.sql sql into database
Use GUI - cloud sql import option to import https://github.com/patelmanjeet/python_sample_app/tree/gcp/db/init.sql

#### Application should access from external using load balancer
Helm chart create https://github.com/patelmanjeet/python_sample_app/tree/gcp/helm/sample-python-app <br>
Once Cloud Build run new Services expose on load balancer


#### Setup CD for the same codebase with Terraform/Github Actions/Any and demonstrate deployment.
###### create custom cloud-builders-community image for helm
Dwnload https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm folder and run below command to create custom image
```
gcloud builds submit . --config=cloudbuild.yaml
```

Project pipeline : https://github.com/patelmanjeet/python_sample_app/tree/gcp/cloudbuild.yaml
