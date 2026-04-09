---
name: standard-readme
description: Use when creating or auditing a README to comply with the standard-readme specification - sections in required order, required content in each section, no broken links, and correct formatting.
---

# Standard Readme

## Overview

[Standard Readme](https://github.com/RichardLitt/standard-readme) is a specification for open source library READMEs. Sections must appear in a fixed order; required sections cannot be omitted.

## Section Order & Status

| # | Section | Status |
|---|---------|--------|
| 1 | Title | **Required** |
| 2 | Banner | Optional |
| 3 | Badges | Optional |
| 4 | Short Description | **Required** |
| 5 | Long Description | Optional |
| 6 | Table of Contents | Required if README ≥ 100 lines |
| 7 | Security | Optional (can move to Extra Sections) |
| 8 | Background | Optional |
| 9 | Install | **Required** (optional for doc-only repos) |
| 10 | Usage | **Required** (optional for doc-only repos) |
| 11 | Extra Sections | Optional (0 or more, your own titles) |
| 12 | API | Optional |
| 13 | Maintainers | Optional |
| 14 | Thanks / Credits / Acknowledgements | Optional |
| 15 | Contributing | **Required** |
| 16 | License | **Required** (must be last) |

## Section Requirements

### Title
- Must match the repo/folder/package name, or include it in italics: `# Full Name _(package-name)_`
- If names differ, explain in Long Description

### Banner
- No heading — appears directly after title
- Must link to a local image in the repo

### Badges
- No heading
- One badge per line

### Short Description
- No heading
- < 120 characters, no leading `> `
- Must match the package manager `description` field and GitHub description

### Long Description
- No heading
- Explain why the repo exists; keep concise — move detail to Background

### Table of Contents
- Start from the first section after the title — do not include Title or ToC itself
- Must link every `##` heading; `###` links are optional

### Install
- Code block showing how to install
- Add `### Dependencies` subsection if there are unusual or manual-install dependencies

### Usage
- Code block for common usage
- Add `### CLI` subsection if CLI exists
- Show both import and usage if the module is importable

### API
- Document exported functions and objects; include signatures and return types

### Maintainers
- Section must be titled `Maintainer` or `Maintainers`
- List names + one contact method each

### Thanks
- Must be titled `Thanks`, `Credits`, or `Acknowledgements`

### Contributing
- State where users can ask questions
- State whether PRs are accepted
- List any commit/sign-off requirements

### License
- State full SPDX license name or identifier (e.g. `MIT`, `Apache-2.0`, `UNLICENSED`)
- Include license owner
- Must be the last section; link to the LICENSE file

## File Requirements

- Filename: `README.md` (or `README.<lang>.md` for i18n; English gets plain `README.md`)
- Must be valid Markdown
- No broken links
- Code examples must be linted consistently with the project

## Quick Checklist

```
[ ] Title matches repo/package name (or explains mismatch)
[ ] Short description: no heading, < 120 chars, matches GitHub/npm description
[ ] Table of Contents present (if README ≥ 100 lines)
[ ] Install section has a code block
[ ] Usage section has a code block
[ ] Contributing states: where to ask questions, PR policy, any commit requirements
[ ] License is last, includes SPDX identifier and owner
[ ] Sections are in the correct order (see table above)
[ ] No broken links
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Short description has its own heading | Remove the heading — it's titleless |
| Banner/Badges have their own heading | Remove headings for both |
| Table of Contents includes Title row | Start ToC from the first real section |
| License is not last | Move License to the end |
| Contributing omits PR policy | Add explicit statement accepting or rejecting PRs |
| Section order wrong | Follow the table above exactly |
| Short description > 120 chars | Trim; move detail to Long Description |
