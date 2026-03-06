# Prometheus for StartOS

A StartOS service wrapper for [Prometheus](https://prometheus.io/) — the open-source time-series monitoring database.

## Features

- **Web UI** on port 9090 (accessible over LAN and Tor)
- **Dynamic scrape targets** — add/remove targets from the StartOS Config UI
- **Persistent TSDB data** — survives restarts and supports backup/restore
- **Self-monitoring** — always scrapes its own metrics at `localhost:9090`

## Building

### Prerequisites

- [start-sdk](https://github.com/Start9Labs/start-os/tree/master/core)
- [deno](https://deno.land/) (for bundling TypeScript scripts)
- [docker](https://www.docker.com/) with `buildx`
- [yq](https://github.com/mikefarah/yq)

### Build the package

```bash
# Full build (x86_64)
make

# Install on your StartOS server
make install
```

### Clean

```bash
make clean
```

## License

Apache-2.0 — see [LICENSE](LICENSE).
