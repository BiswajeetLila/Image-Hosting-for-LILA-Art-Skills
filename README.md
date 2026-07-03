# Image Hosting for LILA Art Skills

Public image host for the LILA AI **art skills** - `ai-art-set`, `ai-video-beats`,
`sprite`, and any future art skill that needs to feed a **seed / reference image**
to the image-generation MCP.

## Why this exists

The image-gen MCP (`edit_image` / `generate_image` / `generate_video`) fetches
input images **server-side from a public URL**. The Claude sandbox egress
allowlist blocks every third-party upload host (tmpfiles, file.io, 0x0, imgur,
their own domains), and inline base64 overflows on large images. GitHub raw URLs
are the one path that works: `git` is sanctioned in the sandbox and
`raw.githubusercontent.com` is publicly fetchable. So an agent can push an image
here and hand the raw URL straight to the MCP - no manual owner-hosting step.

## Usage

```bash
# one arg: a local image path. prints the raw URL to feed the gen MCP.
bash host.sh /path/to/seed.png            # -> https://raw.githubusercontent.com/.../seeds/misc/seed-<ts>.png
bash host.sh /path/to/seed.png ai-art-set # optional 2nd arg = skill subdir
```

The raw URL goes into the MCP call as `images=["<url>"]` (or `image_url`).
Delete after the gen completes if you want (see `host.sh --rm <path-in-repo>`).

## HARD rule: public / disposable only

This repo is **PUBLIC**. NEVER push proprietary or unreleased art here. Use it
only for disposable prototype seeds and reference frames that are safe to be
world-readable. Proprietary art stays owner-hosted on a private CDN. When in
doubt, ask the owner.

## Layout

`seeds/<skill>/<name>-<timestamp>.<ext>` - a transient buffer, not an archive.
Prune freely.
