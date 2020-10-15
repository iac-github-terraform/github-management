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

# Set up baseline configs for the repo
resource "github_branch_protection" "team_baseline_config" {
  repository     = github_repository.github-management.name
  branch         = "main"

  required_status_checks {
    # require up to date before merging
    strict = true
    contexts = ["iac-github-terraform/github-management"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = false
  }
}

resource "github_membership" "org_bot" {
  username = "org-bot"
  role     = "admin"
}

resource "github_team" "team1" {
  name        = "team1"
  description = "Team responsible for making magic happen"
  privacy     = "closed"
}

resource "github_team_membership" "team1" {
  team_id  = github_team.team1.id
  username = github_membership.org_bot.username
  role     = "maintainer"
}

resource "github_team_repository" "organisation_admin" {
  team_id    = github_team.team1.id
  repository = github_repository.organisation_admin.name
  permission = "admin"
}