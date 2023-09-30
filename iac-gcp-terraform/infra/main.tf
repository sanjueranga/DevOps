# Create bucket

resource "google_storage_bucket" "website" {
  name     = "sanju-terraform-demo"
  location = "US"
}



# Upload files
resource "google_storage_bucket_object" "static_site_src" {
  name         = "index.html"
  source       = "../src/index.html"
  content_type = "text/html"
  bucket       = google_storage_bucket.website.name
}


# Make bucket public
resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.static_site_src.name
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

