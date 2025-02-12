{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devdrop = {
      url = "https://github.com/oscilococcinum/openhantek6022-nix/releases/download/devdrop/openhantek_devdrop_x86_64.tar.gz";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {

        openhantek6022 = pkgs.callPackage (import ./nix) { repo = inputs.devdrop; };

        default = openhantek6022;
      };
    })[ "x86_64-linux" ]);
  };
}
