#!/bin/sh

gunzip -c ${SCHEDULER_ARCHIVE} | tar -xf - -C ${SCHEDULER_VOLUME}/
