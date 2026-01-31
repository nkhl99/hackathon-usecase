variable "project_id" {
  type        = string
  description = "GCP project ID"
#   default = "project-ccdedfce-e763-469f-90f"
default = "steel-magpie-486007-d6"
}

variable "region" {
  type        = string
  default     = "us-east1"
}

variable "zone" {
  type        = string
  default     = "us-east1-b"
}

variable "gke_cluster_name" {
  type        = string
  default     = "cicd-gke-cluster"
}

variable "node_pool_name" {
  type        = string
  default     = "cicd-node-pool"
}

variable "artifact_registry_name" {
  type        = string
  default     = "microservices-registry"
}
