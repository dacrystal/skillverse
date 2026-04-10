# skillverse

Personal Claude Code skills collection.

## Install

Register this repo as a personal marketplace, then install the plugin:

```
plugin marketplace add skillverse https://github.com/dacrystal/skillverse
plugin install skillverse@skillverse
```

## Usage

After installation, skills are available in Claude Code. Invoke them via slash commands:

```
/skillverse:standard-readme
/skillverse:git-squash-separate-superpowers-docs
```

## Skills

- **git-squash-separate-superpowers-docs** — Squash feature commits and sync `docs/superpowers/` changes to a dedicated branch. Use when finishing a branch that includes docs/superpowers changes.
- **standard-readme** — Create or audit a README to comply with the [standard-readme](https://github.com/richardlitt/standard-readme) specification.

## Adding Skills

Add a directory under `skills/` with a `SKILL.md` file:

```
skills/
└── your-skill-name/
    └── SKILL.md
```

## License

MIT © Nasser Alansari

See [LICENSE](LICENSE).
