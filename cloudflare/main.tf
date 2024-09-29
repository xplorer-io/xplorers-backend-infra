resource "cloudflare_zone" "xplorers" {
  account_id          = var.cloudflare_account_id
  jump_start          = null
  paused              = false
  plan                = "free"
  type                = "full"
  vanity_name_servers = []
  zone                = var.domain
}
resource "cloudflare_record" "xplorer_A_1" {
  name    = "xplorers.tech"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "76.76.21.21"
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_CNAME_1" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "cname.vercel-dns.com"
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_TXT_1" {
  name    = "_dmarc"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=DMARC1; p=none; rua=mailto:dmarc-report@xplorers.tech; ruf=mailto:dmarc-failures@xplorers.tech; fo=1"
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_TXT_2" {
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_TXT_3" {
  name    = "*._domainkey"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DKIM1; p="
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_TXT_4" {
  name    = "xplorers.tech"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com ~all"
  zone_id = cloudflare_zone.xplorers.id
}

resource "cloudflare_record" "xplorer_TXT_5" {
  name    = "xplorers.tech"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "hcp-domain-verification=bd3cf9469e22b933c6ad349a8f97ad5c08ff4174e22c4aa911f75d9e261ee6e1"
  zone_id = cloudflare_zone.xplorers.id
}
