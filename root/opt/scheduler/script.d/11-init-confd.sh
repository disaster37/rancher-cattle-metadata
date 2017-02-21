#!/usr/bin/with-contenv sh

${SCHEDULER_VOLUME}/confd/bin/confd -confdir ${SCHEDULER_VOLUME}/confd/etc -sync-only -onetime -backend rancher
