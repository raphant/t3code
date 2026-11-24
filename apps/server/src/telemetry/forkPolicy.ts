/**
 * raphant fork: T3's usage data is always off in this build.
 * When true, the server never sends analytics, whatever the env or policy says,
 * and never opens ~/.codex/auth.json or ~/.claude.json to build owner IDs.
 * Used by AnalyticsService.ts and Identify.ts. Keep this file when merging T3's code.
 */
export const FORK_TELEMETRY_OFF = true;
