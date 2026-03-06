# Prometheus — Installation Instructions

## Overview

Prometheus is a time-series monitoring database that scrapes metrics from targets across your network. It includes a built-in web UI for querying data with PromQL.

## Getting Started

### 1. Install the Service

Install "Prometheus" from the StartOS marketplace or sideload the `.s9pk` file.

### 2. Access the Web Interface

After starting the service, open the Prometheus UI:
- **LAN**: `https://<your-server>.local` (port 443, SSL-terminated)
- **Tor**: Check the service details in StartOS for your `.onion` address

### 3. Add Scrape Targets

Go to **Services → Prometheus → Config** in the StartOS dashboard to add your network targets:

1. Click **Add** under "Scrape Targets"
2. Fill in:
   - **Job Name**: a unique label (e.g. `raspberry-pi`)
   - **Host**: the IP address or hostname (e.g. Tailscale IP `100.64.0.5`)
   - **Port**: the exporter port (e.g. `9100` for node_exporter)
   - **Metrics Path**: usually `/metrics`
3. Save the config — Prometheus will restart with the new targets

A **self-monitoring job** (`localhost:9090`) is always included automatically.

### 4. Verify Targets

In the Prometheus UI, navigate to **Status → Targets** to confirm all targets are being scraped successfully.

## Data Persistence

All time-series data is stored on a persistent volume. Data survives service restarts and can be backed up / restored through the StartOS dashboard.

## Useful PromQL Queries

```promql
# CPU usage (requires node_exporter)
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage (requires node_exporter)
node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes

# Prometheus scrape duration
prometheus_target_interval_length_seconds
```

## Troubleshooting

### Targets showing as "DOWN"
- Verify the target host is reachable from your StartOS server
- Check that the exporter is running on the target and the port is correct
- If using Tailscale, ensure both devices are on the same tailnet

### Service not starting
Check the service logs in the StartOS dashboard for error messages.
