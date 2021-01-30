
# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.azurerm_resource_group_location
    resource_group_name = var.azurerm_resource_group_name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = var.azurerm_resource_group_name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = var.azurerm_resource_group_location
    resource_group_name = var.azurerm_resource_group_name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    count                        = length(var.vm_names)
    name                         = "PublicIP-${var.vm_names[count.index]}"
    location                     = var.azurerm_resource_group_location
    resource_group_name          = var.azurerm_resource_group_name
    allocation_method            = "Static"
    sku                          = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  count               = length(var.vm_names)
  name                = "nic-${var.vm_names[count.index]}"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.azurerm_vm_ip_address[count.index]
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip[count.index].id
    primary                       = true
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface_security_group_association" "myterraformnicsecuritygroupassociation" {
  count                     = length(var.vm_names)
  network_interface_id      = azurerm_network_interface.myterraformnic[count.index].id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}
