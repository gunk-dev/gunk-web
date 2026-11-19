# gunk-web

## Checks

Changes are proposed to the valley. `valley checks` names the checks a change requires, the valley
builds them, and a person approves the change. Each check is a flake check, built without network
access. On x86_64-linux:

```sh
nix build .#checks.x86_64-linux.build         # the site builds and outputs www/index.html and Caddyfile
nix build .#checks.x86_64-linux.fmt           # every Nix file is formatted with nixfmt
nix build .#checks.x86_64-linux.prose-format  # every Markdown file is formatted with prettier
```

`nix develop -c nixfmt flake.nix` formats the flake.
