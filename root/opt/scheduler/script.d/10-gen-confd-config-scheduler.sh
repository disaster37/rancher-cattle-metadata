#!/usr/bin/with-contenv sh

cat << EOF > ${SCHEDULER_VOLUME}/confd/etc/conf.d/scheduler.cfg.toml
[template]
prefix = "/2015-12-19"
src = "scheduler.cfg.tmpl"
dest = "${SCHEDULER_VOLUME}/conf/scheduler.cfg"
mode = "0644"
keys = [
  "/self/service",
  "/self/container",
  "/self/stack",
  "/self/host",
  "/containers",
]
reload_cmd = "s6-svscanctl -t /var/run/s6/services"
EOF
