terraform {
  required_version = ">= 0.12"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.124.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    ansible = {
      source  = "nbering/ansible"
      version = "1.0.4"
    }
  }
}
