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

resource "github_membership" "team_bot" {
  username = "team-bot"
  role     = "member"
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
  repository = github_repository.github-management.name
  permission = "admin"
}

resource "github_repository" "backend_repo" {
  name        = "backend-repo"
  description = "Repo that contains back end code for ABC application"

  private                = false
  has_issues             = true
  has_wiki               = false
  allow_merge_commit     = true
  allow_squash_merge     = false
  allow_rebase_merge     = false
  auto_init              = true
  delete_branch_on_merge = true
  gitignore_template     = "Terraform"
  license_template       = "mit"
  topics                 = ["events", "java", "spring", "spring-boot"]
  default_branch         = "main"
}

# Set up baseline configs for the repo
resource "github_branch_protection" "backend_repo" {
  repository = github_repository.backend_repo.name
  branch     = "main"
//
//  required_pull_request_reviews {
//    dismiss_stale_reviews      = true
//    require_code_owner_reviews = false
//  }
}

resource "github_team" "team2" {
  name        = "team2"
  description = "Team responsible for building out infrastructure elements for backend."
  privacy     = "closed"
}

resource "github_team_membership" "team2" {
  team_id  = github_team.team2.id
  username = github_membership.team_bot.username
  role     = "admin"
}

resource "github_team_repository" "backend_repo" {
  team_id    = github_team.team2.id
  repository = github_repository.backend_repo.name
  permission = "admin"
}

resource "github_team_repository" "backend_repo_admin" {
  team_id    = github_team.team1.id
  repository = github_repository.backend_repo.name
  permission = "admin"
}