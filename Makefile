.PHONY: build ci deps doc fmt fmt-check lint lock precommit test typedoc

FILES_TO_FORMAT = ./src ./test ./deps.ts ./mod.ts ./version.ts

build:
	@deno run --allow-net --allow-read --reload mod.ts

ci:
	@make fmt-check
	@make build
	@make test

deps:
	@npm install -g typescript typedoc@0.19.2

doc:
	@deno doc ./mod.ts

fmt:
	@deno fmt ${FILES_TO_FORMAT}

fmt-check:
	@deno fmt --check ${FILES_TO_FORMAT}

lint:
	@deno lint --unstable ${FILES_TO_FORMAT}

lock:
	@deno run --allow-net --allow-read --lock=lock.json --lock-write --reload mod.ts

precommit:
	@make lock
	@make typedoc
	@make fmt
	@make fmt

test:
	@deno test --allow-net --allow-read

typedoc:
	@rm -rf docs
	@typedoc --ignoreCompilerErrors --out ./docs --mode modules --includeDeclarations --excludeExternals --name opine-http-proxy ./src
	@make fmt
	@make fmt
	@echo 'future: true\nencoding: "UTF-8"\ninclude:\n  - "_*_.html"\n  - "_*_.*.html"' > ./docs/_config.yaml
