import { types as T, healthUtil } from "../deps.ts";

export const health: T.ExpectedExports.health = {
    async "web-ui"(effects, duration) {
        return healthUtil
            .checkWebUrl("http://prometheus.embassy:9090/-/healthy")(effects, duration)
            .catch(healthUtil.catchError(effects));
    },
};
