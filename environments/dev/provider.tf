terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Name      = "milan-devops-training",
      Project   = "milan-devops-training"
      Creator   = "milanpokhrel@lftechnology.com"
      Deletable = "Yes"
    }
  }
}
