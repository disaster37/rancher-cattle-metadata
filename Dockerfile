FROM alpine:3.5
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Set environment
ENV SCHEDULER_VOLUME=/opt/scheduler \
    SCHEDULER_ARCHIVE=/opt/scheduler.tgz


# Install confd
ENV CONFD_VERSION="v0.13.6" \
    CONFD_HOME="/opt/confd"
ADD https://github.com/yunify/confd/releases/download/${CONFD_VERSION}/confd-alpine-amd64.tar.gz ${SCHEDULER_VOLUME}/confd/bin/
RUN \
    mkdir -p "${SCHEDULER_VOLUME}/confd/etc/conf.d" "${SCHEDULER_VOLUME}/confd/etc/templates" &&\
    tar -xvzf "${SCHEDULER_VOLUME}/confd/bin/confd-alpine-amd64.tar.gz" -C "${SCHEDULER_VOLUME}/confd/bin/" &&\
    rm "${SCHEDULER_VOLUME}/confd/bin/confd-alpine-amd64.tar.gz"

# Add files
ADD root /
RUN \
    cd ${SCHEDULER_VOLUME} && \
    mkdir -p ${SCHEDULER_VOLUME}/conf && \
    tar czvf ${SCHEDULER_ARCHIVE} * && \
    rm -rf ${SCHEDULER_VOLUME}/* && \
    chmod +x /docker-entrypoint.sh


VOLUME ["${SCHEDULER_VOLUME}"]
ENTRYPOINT "/docker-entrypoint.sh"
