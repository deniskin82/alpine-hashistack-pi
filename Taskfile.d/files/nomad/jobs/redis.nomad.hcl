job "redis" {
  datacenters = ["dc1"]

  group "redis-group" {
    network {
      mode = "cni/bridge"
      port "redis" {
        to = 6379
      }
    }
    task "redis-task" {
      driver = "containerd-driver"

      config {
        image = "docker.io/library/redis:alpine"
      }

      resources {
        cpu    = 500
        memory = 256
        network {
          mbits = 10
        }
      }
    }
  }
}
