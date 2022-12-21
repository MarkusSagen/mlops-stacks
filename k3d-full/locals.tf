# config values to use across the module
locals {
  k3d = {
    cluster_name = "minimal-zenml-cluster"
    image      = "rancher/k3s:v1.24.4-k3s1"
  }

  k3d_registry = {
    name = "zenml-registry"
    host = "localhost"
    port = "5001"
  }

  k3d_kube_api = {
    host = "0.0.0.0"
  }

  kubeflow = {
    enable              = false
    version             = "1.8.3"
  }

  cert_manager = {
    version = "1.9.1"
  }

  istio = {
    version = "1.14.1"
  }

  nginx_ingress = {
    version = "4.4.0"
  }

  minio = {
    storage_size = "10Gi"
    zenml_minio_store_bucket = "zenml-minio-store"
    mlflow_minio_store_bucket = "mlflow-minio-store"
  }

  mlflow = {
    enable                  = false
    version                 = "0.7.13"
    artifact_Proxied_Access = "false"
    artifact_S3             = "true"
    # if not set, the bucket created as part of the deployment will be used
    artifact_GCS_Bucket     = ""
  }

  kserve = {
    enable               = false
    version              = "0.9.0" 
    knative_version      = "1.8.1"
    workloads_namespace  = "zenml-workloads-kserve"
    service_account_name = "kserve"
  }

  seldon = {
    enable               = false
    version              = "1.15.0"
    name                 = "seldon"
    namespace            = "seldon-system"
    workloads_namespace  = "zenml-workloads-seldon"
    service_account_name = "seldon"
  }

  tags = {
    "managedBy"   = "terraform"
    "environment" = "dev"
  }
}