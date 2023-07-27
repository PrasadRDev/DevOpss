terraform {
  required_version = ">=1.3.5"
  # Backend configuration to store tfstate file
  # Backend is Terraform Cloud organisation "AvayaCloud"
  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "AvayaCloud"
  #   workspaces {
  #     name = "ecs-gcp-hostinfra-${var.env}"
  #   }
  # }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0, < 5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0, < 5.0.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

provider "google" {
  access_token    = data.google_service_account_access_token.tf_execute_sa.access_token
  request_timeout = "1800s"
}

provider "google-beta" {
  access_token    = data.google_service_account_access_token.tf_execute_sa.access_token
  request_timeout = "1800s"
}

# impersonate Terraform Master service account
# to Obtain temporary access token for Terrafrom Execute Service account
#
data "google_service_account_access_token" "tf_execute_sa" {
  provider               = google.impersonation
  target_service_account = var.sa_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3600s"
}

# Set TF Execute Service account as variable
variable "sa_account" {
  description = "SA Account"
  type        = string
  default     = "root-sa-terraform@mypoc-389310.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "iam" {
  project = "MyPOC"
  role    = "roles/editor"

  member = "user:aditya.chawla2204@gmail.com"
}
