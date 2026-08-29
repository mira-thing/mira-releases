# Splice a firmware release into manifest.json.
#
#   jq --arg version 1.2.0 \
#      --arg tag v1.2.0 \
#      --arg channel stable \
#      --arg url https://mira-firmware.mira-thing.workers.dev/v1.2.0/mira_firmware_v1.2.0.zip \
#      --arg size 391773066 \
#      --arg sha256 <hex> \
#      --arg released_at 2026-08-29T00:00:00Z \
#      -f .github/scripts/manifest-entry.jq manifest.json
#
# Emits the whole manifest, inserting the release newest-first to match how the
# file is hand-maintained, so the diff stays small. summary and changelog are
# editorial placeholders.

def entry:
  {
    version: $version,
    channel: $channel,
    released_at: $released_at,
    summary: "TODO: one-line summary shown in the updater",
    changelog: "TODO: markdown bullet list of user-visible changes",
    changelog_url: "https://github.com/mira-thing/mira-releases/releases/tag/\($tag)",
    yanked: null,
    deprecated: false,
    download: {
      url: $url,
      size: ($size | tonumber),
      sha256: $sha256
    }
  };

.updated_at = $released_at
| .releases = ({ ($version): entry } + (.releases | del(.[$version])))
# Only promote into a channel the manifest already defines. A beta build passes
# channel=beta, which does not exist yet; creating it here would emit a channel
# with no name, description or stability, and .releases would be null to subtract.
| if .channels[$channel] then
    .channels[$channel].latest = $version
    | .channels[$channel].releases =
        ([$version] + (.channels[$channel].releases - [$version]))
  else . end
