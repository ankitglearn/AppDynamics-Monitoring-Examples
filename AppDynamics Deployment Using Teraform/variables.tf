#------------------------------------------------------------------------------
# Terraform Workspace Configuration
#------------------------------------------------------------------------------
variable "terraform_workspace" {
  type        = string
  default     = ""
  description = <<-EOT
  **(Internal Use Only)** Do not set unless strictly required.
  The name of the Terraform Enterprise Workspace for use in the contexts where
  `terraform.workspace` is unset or needs to be overridden
  (e.g. terratest, sandboxes, terraform validate, etc)
  EOT
}

variable "shared_tags" {
  type        = map(string)
  description = <<-EOT
  A map of the AWS resource tags to apply to all AWS resources within this
  environment. For the list of mandatory tags, please refer to the
  [Tagging Standard](https://mytakeda.sharepoint.com/sites/AIDE/SitePages/Tagging-Standard.aspx)
  EOT
}

#------------------------------------------------------------------------------
# EKS Cluster Configuration
#------------------------------------------------------------------------------
variable "primary_region" {
  type        = string
  description = "The primary AWS region where all resources will be deployed"
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-1",
      "us-west-2",
      "ap-northeast-1",
      "ap-southeast-1",
      "eu-central-1",
      "eu-west-1"
    ], var.primary_region)
    error_message = "Not a valid TEC AWS region!"
  }
}

variable "cluster_id" {
  type        = string
  description = "The ID of the EKS cluster"
}

variable "tf_cluster_workspace" {
  type        = string
  description = "The name of the Terraform Workspace which built the EKS Cluster"
}

variable "tf_cluster_organization" {
  type        = string
  description = "The name of the Terraform Organization which contains the EKS Cluster Workspace"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = null
}

variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to create in the cluster"
}

variable "environment" {
  type        = string
  description = "Environment name for namespace labeling"
  default     = "dev"
}

#------------------------------------------------------------------------------
# Splunk Integration (configured via TFE Variable Sets)
#------------------------------------------------------------------------------
variable "splunk_hec_token_k8s_events" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "splunk_hec_token_k8s_objects" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "splunk_hec_token_k8s_metrics" {
  type      = string
  sensitive = true
  nullable  = false
}

#------------------------------------------------------------------------------
# Wiz Integration
#------------------------------------------------------------------------------
variable "wiz_client_id" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "wiz_secret" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "wiz_broker_client_id" {
  type     = string
  nullable = false
}

variable "wiz_broker_secret" {
  type      = string
  sensitive = true
  nullable  = false
}

#------------------------------------------------------------------------------
# AppDynamics Cluster Agent Configuration
#------------------------------------------------------------------------------
variable "namespace" {
  type        = string
  description = "Namespace to deploy AppDynamics cluster-agent"
  default     = "appdynamics"
}

variable "helm_repo_url" {
  type        = string
  description = "AppDynamics Helm repository URL"
  default     = "https://appdynamics.jfrog.io/artifactory/appdynamics-cloud-helmcharts/"
}

variable "chart_name" {
  type        = string
  description = "Helm chart name"
  default     = "cluster-agent"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "1.34.1544"
}

variable "values_yaml_path" {
  type        = string
  description = "Path to the Helm values.yaml file"
  default     = "./helm-values/cluster-agent-values.yaml"
}