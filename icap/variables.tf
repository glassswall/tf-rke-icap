# Input variable definitions
variable "common_tags" {}
variable "registry_server" {
  default = "https://index.docker.io/v1/"
}
variable "docker_username" {
  default = "khawarhere"
}
variable "docker_password" {
}
variable "docker_email" {
  default = "khawarhere@gmail.com"
}