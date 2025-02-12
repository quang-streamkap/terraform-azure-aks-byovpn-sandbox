output "runner" {
  value = {
    # TODO(jm): make the runner identity optional, so it can have read/write access to the sandbox based on inputs.
    #id           = azurerm_user_assigned_identity.runner.id
    #tenant_id    = azurerm_user_assigned_identity.runner.tenant_id
    #client_id    = azurerm_user_assigned_identity.runner.client_id
    #principal_id = azurerm_user_assigned_identity.runner.principal_id
  }
  description = "A map of runner attributes: id, tenant_id, client_id, principal_id."
}

output "vpn" {
  value = {
    name       = var.network_name
    subnet_ids = data.azurerm_virtual_network.network.subnets
  }
  description = "A map of vpn attributes: name, subnet_ids."
}

output "public_domain" {
  value = {
    enabled = var.enable_public_dns
    nameservers = var.enable_public_dns ? azurerm_dns_zone.public[0].name_servers : []
    name        = var.enable_public_dns ? azurerm_dns_zone.public[0].name : ""
    id          = var.enable_public_dns ? azurerm_dns_zone.public[0].id : ""
  }
  description = "A map of public domain attributes: nameservers, name, id."
}

output "internal_domain" {
  value = {
    enabled = var.enable_private_dns
    nameservers = []
    name        = var.enable_private_dns ? azurerm_private_dns_zone.internal[0].name : ""
    id          = var.enable_private_dns ? azurerm_private_dns_zone.internal[0].id : ""
  }
  description = "A map of internal domain attributes: nameservers, name, id."
}

output "account" {
  value = {
    "location"            = var.location
    "subscription_id"     = data.azurerm_client_config.current.subscription_id
    "client_id"           = data.azurerm_client_config.current.client_id
    "resource_group_name" = data.azurerm_resource_group.rg.name
  }
  description = "A map of Azure account attributes: location, subscription_id, client_id, resource_group_name."
}

output "acr" {
  value = {
    id           = azurerm_container_registry.acr.id
    name         = azurerm_container_registry.acr.name
    login_server = azurerm_container_registry.acr.login_server
    token_id     = azurerm_container_registry_token.runner.id
    password     = nonsensitive(azurerm_container_registry_token_password.runner.password1[0].value)
  }
  description = "A map of ACR attributes: id, login_server, token_id, password."
}

output "cluster" {
  value = {
    "id"                     = module.aks.aks_id
    "name"                   = module.aks.aks_name
    "client_certificate"     = nonsensitive(module.aks.client_certificate)
    "client_key"             = nonsensitive(module.aks.client_key)
    "cluster_ca_certificate" = nonsensitive(module.aks.cluster_ca_certificate)
    "cluster_fqdn"           = module.aks.cluster_fqdn
    "oidc_issuer_url"        = module.aks.oidc_issuer_url
    "location"               = module.aks.location
    "kube_config_raw"        = nonsensitive(module.aks.kube_config_raw)
    "kube_admin_config_raw"  = nonsensitive(module.aks.kube_admin_config_raw)
  }
  description = "A map of AKS cluster attributes: id, name, client_certificate, client_key, cluster_ca_certificate, cluster_fqdn, oidc_issuer_url, location, kube_config_raw, kube_admin_config_raw."
}
