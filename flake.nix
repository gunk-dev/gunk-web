{
  description = "gunk.dev - static website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        # The fmt check and the dev shell share one formatter, so a file that
        # passes locally passes the check.
        nixfmt = pkgs.nixfmt;

        site = pkgs.stdenv.mkDerivation {
          pname = "gunk-web";
          version = "1.0.0";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp Caddyfile $out/
            cp -r www $out/
          '';
        };
      in
      {
        packages.default = site;

        checks = {
          # The site builds, and its output holds www/index.html and the Caddyfile.
          build = pkgs.runCommand "gunk-web-check-build" { } ''
            test -f ${site}/www/index.html
            test -f ${site}/Caddyfile
            touch $out
          '';

          # Every Nix file is formatted with nixfmt. Only .nix files are in the
          # source, so site edits do not rerun this check.
          fmt =
            pkgs.runCommand "gunk-web-check-fmt"
              {
                nativeBuildInputs = [ nixfmt ];
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.fileFilter (file: file.hasExt "nix") ./.;
                };
              }
              ''
                cd $src
                find . -name '*.nix' -exec nixfmt --check {} +
                touch $out
              '';
        };

        devShells.default = pkgs.mkShell {
          packages = [ nixfmt ];
        };
      }
    );
}
