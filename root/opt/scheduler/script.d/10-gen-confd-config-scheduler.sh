#!/usr/bin/with-contenv sh

exec cat << EOF > ${SCHEDULER_VOLUME}/confd/etc/conf.d/scheduler.cfg.toml
[template]
prefix = "/2015-12-19/self"
src = "scheduler.cfg.tmpl"
dest = "${SCHEDULER_VOLUME}/conf/scheduler.cfg"
mode = "0644"
keys = [
  "service",
  "container",
  "stack",
  "host"
]
EOF
