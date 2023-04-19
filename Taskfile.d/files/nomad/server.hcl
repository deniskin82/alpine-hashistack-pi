data_dir             = "NOMAD_DATADIR"
disable_update_check = true
enable_syslog        = true
plugin_dir           = "/usr/lib/nomad/plugins"

server {
  enabled          = true
  bootstrap_expect = 1
  encrypt          = "ENCRYPT_KEY"
}

client {
  enabled = true

  # CNI-related settings
  cni_config_dir = "/etc/cni"
  cni_path = "/usr/libexec/cni"

  options {
    # Uncomment to disable some drivers
    driver.denylist = "java,docker"

    # Disable some fingerprinting
    fingerprint.denylist = "env_aws,env_azure,env_digitalocean,env_gce"
  }
}

ui {
  # Uncomment to enable UI, it will listen on port 4646
  enabled = true
}

plugin "containerd-driver" {
  config {
      enabled = true
      containerd_runtime = "io.containerd.runc.v2"
      stats_interval = "5s"
  }
}
