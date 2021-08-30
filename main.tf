# AWS EKS example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# eks
module "eks" {
  source              = "Young-ook/eks/aws"
  name                = var.name
  tags                = var.tags
  kubernetes_version  = var.kubernetes_version
  managed_node_groups = var.managed_node_groups
  node_groups         = var.node_groups
  fargate_profiles    = var.fargate_profiles
  enable_ssm          = var.enable_ssm
}

provider "helm" {
  kubernetes {
    host                   = module.eks.helmconfig.host
    token                  = module.eks.helmconfig.token
    cluster_ca_certificate = base64decode(module.eks.helmconfig.ca)
  }
}

module "alb-module" {
  source       = "modules/alb-ingress"
  enabled      = false
  cluster_name = module.eks.cluster.name
  oidc         = module.eks.oidc
  tags         = { env = "test" }
}

resource "kubernetes_deployment" "node-deployment" {
  metadata {
    name = "node-app"
    labels = {
      app = "node"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "node"
      }
    }

    template {
      metadata {
        labels = {
          app = "node"
        }
      }

      spec {
        container {
          image = "vveereshvsh/node-app:23"
          name  = "node-app"
          port {
            container_port = "5000"
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node-service" {
  metadata {
    name = "node-app"
  }
  spec {
    selector = {
      app = kubernetes_deployment.node-deployment.metadata.0.labels.app
    }

    session_affinity = "ClientIP"
    port {
      port        = 5000
      target_port = 5000
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "node-hpa" {
  metadata {
    name = "node-app"
  }

  spec {
    max_replicas = 10
    min_replicas = 2

    scale_target_ref {
      kind = "Deployment"
      name = "node"
    }
  }
}


