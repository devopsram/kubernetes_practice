variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}