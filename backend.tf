terraform {
  backend "s3" {
    bucket = "pcg-tf-state"
    key = "kubernetes/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}