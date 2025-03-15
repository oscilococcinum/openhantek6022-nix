{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    devdrop = {
      url = "https://github.com/OpenHantek/OpenHantek6022/releases/download/devdrop/openhantek_3.4.0-1-g982f746-devdrop_x86_64.tar.gz";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
        openhantek6022 = pkgs.callPackage (import ./package/default.nix) { src = inputs.devdrop; };
        default = openhantek6022;
      };
    })[ "x86_64-linux" ]);
  };
}
