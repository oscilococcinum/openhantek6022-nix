{
  stdenv,
  autoPatchelfHook,
  libsForQt5,
  pkgs,
  src
}:

stdenv.mkDerivation rec {
  pname = "openhantek";
  version = "devdrop";

  inherit src;

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
    cp $out/bin/OpenHantek $out/bin/openhantek
    rm $out/bin/OpenHantek
  '';
}
