# Network Interfaces for Backend VMs
resource "azurerm_network_interface" "backend" {
  count               = var.vm_count
  name                = "nic-backend-${var.environment}-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows Virtual Machines for Backend
resource "azurerm_windows_virtual_machine" "backend" {
  count               = var.vm_count
  name                = "vm-backend-${count.index + 1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.tags

  network_interface_ids = [
    azurerm_network_interface.backend[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  # Enable boot diagnostics
  boot_diagnostics {
    storage_account_uri = null # Uses managed storage account
  }
}

# Custom Script Extension to install IIS and deploy website
resource "azurerm_virtual_machine_extension" "iis" {
  count                = var.vm_count
  name                 = "install-iis"
  virtual_machine_id   = azurerm_windows_virtual_machine.backend[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  tags                 = var.tags

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Remove-Item -Path 'C:\\inetpub\\wwwroot\\*' -Recurse -Force -ErrorAction SilentlyContinue; Invoke-WebRequest -Uri 'https://www.tooplate.com/zip-templates/2155_modern_musician.zip' -OutFile 'C:\\temp\\website.zip'; New-Item -ItemType Directory -Path 'C:\\temp' -Force; Invoke-WebRequest -Uri 'https://www.tooplate.com/zip-templates/2155_modern_musician.zip' -OutFile 'C:\\temp\\website.zip'; Expand-Archive -Path 'C:\\temp\\website.zip' -DestinationPath 'C:\\temp\\extracted' -Force; Copy-Item -Path 'C:\\temp\\extracted\\2155_modern_musician\\*' -Destination 'C:\\inetpub\\wwwroot\\' -Recurse -Force; Remove-Item -Path 'C:\\temp' -Recurse -Force\""
    }
  SETTINGS

  depends_on = [azurerm_windows_virtual_machine.backend]
}