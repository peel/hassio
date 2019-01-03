{ pkgs ? import <nixpkgs> {} }:

# with stdenv.lib;

pkgs.stdenv.mkDerivation rec {
  src = ./.;
  version = "0.0.1";
  baseName = "hassio-config";
  name = "${baseName}-${version}";

  buildInputs = with pkgs; [ emacs home-assistant ];
  installPhase = ''
    emacs -Q README.org --batch --eval '(org-babel-tangle-file "README.org")' --kill
    mkdir -p $out/var/lib/hass
    mv *.yaml $out/var/lib/hass/
  '';
  checkPhase = ''
    hass -c . --script check_config --info all
  '';
  pathsToLink = [ "/var/lib/hass" ];
  
  meta = with pkgs.stdenv.lib; {
    description = "Neat Home Assinstant configuration";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
