terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "no_space_left_on_device_error_when_pulling_docker_images" {
  source    = "./modules/no_space_left_on_device_error_when_pulling_docker_images"

  providers = {
    shoreline = shoreline
  }
}