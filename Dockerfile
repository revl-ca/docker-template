FROM python:3-alpine@sha256:3f9e4710fc0dfb2aeaa32016bd8a0805f90612e61b5fc5b1194e1d9d1f7edca2 AS pip
RUN apk add --no-cache py-pip

FROM pip AS jinja
RUN pip install jinja2
RUN apk del py-pip

FROM python:3-alpine@sha256:3f9e4710fc0dfb2aeaa32016bd8a0805f90612e61b5fc5b1194e1d9d1f7edca2
LABEL org.label-schema.description="This base image contain a Jinja renderer script that can be used to generate your configuration files from environment variables." \
      org.label-schema.name="Docker Template" \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.label-schema.vcs-url="https://github.com/revl-ca/docker-template" \
      org.label-schema.vendor="REVL" \
      org.label-schema.version="1.0.0"
ENV PACKAGES_PATH "/usr/local/lib/python3.6/site-packages/"
COPY --from=jinja ${PACKAGES_PATH} ${PACKAGES_PATH}
ADD tpl.py /template/
RUN chmod +x /template/tpl.py
