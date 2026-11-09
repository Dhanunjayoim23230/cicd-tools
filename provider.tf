terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.30.0"
    }
  }
  backend "s3" {
    bucket         = "vrushali-tf-state"
    key            = "Jenkins"
    region         = "us-east-1"
    #dynamodb_table = "vrushali-tf-state-file"
    use_lockfile = true
  }
}

provider "aws" {

  # Configuration options
  region = "us-east-1"
}