variable "admin_user_ids" {
  description = "User Ids for the Admin"
  type = list(string)
  defadefault = [ "" ]  
}

variable "editor_user_ids" {
  description = "User Ids for the Editor"
  type = list(string)
  defadefault = [ "" ]  
}
variable "viewer_user_ids" {
  description = "User Ids for the Viewer"
  type = list(string)
  defadefault = [ "" ]  
}

variable "grafana_name" {
  description = "Name for the Grafana"
  default = "grafana"
  type = string
}

variable "data_sources" {
  description = "data sources for grafana"
  type = list(string)
  defadefault = [ "CLOUDWATCH" ]  
}