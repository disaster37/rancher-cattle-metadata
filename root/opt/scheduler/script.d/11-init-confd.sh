#!/usr/bin/with-contenv sh

function log {
        echo `date` $ME - $@ >> ${CONF_LOG}
}

function checkNetwork {
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


checkNetwork

${SCHEDULER_VOLUME}/confd/bin/confd -confdir ${SCHEDULER_VOLUME}/confd/etc -onetime -backend rancher
