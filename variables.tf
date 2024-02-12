variable "ap_southeast_1_region" {
  description = "AWS region for the ap-southeast-1"
  type        = string
  default     = "ap-southeast-1"
}

variable "ap_southeast_3_region" {
  description = "AWS region for the ap-southeast-3 (jakarta)"
  type        = string
  default     = "ap-southeast-3"
}

variable "image_ap_southeast_1" {
  description = "Image for ap_southeast_1 region"
  type        = string
  default     = "ami-0fa377108253bf620"
}

variable "image_ap_southeast_3" {
  description = "Image for ap_southeast_3 region"
  type        = string
  default     = "ami-02157887724ade8ba"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
}

variable "session_token" {
  description = "AWS session token"
}