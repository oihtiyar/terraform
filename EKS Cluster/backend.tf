terraform {
  backend "s3" {
    bucket = "oi-cicd-terraform-eks"
    key    = "eks/terraform.tfstate"
    region = "eu-central-1"
  }
}