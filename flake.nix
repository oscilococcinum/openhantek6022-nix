{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
        openhantec6022-build = stdenv.mkDerivation rec {
          pname = "openhantek6022";
          version = "devdrop";

          src = builtins.fetchGit {
            url = https://github.com/oscilococcinum/OpenHantek6022.git;
            ref = "adds-flake";
            submodules = true;
          };

          buildInputs = [
            pkgs.simgrid
            pkgs.boost
            pkgs.cmake
            pkgs.qt5.full
            pkgs.fftw
            pkgs.libusb1
            pkgs.fakeroot
          ];

          configurePhase = ''
            cmake .
          '';

          buildPhase = ''
            make -j6
            rm -f packages
            fakeroot make -j6 package
            cd ..
          '';

          installPhase = ''
            mkdir -p $out/bin
            mv openhantek $out/bin
          '';
        };

        default = openhantec6022-build;
      };
    })[ "x86_64-linux" "aarch64-linux" ]);

    devShells = builtins.listToAttrs (map (system: {
      name = system;
      value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
        openhantec6022-devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gnumake
            cmake
          ];
          shellHook = '''';
        };
        default = openhantec6022-devShell;
      };
    })[ "x86_64-linux" "aarch64-linux" ]);
  };
}
