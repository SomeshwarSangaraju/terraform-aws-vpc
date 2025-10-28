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