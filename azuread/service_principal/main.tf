/* Create an Azure Service Principal
and store the secret in Azure Key Vault
*/

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.20.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.28.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  # Configuration options
}

data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

resource "random_id" "main" {
  byte_length = 4
  prefix      = "example-"
}

resource "azuread_application" "example" {
  display_name = "${random_id.main.hex}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example" {
  application_id               = azuread_application.example.application_id
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.example.object_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_key_vault" "example" {
  name                        = "${random_id.main.hex}-kv"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get","Set","List","Delete","Purge"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "CLIENT-SECRET"
  value        = "${azuread_service_principal_password.example.value}"
  key_vault_id = azurerm_key_vault.example.id
}
