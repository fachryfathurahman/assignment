terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.ap_southeast_1_region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}

provider "aws" {
  alias      = "ap_southeast_3"
  region     = var.ap_southeast_3_region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}
