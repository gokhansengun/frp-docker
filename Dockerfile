FROM alpine:3.8

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETARCH
ARG TARGETOS

ARG frp_version=0.36.2

ADD ./docker-entrypoint.sh /

RUN apk add --virtual .build-dependencies --no-cache openssl

RUN chmod +x /docker-entrypoint.sh \
  && mkdir -p /etc/frp \
  && cd /tmp \
  && wget -O frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${frp_version}/frp_${frp_version}_${TARGETOS}_${TARGETARCH}.tar.gz" \
  && tar -xzf frp.tar.gz \
  && mv ./frp_${frp_version}_${TARGETOS}_${TARGETARCH}/frpc /usr/local/bin \
  && mv ./frp_${frp_version}_${TARGETOS}_${TARGETARCH}/frps /usr/local/bin \
  && rm -rf /tmp/*

RUN apk del .build-dependencies

WORKDIR /etc/frp

ENTRYPOINT ["/docker-entrypoint.sh"]
