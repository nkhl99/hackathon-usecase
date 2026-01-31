resource "google_artifact_registry_repository" "docker_repo" {
  provider = google
  location = var.region
  repository_id = var.artifact_registry_name
  format        = "DOCKER"
  description   = "Docker registry for microservices"
}
