// gunk-web's project layer: what this one project declares above the floor.
// The floor is the policy/instance of the owning valley that policy/valley
// names. This layer binds gunk-web alone, and a project can only add to its
// own layer. The floor's prose class covers every Markdown file, so a change
// to Markdown alone requires the floor's check and none of these.
package verification

project: {
	// Each check is the flake check of the same name in flake.nix, built for
	// the runner's own system. Each takes seconds and boots no machine, so
	// each keeps the schema's default cost, quick.
	checks: build: {
		runner:    "nix"
		attribute: "build"
	}
	checks: fmt: {
		runner:    "nix"
		attribute: "fmt"
	}

	// build copies the pages and the Caddyfile into the site and checks for
	// both.
	classes: site: {
		paths: "www/**":    true
		paths: "Caddyfile": true
		requires: build:    true
	}

	// flake.nix defines the site and both checks, any Nix file is one it may
	// import, and flake.lock pins the nixpkgs they build with.
	classes: flake: {
		paths: "**/*.nix":   true
		paths: "flake.lock": true
		requires: build:     true
		requires: fmt:       true
	}

	// The policy decides what every change requires, so a change to it
	// carries every check, and its approval carries across no landing.
	classes: policy: {
		paths: "policy/**": true
		requires: build:    true
		requires: fmt:      true
		carry: exact:       true
	}

	// A path no class covers means this layer is behind the tree.
	unclassified: build: true
	unclassified: fmt:   true
}
