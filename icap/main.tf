provider "kubernetes" {
  config_path = "./kube_config_cluster.yml"
  config_context = "current"
}

resource "kubernetes_namespace" "ns-icap-adaptation" {
  metadata {
    name = "icap-adaptation"
  }
}


resource "kubernetes_secret" "docker-registry" {
  metadata {
    name = "regcred"
  }

  data = {
    ".dockerconfigjson" = data.template_file.docker_config_script.rendered
  }
  type = "kubernetes.io/dockerconfigjson"
}


data "template_file" "docker_config_script" {
  template = file("${path.module}/config.json")
  vars = {
    docker-username           = var.registry_username
    docker-password           = var.registry_password
    docker-server             = var.registry_server
    docker-email              = var.registry_email
    auth                      = base64encode("${var.registry_username}:${var.registry_password}")
  }
}


//resource "kubernetes_secret" "docker-registry" {
//  metadata {
//    name = "regcred"
//    namespace = "ns-icap-adaptation"
//  }
//  data =
//  {
//    ".dockerconfigjson" = <<DOCKER
//      {
//      "auths":
//        {"${var.registry_server}":
//          {
//            "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
//          }
//        }
//      }
//    DOCKER
//  }
//  type = "kubernetes.io/dockerconfigjson"
//}


//resource "kubernetes_secret" "example" {
//  metadata {
//    name = "docker-cfg"
//  }
//
//  data = {
//    ".dockerconfigjson" = "${file("${path.module}/.docker/config.json")}"
//  }
//
//  type = "kubernetes.io/dockerconfigjson"
//}

//$ kubectl create secret docker-registry docker-cfg
//--docker-server=${registry_server}
//--docker-username=${registry_username}
//--docker-password=${registry_password}

//kubectl create -n icap-adaptation secret docker-registry regcred	\
//	--docker-server=https://index.docker.io/v1/ 	\
//	--docker-username=<username>	\
//	--docker-password=<password>	\
//	--docker-email=<email address>

//todo
//resource "kubernetes_secret" "docker-registry" {
//  metadata {
//    name = "regsecret"
//  }
//
//  data = {
//    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
//  }
//
//  type = "kubernetes.io/dockerconfigjson"
//}
//
//
//data "template_file" "docker_config_script" {
//  template = "${file("${path.module}/config.json")}"
//  vars = {
//    docker-username           = "${var.docker-username}"
//    docker-password           = "${var.docker-password}"
//    docker-server             = "${var.docker-server}"
//    docker-email              = "${var.docker-email}"
//    auth                      = base64encode("${var.docker-username}:${var.docker-password}")
//  }
//}

//===========helm====================
provider "helm" {
  kubernetes {
    config_path = "./kube_config_cluster.yml"
  }
}

resource "helm_release" "adaptation" {
  name = "adaptation"
  chart = "./icap/adaptation"
}

resource "helm_release" "rabbitmq" {
  name = "rabbitmq"
  chart = "./icap/rabbitmq"
}