---
name: squash-and-separate-docs
description: Use when finishing a development branch that has docs/superpowers/ changes and you need to squash commits while keeping docs/superpowers in its own branch/worktree. Use as Option 5 from finishing-a-development-branch when docs/superpowers/ changes are present.
---

# Squash and Separate docs/superpowers

## Overview

Squash all feature commits into one clean commit, sync `docs/superpowers/` changes to their dedicated branch/worktree, then hand off to the user to decide how to land (direct push, PR, etc.). This keeps skill/spec/plan docs out of feature commit history.

## When to Use

- Finishing a development branch via Option 5 (Squash and Merge) from `finishing-a-development-branch`
- The branch includes changes under `docs/superpowers/`

## Workflow

### Step 1: Detect environment

```bash
# Check for remote
git remote | head -1          # empty = no remote; skip fetch/rebase later
git remote get-url origin 2>/dev/null || echo "NO_REMOTE"

# Find writable worktree path (prefer /tmp, NOT under repo root — permission denied there)
DOCS_WORKTREE=/tmp/worktrees/docs-superpowers
mkdir -p $(dirname $DOCS_WORKTREE)
```

### Step 2: Ensure docs/superpowers worktree

```bash
# Check if already exists
git worktree list | grep "docs/superpowers" | awk '{print $1}'

# Create if missing
git worktree add --orphan -b docs/superpowers $DOCS_WORKTREE \
  || git worktree add $DOCS_WORKTREE docs/superpowers
```

### Step 3: Copy docs/superpowers to worktree

```bash
cp -r docs/superpowers/. $DOCS_WORKTREE/docs/superpowers/
```

### Step 4: Squash commits

```bash
MERGE_BASE=$(git merge-base HEAD <base-branch>)
git reset --soft $MERGE_BASE
```

### Step 5: Unstage and remove docs/superpowers

```bash
git restore --staged docs/superpowers/
rm -rf docs/superpowers/
```

### Step 6: Commit squashed code (without docs/superpowers)

```bash
git commit -m "<squashed commit message>"
```

### Step 7: STOP — ask user how to land

The squash commit is ready on `<feature-branch>`. Before presenting options, check the current branch name:

- If it is a **single word with no `/`** (e.g. `dev`, `fix`, `feature`), auto-suggest a remote branch name:
  1. Parse the squash commit message for a conventional prefix (`feat`, `fix`, `refactor`, `chore`, `docs`, etc.)
  2. Slugify the description: lowercase, spaces → hyphens, strip punctuation
  3. Compose `<prefix>/<slug>` — e.g. `feat/unescape-xtrace`
  4. Default to `feat/` if no conventional prefix found

Present options:

> "Squash commit ready on `<feature-branch>`. Suggested remote branch name: `<suggested-name>`.
>
> **A) Direct** — merge into `<base-branch>` locally (no push)
> **B) PR** — push to remote as `<suggested-name>` (or specify your own) and open a PR"

Wait for user choice before continuing.

### Step 8: Execute chosen path

**Option A — Direct:**
```bash
git rebase <base-branch>               # replay squash commit onto local base (while on feature branch)
git checkout <base-branch>
git merge --ff-only <feature-branch>   # guaranteed ff after rebase
# no push — user handles remote separately
```

**Option B — PR:**
```bash
# Push feature branch (optionally rename for remote)
git push origin <feature-branch>:<remote-branch-name>
gh pr create --base <base-branch> --head <remote-branch-name> --title "..." --body "..."
```

### Step 9: Commit docs/superpowers in worktree

Run this after the feature lands on the base branch (Option A) or after PR merges (Option B):

```bash
MAIN_HEAD=$(git rev-parse HEAD)   # use the landing commit SHA
MAIN_REPO=$(git rev-parse --show-toplevel)
cd $DOCS_WORKTREE
git add docs/superpowers/
git commit -m "docs: sync superpowers from <feature-branch> (ref: $MAIN_HEAD)"
```

### Step 10: Clean up

```bash
# Return to main repo first — git branch -d and git worktree remove must run there
cd $MAIN_REPO
git branch -d <feature-branch>
git worktree remove $DOCS_WORKTREE
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Worktree path under repo root | Use `/tmp/worktrees/` — repo root area has permission denied |
| Rebasing feature against `origin/<base-branch>` in Option A | Use local `<base-branch>` — preserves local-only commits instead of silently dropping them |
| Pushing in Option A | Don't — leave remote to the user |
| cp AFTER squash/unstage | cp in Step 3, before touching the index |
| Forgetting to unstage and rm docs/superpowers | Step 5 — without this it ends up in the squash commit |
| Running cleanup from inside worktree | Step 10 must run from main repo (`cd $MAIN_REPO` first) |
| Committing docs worktree before feature lands | Step 9 needs the landing commit SHA — do it after landing |

## Quick Reference

```
Option A:  rebase onto local base → ff-only merge → no push (user handles remote)
Option B:  rebase onto origin base → push → PR (suggest feat/<slug> if branch has no /)
worktree:  /tmp/worktrees/docs-superpowers (never under repo root)
order:     cp → squash → unstage+rm → commit → STOP (ask user) → land → worktree-commit → cleanup
```
