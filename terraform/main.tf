module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "10.1.1"
  project_id                  = var.gcp_project
  disable_services_on_destroy = true
  disable_dependent_services  = true
  activate_apis = [
    "containerregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "containerscanning.googleapis.com"
  ]
}

resource "google_cloudbuild_trigger" "build_trigger_push" {
  name = "ci-cd-pr-trigger"
  github {
    owner = "romietis"
    name  = "ci_cd"
    pull_request {
      branch          = "^main$"
      comment_control = "COMMENTS_DISABLED"
    }
  }
  filename = "pull-request-build.yaml"
}

resource "google_cloudbuild_trigger" "build_rigger" {
  name = "ci-cd-push-trigger"
  github {
    owner = "romietis"
    name  = "ci_cd"
    push {
      branch          = "^main$"
    }
  }
  filename = "cloudbuild.yaml"
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
  depends_on = [module.project-services]
}
