{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system:
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {

          openhantek6022 = pkgs.callPackage (import ./nix) { };
        };
      }
    )[ "x86_64-linux" ]);
  };
}
