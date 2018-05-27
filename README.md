# docker-template

This base image contain a Jinja renderer script that can be used to generate
your configuration files from environment variables. For example, this is
useful to pass variables to a `nginx.conf` at build time.

## How to build

`docker build -t docker-template .`

## Example

### Setup

example.conf.tpl:

```
Welcome to {{ repository }} v{{ version }}!

{%- for what in adjectives|listify %}
  {{ repository|title }} is {{ what }}!
{%- endfor %}
```

Dockerfile-example:

```
# Set environment variables in the base image or through --build-arg
FROM docker-template AS cfg
ENV repository "docker-template"
ARG version="0.0.1"
ENV adjectives='["extremely impressive","breathtaking","wonderful","stunning"]'
ADD example.conf.tpl /etc/example/example.conf.tpl
RUN ./template/tpl.py /etc/example/example.conf.tpl

# Copy the conf file generated from the base image
FROM mhart/alpine-node:10.1.0@sha256:68951567a1525fefb7159e16ee6892eb6faa16c87d86d9b4f4eed672b270f40f
COPY --from=cfg /etc/example/example.conf /etc/example/example.conf
RUN cat /etc/example/example.conf
```

### How to build

`docker build --build-arg version=0.0.2 -t example -f Dockerfile-example .`
