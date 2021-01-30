terraform {
  backend "azurerm" {
    storage_account_name = "storageaccountmu"
    container_name       = "terraform-demo"
    key                  = "terraformdemo.tfstate"
  }
}
