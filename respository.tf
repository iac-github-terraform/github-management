# The terraform resource for the repository
resource "github_repository" "github-management" {
  name        = "github-management"
  description = "Terraform based repository to manage all our GutHub repositories"

  private            = false
  has_issues         = true
  has_wiki           = false
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true
  auto_init          = false
  topics             = ["config", "terraform"]
}