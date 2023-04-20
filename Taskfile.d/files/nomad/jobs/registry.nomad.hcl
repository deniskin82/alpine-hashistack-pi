job "docker-registry" {
  datacenters = ["dc1"]

  group "docker-registry" {
    network {
      mode = "cni/bridge"
      port "http" {
        static = 5000
      }
    }

    service {
      name = "docker-registry"
      port = "http"

      check {
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
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
        REGISTRY_HTTP_ADDR = "0.0.0.0:5000"
        REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY = "/data"
        TZ = "America/New_York"
      }

      resources {
        cpu    = 400
        memory = 312
      }
    }
  }
}
