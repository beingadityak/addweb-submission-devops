provider "aws" {
  version = "~> 2.63"
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12"
}