terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

# Nathan - create tf state storage
resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-tf-zoom-backend"
  location = "US"

  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }

  }

  versioning {
    enabled = true
  }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  # You can store the template in a file and use the templatefile function for
  # more modularity, if you prefer, instead of storing the template inline as
  # we do here.
  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT
}

# Nathan - create vm
# resource "google_compute_instance" "default" {
#   name         = "my-vm"
#   machine_type = "n1-standard-1"
#   zone         = "us-central1-a"

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
#     }
#   }

#   network_interface {
#     network = "default"
#     access_config {}
#   }
# }

# resource "google_storage_bucket" "zoom-bucket" {
#   name          = var.gcs_bucket_name
#   location      = var.location
#   force_destroy = true


#   lifecycle_rule {
#     condition {
#       age = 1
#     }
#     action {
#       type = "AbortIncompleteMultipartUpload"
#     }
#   }
# }

resource "google_bigquery_dataset" "zoom_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}