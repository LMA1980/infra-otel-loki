FROM alpine:latest

# Set environment variables
## Use a specific version for Loki
ENV LOKI_VERSION="2.9.0" 
ENV LOKI_CONFIG_FILE="/etc/loki/config.yaml"

# Install dependencies and download Loki
RUN apk add --no-cache \
    ca-certificates \
    wget \
    unzip
# Download Loki binary
RUN wget -q -O /tmp/loki.zip "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
RUN unzip /tmp/loki.zip -d /usr/local/bin
RUN mv /usr/local/bin/loki-linux-amd64 /usr/local/bin/loki
RUN rm /tmp/loki.zip
RUN chmod +x /usr/local/bin/loki
# Create configuration directory
RUN mkdir -p /etc/loki
# Create data directory
RUN mkdir -p /var/lib/loki

# Expose Loki's default HTTP port
EXPOSE 3100

# User for running Loki
USER nobody

# Command to run Loki
ENTRYPOINT ["/usr/local/bin/loki"]
CMD ["-config.file=/etc/loki/config.yaml"]
