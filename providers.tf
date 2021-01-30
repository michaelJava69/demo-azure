provider "azurerm" {
  # This should only be iterated after previous environments have been (uat,prod)
  # This version is needed to use vm zones
  version         = "~>2.41.0"
  features {}
}
