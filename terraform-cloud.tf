terraform {
  cloud {
    organization = "example-org-a49b7a"

    workspaces {
      name = "Migration"
    }
  }
}