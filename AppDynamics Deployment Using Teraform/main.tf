#------------------------------------------------------------------------------
# Shared Tags Validator
#------------------------------------------------------------------------------
module "validator" {
  source  = "app.terraform.io/Takeda/SharedTags/aws"
  version = "~> 2.1"

  shared_tags         = var.shared_tags
  terraform_workspace = var.terraform_workspace
}

#------------------------------------------------------------------------------
# EKS Cluster Resources
#------------------------------------------------------------------------------
module "eks-cluster-resources" {
  source  = "app.terraform.io/Takeda/EKSClusterResources/aws"
  version = "4.1.2"

  shared_tags   = var.shared_tags
  size_override = true

  node_groups_config = {
    "02" = {
      ami_id              = null
      ami_release_version = null
      ami_type            = "CUSTOM"
      capacity_type       = "ON_DEMAND"
      desired_size        = 1
      disk_size           = 50
      instance_types      = ["t3.2xlarge"]
      maximum_size        = 2
      minimum_size        = 1
      single_az_node_group = true
      labels = {
        tier    = "cache"
        release = "stable"
      }
    }
    "03" = {
      ami_id              = null
      ami_release_version = null
      ami_type            = "CUSTOM"
      capacity_type       = "ON_DEMAND"
      desired_size        = 1
      disk_size           = 50
      instance_types      = ["t3.2xlarge"]
      maximum_size        = 2
      minimum_size        = 1
      single_az_node_group = true
      labels = {
        tier            = "cache"
        release         = "stable"
        replacement_for = "01"
      }
    }
  }

  hosted_zone             = "rnd.aws.takeda.io"
  namespaces              = var.namespaces
  tf_cluster_workspace    = var.tf_cluster_workspace
  tf_cluster_organization = var.tf_cluster_organization
  tf_cluster_id           = var.cluster_id

  # Splunk tokens
  splunk_hec_token_k8s_events  = var.splunk_hec_token_k8s_events
  splunk_hec_token_k8s_metrics = var.splunk_hec_token_k8s_metrics
  splunk_hec_token_k8s_objects = var.splunk_hec_token_k8s_objects

  # Wiz integration
  wiz_client_id        = var.wiz_client_id
  wiz_secret           = var.wiz_secret
  wiz_broker_client_id = var.wiz_broker_client_id
  wiz_broker_secret    = var.wiz_broker_secret
}

#------------------------------------------------------------------------------
# AppDynamics Cluster Agent
#------------------------------------------------------------------------------
resource "kubernetes_namespace" "appd" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
      managed_by  = "terraform"
    }
  }
}

resource "helm_release" "appd_cluster_agent" {
  name             = "appdynamics-cluster-agent"
  namespace        = kubernetes_namespace.appd.metadata[0].name
  create_namespace = false
  repository       = var.helm_repo_url
  chart            = var.chart_name
  version          = var.chart_version != "" ? var.chart_version : null
  values           = [file(var.values_yaml_path)]
  atomic           = true
  timeout          = 900
}