FROM innovanon/poobuntu:latest
MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>

LABEL version="1.0"                                                       \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>"   \
      about="dockerized apt-cacher-ng"                                    \
      org.label-schema.build-date=$BUILD_DATE                             \
      org.label-schema.license="PDL (Public Domain License)"              \
      org.label-schema.name="apt-cacher-ng"                               \
      org.label-schema.url="InnovAnon-Inc.github.io/docker-apt-cacher-ng" \
      org.label-schema.vcs-ref=$VCS_REF                                   \
      org.label-schema.vcs-type="Git"                                     \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker-apt-cacher-ng"

ENV APT_CACHER_NG_VERSION=3.1                        \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng     \
    APT_CACHER_NG_USER=apt-cacher-ng

#RUN DEBIAN_FRONTEND=noninteractive apt install \
#      apt-cacher-ng=${APT_CACHER_NG_VERSION}* ca-certificates wget \
# && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
# && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf

COPY entrypoint.sh /sbin/entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive apt-fast install apt-cacher-ng ca-certificates \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf        \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 \
 && ./poobuntu-clean.sh \
 \
 && chmod 755 /sbin/entrypoint.sh
#RUN rm -v dpkg.list

#COPY entrypoint.sh /sbin/entrypoint.sh

#RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD pcurl http://localhost:3142/acng-report.html > /dev/null || exit 1
#    CMD wget -q -t1 -o /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]

