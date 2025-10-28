locals{
    common_tags ={
        project_name=var.project_name
        environment=var.environment
        terraform= true
    }
    common_suffix_name="${var.project_name}-${var.environment}"
}