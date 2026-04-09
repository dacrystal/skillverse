.PHONY: bump-version

bump-version:
	$(eval VERSION := $(shell git cliff --bumped-version --unreleased 2>/dev/null | sed 's/^v//'))
	@if [ -z "$(VERSION)" ]; then echo "Error: could not determine bumped version"; exit 1; fi
	@echo "Bumping to version $(VERSION)"
	@tmp=$$(mktemp) && \
		jq --arg v "$(VERSION)" '.version = $$v' .claude-plugin/plugin.json > "$$tmp" && \
		mv "$$tmp" .claude-plugin/plugin.json
	git add .claude-plugin/plugin.json
	git commit -m "chore: bump version to v$(VERSION)"
	git tag "v$(VERSION)"
	@echo "Tagged v$(VERSION)"
