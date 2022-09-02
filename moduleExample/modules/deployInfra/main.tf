terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "main" {
  byte_length = 4
  prefix      = "example-"
}

resource "azurerm_resource_group" "example" {
  name     = "${random_id.main.hex}-rg"
  location = "eastus"
}