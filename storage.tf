
# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        resource_group = var.azurerm_resource_group_name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = var.azurerm_resource_group_name
    location                    = var.azurerm_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}
