## 1. Objective

Design and implement a **CI/CD pipeline** to deploy **containerized microservices (2 Node.js + 1 Java)** onto **Google Kubernetes Engine (GKE)** using:

* **GitHub Actions** for CI/CD
* **Terraform** for Infrastructure as Code
* **Docker** for containerization
* **GCP services** for compute, networking, security, and observability

This design demonstrates best practices in **cloud-native architecture**, **secure authentication**, **scalability**, and **operational excellence**, aligned with the hackathon requirements .

---

## 2. High-Level Architecture Overview

### Architecture Components

* **Source Control**: GitHub (monorepo with 3 microservices)
* **CI/CD**: GitHub Actions
* **Container Registry**: Google Artifact Registry (GCR-compatible)
* **Infrastructure**: GCP (VPC, GKE, IAM)
* **Orchestration**: Kubernetes (GKE)
* **Observability**: Cloud Monitoring & Logging (optional Prometheus/Grafana)

### Logical Flow

```
Developer → GitHub → GitHub Actions (CI)
         → Docker Build → Artifact Registry
         → Terraform (Infra)
         → GKE Cluster
         → Kubernetes Deployments → Services → Ingress
```

---

## 3. CI Design – GitHub Actions

### CI Pipeline Responsibilities

The CI pipeline is responsible for:

* Validating code changes
* Building Docker images
* Pushing images to GCP Artifact Registry
* Triggering infrastructure and application deployments

### Pipeline Triggers

| Event        | Purpose                                 |
| ------------ | --------------------------------------- |
| Pull Request | Build, test, validate Docker images     |
| Push to main | Build, push images, deploy infra & apps |

---

### CI Stages

#### 1️⃣ Source Checkout

* Checkout repository using GitHub Actions
* Detect changed services (Node.js / Java)

#### 2️⃣ Application Build

* **Node.js services**

  * Install dependencies
  * Run basic validation (lint/test – design-level)
* **Java service**

  * Maven build
  * Package executable JAR

#### 3️⃣ Docker Image Build

* Multi-stage Docker builds
* Cache dependency layers
* Build one image per microservice

#### 4️⃣ Image Tagging Strategy

* `service-name:commit-sha`
* `service-name:latest` (optional for dev)

#### 5️⃣ Push to Artifact Registry

* Images pushed securely using federated authentication

---

## 4. Dockerfile Design (What & Why)

### Node.js Dockerfile Design

Key principles:

* Lightweight base image (`node:alpine`)
* Separate dependency and runtime layers
* Non-root execution
* Health endpoint exposure

**Conceptual Structure**

* Base image
* Install dependencies
* Copy source code
* Expose port
* Start application

---

### Java Dockerfile Design

Key principles:

* Multi-stage build (Maven → JRE)
* Smaller runtime image
* JVM tuning for Kubernetes
* Externalized config

**Conceptual Structure**

* Build stage (Maven)
* Runtime stage (OpenJDK JRE)
* Copy JAR
* JVM startup command

---

## 5. Container Registry Strategy (GCR / Artifact Registry)

### Why Artifact Registry

* Successor to legacy GCR
* Better IAM and regional control
* Native integration with GKE

### Repository Structure

```
artifact-registry/
 ├── patient-service
 ├── appointment-service
 └── java-service
```

### Access Control

* CI pipeline: image push
* GKE nodes: image pull

---

## 6. Secure Authentication (No Secrets)

### GitHub → GCP Authentication

Uses **Workload Identity Federation**

* No service account keys
* Short-lived credentials
* GitHub is trusted as an identity provider

### IAM Roles (Design-Level)

* Artifact Registry Writer
* GKE Developer
* Terraform Infra Admin (restricted)

---

## 7. Infrastructure Design with Terraform

### Managed via Terraform (IaC)

#### 1️⃣ Networking

* Custom VPC
* Public & private subnets
* NAT for private workloads

#### 2️⃣ GKE Cluster

* Regional cluster (high availability)
* Managed node pools
* Autoscaling enabled

#### 3️⃣ IAM

* Workload identity bindings
* Least-privilege service accounts

#### 4️⃣ Artifact Registry

* Docker repository
* Regional placement

#### 5️⃣ Terraform State

* Remote backend using GCS
* State locking & versioning

---

## 8. Kubernetes Design

### Namespace Strategy

* `dev`, `staging`, `prod` (logical separation)

### Kubernetes Objects

#### Deployments

* One deployment per microservice
* Rolling updates
* Resource requests & limits

#### Services

* Internal ClusterIP services
* Stable DNS-based discovery

#### Ingress

* HTTP(S) load balancing
* Path-based routing

#### Health Checks

* `/health` endpoints
* Liveness & readiness probes

---

## 9. CD Strategy (Deploy to GKE)

### Deployment Flow

1. New image pushed to registry
2. Kubernetes manifests updated
3. Deployment rollout triggered
4. Health checks validated
5. Traffic gradually shifted

### Rollback Strategy

* Kubernetes rollout history
* Image version rollback

---

## 10. Monitoring & Logging

### Default (Required)

* GCP Cloud Logging
* GCP Cloud Monitoring
* Pod & node metrics

### (Optional)

* Prometheus for metrics scraping
* Grafana dashboards

---

## 11. End-to-End Flow Summary (Judges’ Favorite Section)

1. Developer pushes code to GitHub
2. GitHub Actions triggers CI pipeline
3. Applications are built and containerized
4. Docker images are pushed to Artifact Registry
5. Terraform provisions GCP infrastructure
6. Kubernetes manifests are applied to GKE
7. Services are exposed via Ingress
8. Monitoring and logging capture runtime metrics

---

## 12. Deliverables (As Required)

✔ Terraform code
✔ Dockerfiles
✔ Kubernetes manifests
✔ GitHub Actions workflows
✔ Architecture documentation
✔ Monitoring & logging overview
