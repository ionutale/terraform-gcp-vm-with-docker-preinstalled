terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.89.0"
    }
  }
}

provider "google" {
  project = "tutorials"
  region  = "us-central1"
  zone    = "us-central1-c"
}



resource "google_compute_instance" "vm_instance" {
  name                      = "terraform-instance"
  machine_type              = "f1-micro"
  allow_stopping_for_update = false
  boot_disk {
    initialize_params {
      image = "ubuntu-os-pro-cloud/ubuntu-pro-2004-lts"
    }
  }

  metadata_startup_script = "${file("./install.docker.sh")}"
  
  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_tr_network.self_link
    access_config {
    }
  }
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "demo-ssh"
  network = google_compute_network.vpc_tr_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  #target_tags = ["terraform-instance"]
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_network" "vpc_tr_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}
