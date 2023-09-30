
provider "google" {
  credentials = file("../static-hosting-400505-2386ccf13d80.json")

  project = "static-hosting-400505"
  region  = "us-east1"

}
