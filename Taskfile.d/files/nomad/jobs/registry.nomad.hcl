job "docker-registry" {
  datacenters = ["dc1"]

  group "docker-registry" {
    network {
      mode = "cni/bridge"
      port "http" {
        static = 5000
      }
    }

    // volume "docker_registry" {
    //   type            = "csi"
    //   source          = "docker_registry"
    //   read_only       = false
    //   attachment_mode = "file-system"
    //   access_mode     = "multi-node-multi-writer"
    // }

    service {
      name = "docker-registry"
      port = "http"

      check {
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }

      // check {
      //   name     = "service: docker registry readiness check"
      //   type     = "http"
      //   path     = "/"
      //   interval = "10s"
      //   timeout  = "2s"
      //   protocol = "http"

      //   success_before_passing   = "3"
      //   failures_before_critical = "3"

      //   check_restart {
      //     limit = 3
      //     grace = "60s"
      //   }
      // }
    }

    task "registry" {
      driver = "containerd-driver"
      
      config {
        image = "registry:2.8.1"
        mounts = [{
          type    = "bind"
          source  = "/data/volumes/docker_registry/data"
          target  = "/data"
          options = ["rbind", "rw"]
        }]
      }

      env {
        REGISTRY_HTTP_ADDR            = "0.0.0.0:5000"
        REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY = "/data"
        TZ = "America/New_York"
      }

      resources {
        cpu    = 400
        memory = 312
      }

      // volume_mount {
      //   volume      = "docker_registry"
      //   destination = "/var/lib/registry"
      // }

//       template {
//         destination = "/secrets/cert.pem"
//         perms       = "644"
//         data        = <<EOF
// {{ $ip_sans := printf "ip_sans=%s" (env "NOMAD_IP_https") }}
// {{ with secret "pki/intermediate/issue/${var.vault_cert_role}" "common_name=docker-registry.service.consul" $ip_sans }}
// {{ .Data.certificate }}{{ end }}
// {{ with secret "pki/intermediate/issue/${var.vault_cert_role}" "common_name=docker-registry.service.consul" $ip_sans }}
// {{ .Data.issuing_ca }}{{ end }}
//           EOF
//       }

//       template {
//         destination = "/secrets/key.pem"
//         perms       = "444"
//         data        = <<EOF
// {{ $ip_sans := printf "ip_sans=%s" (env "NOMAD_IP_https") }}
// {{ with secret "pki/intermediate/issue/${var.vault_cert_role}" "common_name=docker-registry.service.consul" $ip_sans }}
// {{ .Data.private_key }}{{ end }}
//           EOF
//       }

      // scaling "cpu" {
      //   enabled = true
      //   max     = 2000

      //   policy {
      //     cooldown            = "72h"
      //     evaluation_interval = "72h"

      //     check "95pct" {
      //       strategy "app-sizing-percentile" {
      //         percentile = "95"
      //       }
      //     }
      //   }
      // }

      // scaling "mem" {
      //   enabled = true
      //   max     = 1024

      //   policy {
      //     cooldown            = "72h"
      //     evaluation_interval = "72h"

      //     check "max" {
      //       strategy "app-sizing-max" {}
      //     }
      //   }
      // }
    }
  }
}
