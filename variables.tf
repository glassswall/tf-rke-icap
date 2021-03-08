# Input variable definitions
variable "common_tags" {
  description = "General Tags to apply to resources created"
  type        = map(string)
  default = {
    Service = "ICAP Cluster"
    Owner   = "Furqan"
    Delete  = "Yes"
    Team    = "DevOps"
    Scope   = "Created for icap demo"
    Terraform   = "Yes"
  }
}

variable "region" {
  default     = "$(var.region)"
}

variable "aws_access_key_id" {
  default     = "$(var.aws_access_key_id)"
}

variable "aws_secret_access_key" {
  default     = "$(var.aws_secret_access_key)"
}