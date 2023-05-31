# Create the mynetwork network
resource "google_compute_network" "mynetwork" {
  name = "mynetwork"
  # RESOURCE properties go here
  auto_create_subnetworks = "true"
}
# Add a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name = "mynetwork-allow-http-ssh-rdp-icmp"
  # RESOURCE properties go here
  network = google_compute_network.mynetwork.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "vm_instance" {
  name         = "mynet-us-vm"
  zone         = "us-central1-a"
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.mynetwork.self_link
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
}

resource "google_compute_instance" "vm_instance1" {
  name         = "mynet-eu-vm"
  zone         = "europe-west1-d"
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.mynetwork.self_link
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
}
# Create the mynet-us-vm instance
# module "mynet-us-vm" {
#   source           = "./instance"
#   instance_name    = "mynet-us-vm"
#   instance_zone    = "us-central1-a"
#   instance_network = google_compute_network.mynetwork.self_link
# }
# Create the mynet-eu-vm" instance
# module "mynet-eu-vm" {
#   source           = "./instance"
#   instance_name    = "mynet-eu-vm"
#   instance_zone    = "europe-west1-d"
#   instance_network = google_compute_network.mynetwork.self_link
#}