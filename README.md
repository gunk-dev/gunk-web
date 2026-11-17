# gunk-web

## Checks

Each check CI runs is a flake check, built without network access. On x86_64-linux:

```sh
nix build .#checks.x86_64-linux.build  # the site builds and outputs www/index.html and Caddyfile
nix build .#checks.x86_64-linux.fmt    # every Nix file is formatted with nixfmt
```

`nix develop -c nixfmt flake.nix` formats the flake.
