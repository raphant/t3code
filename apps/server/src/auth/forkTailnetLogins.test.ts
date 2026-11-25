import { describe, expect, it } from "vite-plus/test";
import { isForkTailnetAddress } from "./forkTailnetLogins.ts";

describe("isForkTailnetAddress", () => {
  it("accepts only Tailscale's address ranges", () => {
    for (const address of [
      "100.64.0.1",
      "100.105.218.88",
      "100.127.255.255",
      "::ffff:100.87.100.106",
      "fd7a:115c:a1e0::1",
    ]) {
      expect(isForkTailnetAddress(address)).toBe(true);
    }
    for (const address of [
      undefined,
      "",
      "127.0.0.1",
      "192.168.1.130",
      "192.168.193.2",
      "100.63.255.255",
      "100.128.0.1",
      "10.0.0.1",
      "fd7a:115c:a1e1::1",
      "::1",
    ]) {
      expect(isForkTailnetAddress(address)).toBe(false);
    }
  });
});
