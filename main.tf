resource "google_project_service" "apigateway" {
  service = "apigateway.googleapis.com"
}

resource "google_project_service" "servicemanagement" {
  service                    = "servicemanagement.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "servicecontrol" {
  service = "servicecontrol.googleapis.com"
}

resource "google_project_iam_binding" "allow_secret_access" {
  project = var.project_number
  role    = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
  ]
}
