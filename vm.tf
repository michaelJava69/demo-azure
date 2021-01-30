
# Create virtual machines

resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = var.vm_names[count.index]
  count                 = length(var.vm_names)
  location              = var.azurerm_resource_group_location
  resource_group_name   = var.azurerm_resource_group_name
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.myterraformnic[count.index].id]
  size               = "Standard_DS1_v2"
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_key_vault_secret.sslpubkey.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name              = "${var.vm_names[count.index]}-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"  
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "null_resource" "post_install" {
    depends_on = [
      azurerm_public_ip.myterraformpublicip
    ]
    count           = length(var.vm_names)
    provisioner "file" {
        source      = "tmp/configs.d"
        destination = "/tmp"
        connection {
            type     = "ssh"
            user     = var.admin_username
            private_key = file("${path.module}/my-private-key")
            host = azurerm_public_ip.myterraformpublicip[count.index].ip_address
        }
    }
    provisioner "remote-exec" {
        inline = [
        "sudo apt-get update",
        "sudo apt-get install -y apache2",
        "sudo echo ${azurerm_linux_virtual_machine.myterraformvm[count.index].name} | sudo tee /var/www/html/index.html",
        "sudo apt-get upgrade -y",
        "sudo mv /tmp/configs.d /root"
        ]
        connection {
            type     = "ssh"
            user     = var.admin_username
            private_key = file("${path.module}/my-private-key")
            host = azurerm_public_ip.myterraformpublicip[count.index].ip_address
        }
    }
}

