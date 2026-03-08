#!/bin/sh
set -e

CONFIG_FILE="/prometheus/data/start9/config.yaml"
PROM_CONFIG="/etc/prometheus/prometheus.yml"

echo "Starting Prometheus..."
mkdir -p /prometheus/data/start9

# ── Read user config (with defaults) ──────────────────────────────────────────
SCRAPE_INTERVAL="15s"
if [ -f "$CONFIG_FILE" ]; then
  interval=$(yq e '.scrape-interval // ""' "$CONFIG_FILE" 2>/dev/null || echo "")
  if [ -n "$interval" ] && [ "$interval" != "null" ]; then
    SCRAPE_INTERVAL="${interval}s"
  fi
fi

# ── Generate prometheus.yml ───────────────────────────────────────────────────
cat > "$PROM_CONFIG" <<EOF
global:
  scrape_interval: ${SCRAPE_INTERVAL}
  evaluation_interval: ${SCRAPE_INTERVAL}

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

# Append user-defined scrape targets
if [ -f "$CONFIG_FILE" ]; then
  TARGET_COUNT=$(yq e '.scrape-targets | length' "$CONFIG_FILE" 2>/dev/null || echo "0")
  if [ "$TARGET_COUNT" != "0" ] && [ "$TARGET_COUNT" != "null" ]; then
    i=0
    while [ "$i" -lt "$TARGET_COUNT" ]; do
      JOB_NAME=$(yq e ".scrape-targets[$i].job-name" "$CONFIG_FILE")
      HOST=$(yq e ".scrape-targets[$i].host" "$CONFIG_FILE")
      PORT=$(yq e ".scrape-targets[$i].port" "$CONFIG_FILE")
      METRICS_PATH=$(yq e ".scrape-targets[$i].metrics-path // \"/metrics\"" "$CONFIG_FILE")
      INSTANCE_NAME=$(yq e ".scrape-targets[$i].instance-name // \"\"" "$CONFIG_FILE")

      cat >> "$PROM_CONFIG" <<EOF

  - job_name: "${JOB_NAME}"
    metrics_path: "${METRICS_PATH}"
    static_configs:
      - targets: ["${HOST}:${PORT}"]
EOF

      if [ -n "$INSTANCE_NAME" ] && [ "$INSTANCE_NAME" != "null" ]; then
        cat >> "$PROM_CONFIG" <<EOF
        labels:
          instance: "${INSTANCE_NAME}"
EOF
      fi
      i=$((i + 1))
    done
  fi
fi

echo "Generated Prometheus config:"
cat "$PROM_CONFIG"
echo ""

# ── Launch Prometheus ─────────────────────────────────────────────────────────
exec /bin/prometheus \
  --config.file="$PROM_CONFIG" \
  --storage.tsdb.path=/prometheus/data \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle
