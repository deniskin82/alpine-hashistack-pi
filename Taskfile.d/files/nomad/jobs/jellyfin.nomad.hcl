job "dlna" {
  datacenters = ["dc1"]

  group "dlna-group" {
    network {
      mode = "cni/bridge"
      port "jellyfin" {
        to = 8096
      }
    }

    task "jellyfin" {
      driver = "containerd-driver"

      config {
        image = "docker.io/jellyfin/jellyfin:10.8.10"
        mounts = [{
          type    = "bind"
          source  = "/data/volumes/jellyfin/config"
          target  = "/config"
          options = ["rbind", "rw"]
        },{
          type    = "bind"
          source  = "/data/volumes/jellyfin/cache"
          target  = "/cache"
          options = ["rbind", "rw"]
        }]
      }

      env {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1"
      }

      service {
        tags = ["jellyfin"]

        name     = "jellyfin"
        port     = "jellyfin"
        provider = "consul"

        check {
          name     = "jellyfin port alive"
          type     = "tcp"
          port     = "jellyfin"
          interval = "30s"
          timeout  = "3s"
        }
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
