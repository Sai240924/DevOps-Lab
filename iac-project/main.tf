terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "random" {}

resource "random_pet" "server" {}
output "pet_name" {
  value = random_pet.server.id
}