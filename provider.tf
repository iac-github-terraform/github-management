# Configure the GitHub Provider
provider "github" {
  version      = "~> 2.4"
  organization = "iac-github-terraform"
  # Export the GITHUB_TOKEN as an environment variable
}