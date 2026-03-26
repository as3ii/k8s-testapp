{
  description = "Kubernetes cluster";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-parts,
      git-hooks-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        git-hooks-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree;

          pre-commit = {
            check.enable = true;

            settings = {
              addGcRoot = true;

              hooks = {
                # Go
                gofmt.enable = true;
                # Misc
                check-added-large-files.enable = true;
                check-yaml.enable = true;
                detect-private-keys.enable = true;
                end-of-file-fixer.enable = true;
                ripsecrets.enable = true;
                trim-trailing-whitespace.enable = true;
                # Nix
                deadnix.enable = true;
                nil.enable = true;
                nixfmt.enable = true;
              };
            };
          };

          packages = rec {
            default = k8s-testapp;
            k8s-testapp = pkgs.callPackage ./default.nix { };
            k8s-testapp-static = pkgs.callPackage ./default.nix { static = true; };
            oci-image = pkgs.callPackage ./oci-image.nix {
              inherit k8s-testapp;

              created = builtins.substring 0 8 self.lastModifiedDate;
              revision = self.rev or self.dirtyRev or null;
            };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              config.pre-commit.settings.enabledPackages
              go
            ];

            shellHook = ''
              ${config.pre-commit.shellHook}
              echo 1>&2 "Welcome to the development shell!"
            '';
          };
        };

      flake = { };
    };
}
