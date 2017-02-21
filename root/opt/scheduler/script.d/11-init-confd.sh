#!/usr/bin/with-contenv sh


exec ${SCHEDULER_VOLUME}/bin/confd -confdir ${SCHEDULER_VOLUME}/confd/etc -sync-only -onetime -backend rancher
