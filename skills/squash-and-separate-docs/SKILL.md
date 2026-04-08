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

The squash commit is ready on `<feature-branch>`. Present the options:

> "Squash commit ready on `<feature-branch>`. How would you like to land it?
>
> **A) Direct** — merge into `<base-branch>` locally and push
> **B) PR** — push `<feature-branch>` to remote (optionally under a different name) and open a PR
>
> For option B you can control the remote branch name:
> `git push origin <feature-branch>:<remote-name>`  e.g. `feat/unescape-xtrace`"

Wait for user choice before continuing.

### Step 8: Execute chosen path

**Option A — Direct:**
```bash
# If remote exists: rebase first
git fetch origin && git rebase origin/<base-branch>  # skip if no remote

git checkout <base-branch>
git pull 2>/dev/null || true
git merge <feature-branch>
git push origin <base-branch>
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
| Running `git fetch origin` when no remote | Check `git remote` first; skip fetch+rebase entirely if empty |
| cp AFTER squash/unstage | cp in Step 3, before touching the index |
| Forgetting to unstage and rm docs/superpowers | Step 5 — without this it ends up in the squash commit |
| Running cleanup from inside worktree | Step 10 must run from main repo (`cd $MAIN_REPO` first) |
| Committing docs worktree before feature lands | Step 9 needs the landing commit SHA — do it after landing |

## Quick Reference

```
remote?   → if yes: fetch+rebase before landing; if no: skip
worktree? → /tmp/worktrees/docs-superpowers (never under repo root)
order:    cp → squash → unstage+rm → commit → STOP (ask user) → land → worktree-commit → cleanup
PR name:  git push origin local-branch:feat/my-feature-name
```
