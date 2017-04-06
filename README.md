# Dockerfile for Yap

## Supported tags and respective `Dockerfile` links

* latest ([Dockerfile](https://github.com/yaproxy/docker-yap/blob/master/Dockerfile))
* tls1.3 ([Dockerfile](https://github.com/yaproxy/docker-yap/blob/tls1.3/Dockerfile))

## What is Yap

Yap is a HTTP1.1/HTTP2 proxy which forked and refactored from [branch vps of Goproxy](https://github.com/phuslu/goproxy/tree/server.vps)

## Usage

### Prepare for Server

* A domain: `example.org`
* Certificate for the domain: `example.org.cer`
* Key of the certificate for the domain: `example.org.key`

### Create a config file `yap.toml`

```toml
[default]
reject_nil_sni = false

[[http2]]
listen = ":443"
# server name for http2 proxy
server_name = ["example.org"]
# cert file
cert_file = "example.org.cer"
# key file
key_file = "example.org.key"

[http]
listen = ":8088"
```

### Run Yap in Docker

```
docker run -d \
    -v /path/to/yap.toml:/yap.toml \
    -v /path/to/example.cert:/example.cert \
    -v /path/to/example.key:/example.key \
    -p 443:443 \
    -p 8088:8088 \
    yaproxy/yap
```

## [WIP] Documentation

[WIP] Yap is ~~well~~ documented. Check out the documentation at [Github](https://github.com/yaproxy/yap).

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/yaproxy/docker-yap/issues).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/yaproxy/docker-yap/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
