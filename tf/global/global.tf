resource "azurerm_resource_group" "global-rg" {
  name     = "sbd-global"
  location = "South Central US"
}

resource "azurerm_key_vault" "global-kv" {
  name                        = "sbdvault"
  location                    = azurerm_resource_group.global-rg.location
  resource_group_name         = azurerm_resource_group.global-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = "e86183dc-d7cc-4132-8b39-a8de37272433"

  sku_name = "premium"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "test" {
  key_vault_id = azurerm_key_vault.global-kv.id

  tenant_id = "e86183dc-d7cc-4132-8b39-a8de37272433"
  object_id = "fb27f79f-4a67-452c-ba1e-55ed2a1b29a6"

  secret_permissions = [
    "get",
    "set",
  ]
}

resource "azurerm_container_registry" "global-acr" {
  name                = "sbdacrglobal"
  resource_group_name = azurerm_resource_group.global-rg.name
  location            = azurerm_resource_group.global-rg.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_dns_zone" "global-dns" {
  name                = "sbd-pegasus.com"
  resource_group_name = azurerm_resource_group.global-rg.name
}

resource "azurerm_storage_account" "global-tfstore" {
  name                     = "sbdtfstorage"
  resource_group_name      = azurerm_resource_group.global-rg.name
  location                 = azurerm_resource_group.global-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "global-logstore" {
  name                     = "sbdlogstorage"
  resource_group_name      = azurerm_resource_group.global-rg.name
  location                 = azurerm_resource_group.global-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
