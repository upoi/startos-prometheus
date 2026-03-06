FROM alpine:3.20 AS tools

# Download yq static binary
ARG TARGETARCH
RUN apk add --no-cache wget && \
    case "${TARGETARCH}" in \
      amd64) YQ_ARCH="amd64" ;; \
      arm64) YQ_ARCH="arm64" ;; \
      *) YQ_ARCH="amd64" ;; \
    esac && \
    wget -qO /usr/local/bin/yq \
      "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" && \
    chmod +x /usr/local/bin/yq

FROM prom/prometheus:latest

USER root

# Copy yq from builder
COPY --from=tools /usr/local/bin/yq /usr/local/bin/yq

COPY docker_entrypoint.sh /docker_entrypoint.sh
RUN chmod +x /docker_entrypoint.sh

ENTRYPOINT ["/docker_entrypoint.sh"]
