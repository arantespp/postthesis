#!/usr/bin/env bash
# Opens a person's `profile` case and the `x-growth` case bound to it.
# Usage: NATURALI_TOKEN=... PROJECT=... ACTOR=... PROFILE=pbk_... X_GROWTH=pbk_... ./scripts/open-cases.sh "<subject>"
set -euo pipefail
: "${NATURALI_TOKEN:?}" "${PROJECT:?}" "${ACTOR:?}" "${PROFILE:?}" "${X_GROWTH:?}"
SUBJECT="${1:?subject}"
API="https://api.naturali.ai/v1/projects/$PROJECT"

post() {
  curl -sS --fail-with-body -X POST "$API/$1" \
    -H "Authorization: Bearer $NATURALI_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$2"
}

profile_case=$(post "playbooks/$PROFILE/cases" \
  "$(jq -n --arg s "$SUBJECT" --arg a "$ACTOR" '{subject: $s, actor_id: $a}')" | jq -r .id)

x_case=$(post "playbooks/$X_GROWTH/cases" \
  "$(jq -n --arg s "$SUBJECT" --arg a "$ACTOR" --arg p "$profile_case" \
    '{subject: $s, actor_id: $a, upstreams: {profile: $p}}')" | jq -r .id)

echo "profile case:  $profile_case"
echo "x-growth case: $x_case"
