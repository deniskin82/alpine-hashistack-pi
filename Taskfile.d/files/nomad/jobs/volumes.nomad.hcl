job "volumes" {
  datacenters = ["dc1"]
  type = "sysbatch"
  periodic {
    cron             = "@daily"
    prohibit_overlap = true
    time_zone        = "America/New_York"
  }

  group "volume" {
    task "volumes" {
      driver = "raw_exec"
      template {
        perms = "755"
        data = <<EOH
#!/bin/sh
set -xe
mkdir -v -m 777 -p /data/volumes/netdata_cache \
  /data/volumes/netdata_data \
  /data/volumes/docker_registry/data \
  /data/volumes/docker_cache/data \
  /data/volumes/jellyfin/cache \
  /data/volumes/jellyfin/config
chmod 0777 /data/volumes/netdata_cache \
  /data/volumes/netdata_data \
  /data/volumes/docker_registry/data \
  /data/volumes/docker_cache/data \
  /data/volumes/jellyfin/cache \
  /data/volumes/jellyfin/config
sleep 3
        EOH

        destination = "tmp/mkdirs.sh"
      }
      config {
        command = "/bin/sh"
        args = ["tmp/mkdirs.sh"]
      }
    }
  }
}
