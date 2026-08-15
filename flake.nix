{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    openhantek-stable = {
      url = "https://github.com/OpenHantek/OpenHantek6022/releases/download/3.4.0/openhantek_3.4.0_x86_64.tar.gz";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      packages = builtins.listToAttrs (
        map (system: {
          name = system;
          value =
            with import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }; rec {
              openhantek6022 = pkgs.callPackage (import ./pkg/default.nix) {
                src = inputs.openhantek-stable;
                pname = "openhantek";
                version = "stable";
              };
              default = openhantek6022;
            };
        }) [ "x86_64-linux" ]
      );
    };
}
