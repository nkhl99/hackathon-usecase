output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "artifact_registry_url" {
  value = google_artifact_registry_repository.docker_repo.repository_id
}
