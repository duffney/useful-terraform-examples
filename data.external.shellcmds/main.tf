terraform {
  required_providers {
  }
}

# Pass input and execute a shell script
data "external" "passInput" {
  program = ["${path.module}/script.sh"]
    query = {
    name = "abc123"
  }
}

# Output a variable from the shell script
output "args" {
  value = data.external.token.result["name"]
}