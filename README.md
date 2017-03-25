rancher-cattle-metadata
===============

This image permit to get config from Rancher metadata and expose them on `scheduler.cfg`.
In fact, on application container we use Confd, but it doesn't permit to get config in few backend at the same time. So we source `scheduler.cfg` before run Confd and then we use `getenv` to get scheduler config.

## How use it

1. Just add this image as sidekick on your application container and set it as volume-from.
2. On your init strategy call all scripts (on begining) exposed by this image in `/opt/scheduler/script.d`.
For exemple, if you use s6-overlay add `/etc/cont-init.d/00-extract-scheduler.sh`:
```sh
#!/usr/bin/with-contenv sh
if [ -d "${SCHEDULER_VOLUME}/script.d" ]; then
  for SCRIPT in ${SCHEDULER_VOLUME}/script.d/*
	do
		if [ -f $SCRIPT ]
		then
			sh $SCRIPT
		fi
	done
fi
```
3. Then, source `/opt/scheduler/conf/scheduler.cfg` before launch Confd that manage your application setting.
```sh
#!/usr/bin/with-contenv sh
if [ "${CONFD_NODES}X" == "X" ]; then
  NODE=""
else
  NODE="-node ${CONFD_NODES}"
fi
# Get setting from scheduler
if [ -f "${SCHEDULER_VOLUME}/conf/scheduler.cfg" ]; then
  source "${SCHEDULER_VOLUME}/conf/scheduler.cfg"
fi
${CONFD_HOME}/bin/confd -confdir ${CONFD_HOME}/etc -onetime -backend ${CONFD_BACKEND} ${PREFIX} ${NODE}
```

4. To finish, add condition on your Confd template to use environment variable exposed by scheduler.cfg.
For example :
```sh
{{ if (getenv "SCHEDULER_CONTAINERS_IP") }}
  # Use setting provided by scheduler
{{ else }}
  # Use setting that you provide
{{ end }}
```

## Data exposed by scheduler

The following environment variable are exposed by `scheduler.cfg`:
- **SCHEDULER_CONTAINERS_IP**: The list of primary IP for each containers that composed the current service separated by coma. For example "10.0.0.1,10.0.0.2,10.0.0.3".
- **SCHEDULER_CONTAINER_IP**: The primary IP of the current container. For example "10.0.0.1".
- **SCHEDULER_CONTAINER_NAME**: The name of the current container.
- **SCHEDULER_CONTAINER_INDEX**: The index of the current container.
- **SCHEDULER_CONTAINER_STATE**: The state of the current container.
- **SCHEDULER_SERVICE_NAME**: The name of the current service.
- **SCHEDULER_SERVICE_SCALE**: The number of instance in the current service.
- **SCHEDULER_SERVICE_PORTS**: The list of ports exposed in the current server, separated by coma.
- **SCHEDULER_STACK_NAME**: The name of the current stack.
- **SCHEDULER_HOST_NAME**: The name of the current host.
- **SCHEDULER_HOST_IP**: The public IP of the current host.
- **SCHEDULER_HOST_HOSTNAME**: The hostname of the current host.
- **SCHEDULER_CONTAINERS_COUNT**: The number of current instance that exist on service
