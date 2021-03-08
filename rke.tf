terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.2.1"
    }
  }
}

module "nodes" {
  source = "./aws"
  region = var.region
  profile = var.profile
  instance_type = "t2.large"
  cluster_id    = "rke"
  common_tags = var.common_tags
}

resource "rke_cluster" "cluster" {
  cloud_provider {
    name = "aws"
  }

  nodes {
    address = module.nodes.addresses[0]

    internal_address = module.nodes.internal_ips[0]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["controlplane", "etcd"]
  }
  nodes {
    address = module.nodes.addresses[1]
    internal_address = module.nodes.internal_ips[1]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
  nodes {
    address = module.nodes.addresses[2]
    internal_address = module.nodes.internal_ips[2]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
  nodes {
    address = module.nodes.addresses[3]
    internal_address = module.nodes.internal_ips[3]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
}

//resource "local_file" "kube_cluster_yaml" {
//  filename = "~/.kube/config"
//  content  = rke_cluster.cluster.kube_config_yaml
//}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}

module "icap" {
  source = "./icap"
  depends_on = [rke_cluster.cluster]
  common_tags = var.common_tags
}

//provider "helm" {
//  kubernetes {
//    config_path = "./kube_config_cluster.yml"
//  }
//}
//
//resource "helm_release" "adaptation" {
//  name       = "adaptation"
//  chart      = "./icap/adaptation"
//  depends_on = [rke_cluster.cluster]
//}
//
//resource "helm_release" "rabbitmq" {
//  name       = "rabbitmq"
//  chart      = "./icap/rabbitmq"
//  depends_on = [rke_cluster.cluster]
//}