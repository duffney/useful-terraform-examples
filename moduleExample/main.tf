terraform {
  required_providers {
  }
}

# Deploy resource with the prefix
module "deployInfra" {
  source = "./modules/deployInfra"
}

# Configure infra using value from deploy
module "configInfra" {
  source = "./modules/configInfra"
  resource_group_name = module.deployInfra.resource_group_name
}