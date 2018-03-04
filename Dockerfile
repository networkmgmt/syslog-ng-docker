FROM alpine:3.7
MAINTAINER Tsubasa Nagano <networkmgmt [at] icloud.com>

RUN adduser -D -H -s /sbin/nologin syslog syslog
RUN set -ex && \
    apk update && \
    apk add --no-cache \
        syslog-ng \
        dumb-init \
        tzdata \
    && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

VOLUME ["/var/log/syslog"]
COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

EXPOSE     514 514/udp
ENTRYPOINT ["/usr/bin/dumb-init", "--", \
            "syslog-ng", "--foreground", "--stderr", "--worker-threads=4"]
