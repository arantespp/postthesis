# Instructions for agents

## Reporting naturali issues to Flow

Postthesis runs on naturali, so working here surfaces naturali bugs and missing
features. Record each one in the Flow project **naturali**
(`proj_vx1h3xshaq`) with `upsert-tasks`. Do not just mention it in chat.

- **Bug in naturali** (the API, app, docs, MCP server or formation behaves
  wrongly): create a `commitment` with status `active` and nothing blocking it,
  so it is ready to be worked on.
- **Feature request for naturali** (something naturali does not do yet that
  Postthesis needs): create a `decision` with status `active`. The person decides
  whether to build it. Do not create a commitment for it.

For both:

- Title: one line that names the behaviour. Body: what you did, what you
  expected, what happened (request, response, error), and why Postthesis needs
  it.
- Tag the area (`api`, `formations`, `mcp`, `documents`, `memories`, `billing`, …)
  and add `postthesis` so the source is clear.
- Add a `source` reference to whatever exposed it (file, PR, error, run), and
  use `dedupe_on` with that URL when there is one, so the same issue is not
  filed twice.
- Then tell the person what you filed, with the task URL.
