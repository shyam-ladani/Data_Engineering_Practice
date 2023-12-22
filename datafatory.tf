

resource "random_string" "random-adf" {
  length = 6
  special = false
  lower = true
  upper = false
  
}

resource "azurerm_data_factory" "fg-adf" {
  name                = "fg-adf-dev-${random_string.random-adf.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}