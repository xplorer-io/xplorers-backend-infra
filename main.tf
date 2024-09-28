data "google_compute_default_service_account" "default" {
  project = var.project_id
}

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


##################### Google Cloud Workload Identity Provider Configuration #####################
resource "google_iam_workload_identity_pool" "workload_identity_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions-identity-pool"
  display_name              = "Github Actions Identity Pool"
  description               = "Allows Github Actions to authenticate to Google Cloud and deploy resources"
}

resource "google_iam_workload_identity_pool_provider" "workload_identity_pool_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-idp"
  display_name                       = "Github Actions IDP"
  description                        = "Allows Github Actions to authenticate to Google Cloud and deploy resources"
  # TODO: Scope to repositories that run Github Actions - below did not work,
  # (attribute.repository==\"website\" || attribute.repository==\"xplorers-api\")"
  attribute_condition = "attribute.repository_owner==\"xplorer-io\""
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_storage_bucket_iam_member" "github_actions_storage_access" {
  bucket = "xplorers-backend"
  role   = "roles/storage.admin"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_cloud_run_access" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_artifact_registry_access" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_cloud_build_access" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_api_gateway_access" {
  project = var.project_id
  role    = "roles/apigateway.admin"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_service_usage_access" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_project_iam_member" "github_actions_service_management_access" {
  project = var.project_id
  role    = "roles/servicemanagement.admin"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}

resource "google_service_account_iam_member" "github_actions_service_account_act_as" {
  service_account_id = data.google_compute_default_service_account.default.id
  role               = "roles/iam.serviceAccountUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/*"
}
