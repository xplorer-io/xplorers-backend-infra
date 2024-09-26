variable "CLOUDFLARE_API_TOKEN" {
  type      = string
  sensitive = true
}
variable "cloudflare_account_id" {
  type      = string
  sensitive = true
}
variable "domain" {
  default = "xplorers.tech"
}
