
provider "google" {
  credentials = file("../static-hosting-400505-2386ccf13d80.json")

  project = var.gcp_project
  region  = "us-east1"

}
