FROM alpine:3.5

RUN apk add --no-cache ca-certificates

# https://golang.org/issue/14851
COPY no-pic.patch /

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        bash \
        gcc \
        musl-dev \
        openssl \
        go \
        git \
    \
    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    \
    && git clone -b tls13 --depth 1 https://github.com/phuslu/go /usr/local/go \
    && cd /usr/local/go/src \
    && patch -p2 -i /no-pic.patch \
    && ./make.bash \
    \
    && rm -rf /*.patch \
    && export GOPATH=/go \
    && export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
    && mkdir -p $GOPATH/src/github.com/yaproxy/ && cd $GOPATH/src/github.com/yaproxy/ \
    && git clone -b tls1.3 https://github.com/yaproxy/yap.git && cd yap \
    && export CGO_ENABLED=0 && go get ./... \
    && cd $GOPATH/src/github.com/yaproxy/libyap && git checkout tls1.3 \
    && cd $GOPATH/src/github.com/yaproxy/yap \
    && go build -o /usr/local/bin/yap cli/main.go \
    && cp yap.toml / \
    && cd / && rm -rf /go /usr/local/go \
    && apk del .build-deps

EXPOSE 443 8088
CMD ["/usr/local/bin/yap", "/yap.toml"]
