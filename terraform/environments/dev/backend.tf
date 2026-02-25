terraform {
  backend "s3" {
    bucket         = "hospital-project-1"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
