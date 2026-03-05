variable "project" {
    type = string
}


variable "environment" {
    type = string
    validation {
      condition = contains(["dev","uat", "prod"], var.environment)
      error_message = "environments should be one of dev, qa, dev, or prod "
    }
  
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map 
    default = {}
}


variable "igw_tags" {
    type = map 
    default = {}
  
}

variable "public_subnet_cidrs" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "public_subnet_tags" {
    type = map 
    default = {}
}

variable "private_subnet_cidrs" {
    type = list 
    default = ["10.0.11.0/24","10.0.12.0/24"]  
}

variable "private_subnet_tags" {
    type = map 
    default = {}
}

variable "database_subnet_cidrs" {
    type = list 
    default = ["10.0.11.0/24","10.0.12.0/24"]  
}

variable "database_subnet_tags" {
    type = map 
    default = {}
}


variable "public_route_table_tags" {
    default = {}
    type = map
}

variable "private_route_table_tags" {
    default = {}
    type = map
}

variable "database_route_table_tags" {
    default = {}
    type = map
}
