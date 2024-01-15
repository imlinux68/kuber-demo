terraform {
  required_version = ">= 1.0"

  required_providers {
	aws = {
		source  = "hashicorp/aws"
		version =  ">= 5.4.0"
		}
	}
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
  type = string
}

variable "cluster_name" {
  default = "demo-cluster"
  type = string
}


