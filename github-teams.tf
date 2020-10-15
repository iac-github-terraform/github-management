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