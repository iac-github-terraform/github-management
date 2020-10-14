# Add the terraform cloud backend for running locally
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "terraform-cloud-iac-github"

    workspaces {
      name = "github-management"
    }
  }
}