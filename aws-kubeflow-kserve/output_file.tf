# Export Terraform output variable values to a stack yaml file 
# that can be consumed by zenml stack import
resource "local_file" "stack_file" {
  content  = <<-ADD
    # Stack configuration YAML
    # Generated by the AWS Minimal MLOps stack recipe.
    zenml_version: ${var.zenml-version}
    stack_name: aws_minimal_stack_${replace(substr(timestamp(), 0, 16), ":", "_")}
    components:
      artifact_store:
        flavor: s3
        name: s3_artifact_store
        path: s3://${aws_s3_bucket.zenml-artifact-store.bucket}
      container_registry:
        flavor: aws
        name: aws_container_registry
        uri: ${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.region}.amazonaws.com
      metadata_store:
        database: zenml_db
        flavor: mysql
        host: ${module.metadata_store.db_instance_address}
        name: rds_metadata_store
        port: 3306
        secret: aws_mysql_secret
        upgrade_migration_enabled: true
      orchestrator:
        flavor: kubeflow
        name: eks_kubeflow_orchestrator
        synchronous: True
        kubernetes_context: terraform
      secrets_manager:
        flavor: aws
        name: aws_secrets_manager
        region_name: ${local.region}
      experiment_tracker:
        flavor: mlflow
        name: eks_mlflow_experiment_tracker
        tracking_uri: http://${data.kubernetes_service.mlflow_tracking.status.0.load_balancer.0.ingress.0.hostname}
        tracking_username: ${var.mlflow-username}
        tracking_password: ${var.mlflow-password}
      model_deployer:
        flavor: kserve
        name: eks_kserve_model_deployer
        kubernetes_context: terraform
        kubernetes_namespace: ${local.kserve.workloads_namespace}
        base_url: http://${data.kubernetes_service.kserve_ingress.status.0.load_balancer.0.ingress.0.ip}:${data.kubernetes_service.kserve_ingress.spec.0.port.1.port}
        secret: aws_kserve_secret
    ADD
  filename = "./aws_minimal_stack_${replace(substr(timestamp(), 0, 16), ":", "_")}.yml"
}