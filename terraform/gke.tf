resource "google_container_cluster" "gke_cluster" {
  name               = var.gke_cluster_name
  location           = var.zone
  initial_node_count = 1
  remove_default_node_pool = true
  network            = google_compute_network.vpc.id
  subnetwork         = google_compute_subnetwork.subnet.id

}

resource "google_container_node_pool" "primary_nodes" {
  name       = var.node_pool_name
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.zone
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
