{
  stdenv,
  autoPatchelfHook,
  libsForQt5,
  pkgs
}:

stdenv.mkDerivation rec {
  pname = "openhantek";
  version = "devdrop";

  src = builtins.fetchTarball {
    url = "https://github.com/oscilococcinum/openhantek6022-nix/releases/download/devdrop/openhantek_devdrop_x86_64.tar.gz";
    sha256 = "sha256:0dpv50ky4lpva8p1q05mffk2ak2yk97i3g01kp8miq71rlpny5w6";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    libsForQt5.qt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    fftw
    libgcc
    libusb1
    libsForQt5.qt5.qtwayland
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/
  '';
}
