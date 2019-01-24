#!/usr/bin/with-contenv sh

log() {
        echo `date` $ME - $@
}

checkNetwork() {
    log "[ Checking container ip... ]"
    a="`ip a s dev eth0 &> /dev/null; echo $?`"
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`"
        sleep 1
    done

    log "[ Checking container connectivity... ]"
    b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
    while [ $b -eq 1 ];
    do
        b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
        sleep 1
    done
}

waitScaleContainers() {
  log "[ Checking service scale...]"
  loop="true"
  while [ "$loop" == "true" ]; do
    ${SCHEDULER_VOLUME}/confd/bin/confd -confdir ${SCHEDULER_VOLUME}/confd/etc -onetime -backend rancher
    source "${SCHEDULER_VOLUME}/conf/scheduler.cfg"
    if [ "$SCHEDULER_CONTAINERS_COUNT" -ge "$SCHEDULER_SERVICE_SCALE" ]; then
      loop="false"
    else
      sleep 10
    fi
  done
}


checkNetwork
waitScaleContainers

${SCHEDULER_VOLUME}/confd/bin/confd -confdir ${SCHEDULER_VOLUME}/confd/etc -onetime -backend rancher
