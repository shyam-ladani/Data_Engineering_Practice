#Create Random password 
resource "random_password" "randompassword" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#Create Key Vault Secret
resource "azurerm_key_vault_secret" "sqladminpassword" {
  # checkov:skip=CKV_AZURE_41:Expiration not needed 
  name         = "sqladmin"
  value        = random_password.randompassword.result
  key_vault_id = azurerm_key_vault.fg-keyvault.id
  content_type = "text/plain"
  depends_on = [
    azurerm_key_vault.fg-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01,azurerm_key_vault_access_policy.kv_access_policy_02,azurerm_key_vault_access_policy.kv_access_policy_03
  ]
}

#Azure sql database
resource "azurerm_mssql_server" "azuresql" {
  name                         = "fg-dp-sqldb-prod"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "4adminu$er"
  administrator_login_password = random_password.randompassword.result

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "52c47d8b-ebe9-4f4e-a869-f45e37a09b3f"
  }
}



resource "azurerm_mssql_database" "fg-database" {
  name           = "fg-db"
  server_id      = azurerm_mssql_server.azuresql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
 # max_size_gb    = 2
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false

  tags = {
    Application = "Fitnessgeek-demo"
    Env = "Prod"
  }
}

resource "azurerm_key_vault_secret" "sqldb_cnxn" {
  name = "fgsqldbconstring"
  value = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:fg-sqldb-prod.database.windows.net,1433;Database=fg-db;Uid=4adminu$er;Pwd=${random_password.randompassword.result};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.fg-keyvault.id
  depends_on = [
    azurerm_mssql_database.fg-database,azurerm_key_vault_access_policy.kv_access_policy_01,azurerm_key_vault_access_policy.kv_access_policy_02,azurerm_key_vault_access_policy.kv_access_policy_03
  ]
}