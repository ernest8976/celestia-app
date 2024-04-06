# stage 1 Generate celestia-appd Binary
FROM docker.io/golang:1.21.0-alpine3.18 as builder
# hadolint ignore=DL3018

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

RUN uname -a && apk update && apk add --no-cache \
    gcc \
    git \
    linux-headers \
    make \
    musl-dev

COPY . /celestia-app
WORKDIR /celestia-app
RUN make build


# stage 2
FROM docker.io/alpine:3.18.2

ENV CELESTIA_HOME=/home/${USER_NAME}

# hadolint ignore=DL3018
RUN apk update && apk add --no-cache bash

# Copy in the binary
COPY --from=builder /celestia-app/build/celestia-appd /bin/celestia-appd
COPY  docker/entrypoint.sh /opt/entrypoint.sh

# p2p, rpc and prometheus port
EXPOSE 26656 26657 1317 9090

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
CMD [ "celestia-appd" ]
