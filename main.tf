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


resource "google_project_iam_member" "iam" {
  project = "MyPOC"
  role    = "roles/editor"
  member = "user:aditya.chawla2204@gmail.com"
}
