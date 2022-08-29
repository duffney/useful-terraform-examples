terraform {
  required_providers {
  }
}

# Pass input and execute a shell script
data "external" "passInput" {
  program = ["${path.module}/script.sh"]
  query = {
    name = "abc123"
    email = "abc123@example.com"
  }
}

# Output a variable from the shell script
output "name" {
  value = data.external.passInput.result["name"]
}

output "email" {
  value = data.external.passInput.result["email"]
}