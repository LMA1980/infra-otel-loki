FROM alpine:latest

# Set environment variables
ENV LOKI_VERSION="2.9.0" # Use a specific version for Loki
ENV LOKI_CONFIG_FILE="/etc/loki/config.yaml"

# Install dependencies and download Loki
RUN apk add --no-cache \
    ca-certificates \
    wget \
    unzip \
    # Download Loki binary
    && wget -q -O /tmp/loki.zip "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip" \
    && unzip /tmp/loki.zip -d /usr/local/bin \
    && mv /usr/local/bin/loki-linux-amd64 /usr/local/bin/loki \
    && rm /tmp/loki.zip \
    && chmod +x /usr/local/bin/loki \
    # Create configuration directory
    && mkdir -p /etc/loki \
    # Create data directory
    && mkdir -p /var/lib/loki

# Expose Loki's default HTTP port
EXPOSE 3100

# User for running Loki
USER nobody

# Command to run Loki
ENTRYPOINT ["/usr/local/bin/loki"]
CMD ["-config.file=/etc/loki/config.yaml"]
