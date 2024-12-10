terraform {

  required_version = ">=0.15"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_password" "password" {
  length = 16
  special = true
  lower = true
  upper = true
  numeric = true
}