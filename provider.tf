terraform {
   required_providers {
     aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
     }
   }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::970547357901:role/InfraCreationRole"
  }
}