// raphant fork: a pairing-link login from a Tailscale address lasts until revoked, not 30 days.
// Browsers cap the cookie (Chrome: 400 days), so a browser pairs again after that.
// Used by EnvironmentAuth.ts; SessionStore.renew never shrinks the longer expiry. Keep on merges.
import * as NodeNet from "node:net";
import { Duration } from "effect";

export const FORK_TAILNET_LOGIN_LIFETIME = Duration.days(36500);

const ipv4ToNumber = (address: string): number =>
  address.split(".").reduce((value, part) => value * 256 + Number(part), 0);

/** True for Tailscale's 100.64.0.0/10 IPv4 range and its fd7a:115c:a1e0::/48 IPv6 range. */
export const isForkTailnetAddress = (address: string | undefined): boolean => {
  if (!address) return false;
  const unmapped = address.toLowerCase().replace(/^::ffff:/, "");
  if (NodeNet.isIPv4(unmapped)) {
    const value = ipv4ToNumber(unmapped);
    return value >= ipv4ToNumber("100.64.0.0") && value <= ipv4ToNumber("100.127.255.255");
  }
  return NodeNet.isIPv6(unmapped) && unmapped.startsWith("fd7a:115c:a1e0:");
};

export const isForkTailnetClient = (client: { readonly ipAddress?: string } | undefined) =>
  isForkTailnetAddress(client?.ipAddress);
