variable "vpc_cidr"{
    default="10.0.0.0/16"
    description="please provide vpc cidr"
}

variable "instance_tentency"{
    default="default"
}

variable "project_name"{
    default="roboshop"
}

variable "environment"{
    default="dev"
}

variable "vpc_tags"{
    type=map
    default={}
}

variable "igw_tags"{
    type=map
    default={}
}

variable "public_subnet_cidr"{
    type=list
}

variable "private_subnet_cidr"{
    type=list
}

variable "database_subnet_cidr"{
    type=list
}

variable "public_subnet_tags"{
    type=map
    default={}
}

variable "private_subnet_tags"{
    type=map
    default={}
}

variable "database_subnet_tags"{
    type=map
    default={}
}

variable "public_route_table_tags"{
   type=map
    default={}
}

variable "private_route_table_tags"{
   type=map
    default={}
}

variable "database_route_table_tags"{
   type=map
    default={}
}

variable "elastic_ip_tags"{
    type=map
    default={}
}

variable "nat_tags"{
    type=map
    default={}
}