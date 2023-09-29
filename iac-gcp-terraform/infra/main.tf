# Create bucket

resource "google_storage_bucket" "website" {
  name     = "sanju-terraform-demo"
  location = "US"
}

# Make bucket public
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

# Upload files
resource "google_storage_bucket_object" "static_site_src" {
  name         = "index.html"
  source       = "../src/index.html"
  content_type = "text/plain"
  bucket       = google_storage_bucket.website.name
}

resource "google_compute_global_address" "website_ip" {
  name = "website-lb-ip"
}
