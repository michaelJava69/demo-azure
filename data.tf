data "azurerm_key_vault" "demo" {
  name                        = var.azurerm_keyvault_name 
  resource_group_name         = var.azurerm_resource_group_name
}

/*
data "azurerm_key_vault_secret" "clientid" {
  name = "clientid"
  key_vault_id = data.azurerm_key_vault.demo.id
}

data "azurerm_key_vault_secret" "clientsecret" {
  name = "clientsecret"
  key_vault_id = data.azurerm_key_vault.demo.id
}

data "azurerm_key_vault_secret" "tenantid" {
  name = "tenantid"
  key_vault_id = data.azurerm_key_vault.demo.id
}

data "azurerm_key_vault_secret" "passwordadmin" {
  name = "passwordadmin"
  key_vault_id = data.azurerm_key_vault.demo.id
}

data "azurerm_key_vault_secret" "subscriptionid" {
  name = "subscriptionid"
  key_vault_id = data.azurerm_key_vault.demo.id
}

*/

data "azurerm_key_vault_secret" "sslpubkey" {
  name = "sslpubkey"
  key_vault_id = data.azurerm_key_vault.demo.id
}
