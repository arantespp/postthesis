# Postthesis

From your thesis to today's post. Postthesis keeps who you are (themes), how you
publish (cadence) and what you published (posts, analytics), and an assistant
such as Claude reads it all over MCP to recommend and draft today's post.

It runs on [naturali](https://naturali.ai): playbooks hold the person's state,
documents hold their posts and the growth guide, and an MCP server exposes both.
X is the first network; each new network is one more playbook reading the same
`profile`.

## How it fits together

```text
profile (playbook)        themes ──► themes_confirmed
                                           │ upstream
x-growth (playbook)       profile_themes ──► themes
                          stage ──► cadence ──► cadence_confirmed

documents                 /x/<actor>/posts/       what the person published
                          /x/<actor>/articles/
                          /x/<actor>/analytics/   X's own CSV exports
                          /playbooks/x-growth/    the growth guide (not in this repo)

MCP server "x-growth"     tools over the above, confined to the caller's actor
```

- **One case per person per playbook.** Each person is an actor; their cases
  carry its `actor_id`, and the tools pin it from the MCP caller's context
  (`x_actor`), so a person reaches only their own cases and posts.
- **The person approves, the system recommends.** Themes and cadence each end in
  a `confirm` node; the assistant writes the recommendation, the person approves
  it.
- **The guide is the product.** The cadence rules per account stage, validated
  against analytics, live in the project's documents, not here.
  [`guide/example-cadence.md`](guide/example-cadence.md) shows their shape.
- **The assistant is the agent.** No agent runs on naturali: the MCP server's
  `instructions` teach the connected assistant the daily-post procedure.

## Deploy

1. Copy `formation/parameters.example.json` to `parameters.json` and fill it.
2. Deploy the template into a naturali project:

   ```bash
   jq -n --rawfile t formation/template.yaml --slurpfile p parameters.json \
     '{name: "postthesis", template: $t, parameters: $p[0]}' |
   curl -sS -X POST "https://api.naturali.ai/v1/projects/$PROJECT/formations" \
     -H "Authorization: Bearer $NATURALI_TOKEN" \
     -H "Content-Type: application/json" -d @-
   ```

   Run the same body against `…/formations/plan` first to see what it creates.
   The outputs hold `McpServerUrl` and `OwnerActorId`.
3. Upload the guide to `/playbooks/x-growth/` as a document.
4. Open the person's cases:

   ```bash
   ACTOR=actor_... PROFILE=pbk_... X_GROWTH=pbk_... ./scripts/open-cases.sh "ada"
   ```

5. Add `McpServerUrl` to the assistant as a custom connector and sign in with
   the naturali account of `OwnerEmail`.

## Open items

- `save_post` (`x-documents`) is not confined to the caller's paths: any
  connected person can write any document. Confine it before a second person
  connects.
- One owner per deploy. Serving several people means one allowlist entry, actor
  and pair of cases each.
- The cadence guide is a set of hypotheses; revise it once weeks of analytics
  confirm or refute each rule.
- Memories about the person (projects, role, voice) are not stored yet.
