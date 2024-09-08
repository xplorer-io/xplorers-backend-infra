terraform {
  required_providers {
    google = {
      version = ">= 5.43.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
