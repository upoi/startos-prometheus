import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
    "scrape-interval": {
        type: "number",
        name: "Scrape Interval",
        description:
            "How often Prometheus scrapes metrics from targets, in seconds.",
        nullable: false,
        integral: true,
        units: "seconds",
        range: "[5, *)",
        default: 15,
    },
    "scrape-targets": {
        type: "list",
        subtype: "object",
        name: "Scrape Targets",
        description:
            "Network endpoints that Prometheus will scrape for metrics. A self-monitoring job (localhost:9090) is always included automatically.",
        range: "[0, *)",
        default: [],
        spec: {
            spec: {
                "job-name": {
                    type: "string",
                    name: "Job Name",
                    description:
                        'A unique name for this scrape job (e.g. "raspberry-pi", "gpu-server").',
                    nullable: false,
                    placeholder: "my-node",
                    pattern: "^[a-zA-Z_][a-zA-Z0-9_-]*$",
                    "pattern-description":
                        "Must start with a letter or underscore, followed by letters, numbers, underscores, or hyphens.",
                    default: "",
                },
                host: {
                    type: "string",
                    name: "Host",
                    description:
                        "IP address or hostname of the target (e.g. Tailscale IP or LAN address).",
                    nullable: false,
                    placeholder: "100.64.0.5",
                    default: "",
                },
                port: {
                    type: "number",
                    name: "Port",
                    description:
                        "Port number of the metrics exporter on the target (e.g. 9100 for node_exporter).",
                    nullable: false,
                    integral: true,
                    range: "[1, 65535]",
                    default: 9100,
                },
                "metrics-path": {
                    type: "string",
                    name: "Metrics Path",
                    description: "HTTP path where the exporter serves metrics.",
                    nullable: false,
                    placeholder: "/metrics",
                    default: "/metrics",
                },
            },
            "unique-by": "job-name",
            "display-as": "{{job-name}} ({{host}}:{{port}})",
        },
    },
});
