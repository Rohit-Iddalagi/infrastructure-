# Hospital Management Infrastructure

Infrastructure-as-code for deploying core services on AWS using Terraform.

## Scope

- Networking (VPC, subnets, security groups, ALB)
- ECR repositories
- ECS Fargate services (Patient + Appointment)
- RDS MySQL
- Secrets Manager

## Layout

```text
Infrastructure/
  terraform/
    environments/
      dev/
      stage/
      prod/
    modules/
      networking/
      ecr/
      ecs/
      rds/
      secrets/
```

## Notes

- `prod` is the only environment with full Terraform configuration (`main.tf`, `variables.tf`, `provider.tf`).
- `dev` and `stage` currently define only Terraform backend files.
- Backend state bucket/table values must exist in AWS before running `terraform init`.

## Quick Start

```bash
cd Infrastructure/terraform/environments/prod
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## CI/CD

Use your repository CI/CD workflow to run:

1. `terraform init`
2. `terraform validate`
3. `terraform plan`
4. gated `terraform apply` on `main`

## Required Inputs

- AWS credentials with permissions for VPC/ECS/ECR/RDS/Secrets/IAM/CloudWatch
- Existing Terraform backend:
  - S3 bucket
  - DynamoDB lock table
- Finalized naming convention for ECR repos across CI and Terraform
