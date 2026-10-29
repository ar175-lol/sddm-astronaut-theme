{
  description = "Qt 6 SDDM astronaut theme";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      theme = pkgs.callPackage ./nix/package.nix {};
    in {
      default = theme;
      sddm-astronaut-theme = theme;
    });

    checks = forAllSystems (system:
      import ./nix/checks.nix {
        pkgs = nixpkgs.legacyPackages.${system};
        theme = self.packages.${system}.default;
      });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      qt = pkgs.kdePackages;
    in {
      default = pkgs.mkShell {
        packages = [
          (qt.sddm.override {
            extraPackages = with qt; [
              qtmultimedia
              qtvirtualkeyboard
            ];
          })
        ];
      };
    });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
