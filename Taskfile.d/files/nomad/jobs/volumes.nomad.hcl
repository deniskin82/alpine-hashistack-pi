job "volumes" {
  datacenters = ["dc1"]
  type = "sysbatch"
  group "volume" {
    task "netdata" {
      driver = "raw_exec"
      template {
        perms = "755"
        data = <<EOH
        #!/bin/sh
        set -xe
        mkdir -v -m 777 -p /data/volumes/netdata_cache /data/volumes/netdata_data
        chmod 0777 /data/volumes/netdata_cache /data/volumes/netdata_data
        sleep 10
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
