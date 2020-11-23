variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-southeast-1"
}

# variable "access_key" {}
# variable "secret_key" {}
variable "service" {}
variable "environment" {}
variable "team" {
  default = "dev"
}
variable "subnet_ids" {
    default = [ "subnet-xxxxxxxxxx",   # 10.0.1.0/24  dev-private-1a
                "subnet-xxxxxxxxxxxx" ]  # 10.0.3.0/24  dev-private-1b

}
variable "pub_subnet_ids" {
    default = [ "subnet-xxxxxxxxxxx",   # 10.0.2.0/24 dev-public-1a
                "subnet-xxxxxxxxxxxx" ]  # 10.0.4.0/24 dev-public-1b
}
variable "region" {
    default = "ap-southeast-1"
}

variable "dev-vpc-htttp-https" {
   default = "sg-xxxxxxxxxxxx"
}

variable "dev-vpc-all-local" {
   default = "sg-xxxxxxxxxxxxx"
}

variable "dev-vpc-id" {
   default = "vpc-xxxxxxxxxxxxxxxx"
}

variable "github_token" {
  
}
variable "github_user" {
  default = "amarkotasky"
}
