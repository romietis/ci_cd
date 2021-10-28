#module "project-services" {
#  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
#  version                     = "10.1.1"
#  project_id                  = var.gcp_project
#  disable_services_on_destroy = true
#  disable_dependent_services  = true
#  activate_apis = [,
#    "cloudbuild.googleapis.com",
#    "run.googleapis.com",
#    "containerscanning.googleapis.com"
#  ]
#}
#
#resource "google_service_account" "google_analytics_integration_sa" {
#  account_id   = var.google_analytics_integration_sa
#  display_name = var.google_analytics_integration_sa_display_name
#}
#
#resource "google_service_account_key" "google_analytics_integration_sa_key" {
#  service_account_id = google_service_account.google_analytics_integration_sa.name
#  public_key_type    = "TYPE_X509_PEM_FILE"
#}
#
#resource "google_secret_manager_secret" "google_analytics_auth_secret" {
#  secret_id = "google-analytics-auth"
#
#  replication {
#    automatic = true
#  }
#}
#
#resource "google_secret_manager_secret_version" "secret_version" {
#  secret      = google_secret_manager_secret.google_analytics_auth_secret.id
#  secret_data = base64decode(google_service_account_key.google_analytics_integration_sa_key.private_key)
#}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
}

resource "google_cloudbuild_trigger" "build_rigger" {
  name = "ci-cd-trigger-test"
  github {
    owner = "romietis"
    name = "ci_cd"
    pull_request {
      branch = "^main$"
      comment_control = "COMMENTS_DISABLED"
    }
  }
  filename = "pull-request-build.yaml"
}

resource "google_cloud_run_service" "run_service_test" {
  name = "ci-cd-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello:latest"
      }
    }
  }
#  traffic {
#    percent         = 100
#    latest_revision = true
#  }

  depends_on = [google_project_service.run_api]
}
#
#resource "google_cloud_run_service_iam_member" "run_all_users" {
#  service  = google_cloud_run_service.run_service_test.name
#  location = google_cloud_run_service.run_service_test.location
#  role     = "roles/run.invoker"
#  member   = "allUsers"
#}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.run_service_test.location
  project     = google_cloud_run_service.run_service_test.project
  service     = google_cloud_run_service.run_service_test.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

