## graphify

This project has a knowledge graph at `graphify-out/` (nodes, community structure, cross-file and cross-document relationships). It is a snapshot: the post-commit git hook keeps the code/AST layer current automatically and for free, but the semantic layer (docs, resume, design images) only refreshes when you run `graphify update .`.

Use it where it beats grep; skip it where grep wins:
- Reach for the graph on semantic, cross-document, "why", or whole-repo-orientation questions — how the projects, resume versions, SEO work, and design decisions relate. Use `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"`; each returns a scoped subgraph, cheaper than reading GRAPH_REPORT.md or running a wide grep.
- Prefer plain grep/read for precise or current-state code lookups: where a symbol is defined, what imports it, the actual implementation, or anything edited since the last graph build. Do not route these through the graph.
- Graph answers can be stale — verify against source before acting on them.
- After changing docs/resume/design images, run `graphify update .` (code changes are already handled by the git hook).
