{ 
 pkgs ? import <nixos-unstable> { }
, lib ? pkgs.lib
, python3Packages ? pkgs.python3Packages
, fetchPypi ? pkgs.fetchPypi
, nixosTests ? pkgs.nixosTests
}:
let
  yaspin = python3Packages.yaspin.overrideAttrs (oldAttrs: {
    checkPhase = ''
      # Remove the tests, they are not in the pypi package
      rm -rf tests
    '';
  });

  socketio-client = python3Packages.socketio-client.overrideAttrs (oldAttrs: {
      version = "0.5.7.2";
      src = fetchPypi {
        version = "0.5.7.2";
        pname = "socketIO-client";
        sha256 = "sha256-i6BLzI2HVt1RGsQCFfsVWqEbYPAW/P/J5E+rNp4h5XU=";
      };
  });

in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "overleaf-sync-ce";
  version = "2.0.0";
  format = "pyproject";

  # src = fetchPypi {
  #   inherit version;
  #   pname = "overleaf_sync_ce";
  #   sha256 = "cMK//eReF6Wr1b2MMXVwGiy8knVOLSZQdPPwJqfeK4o=";
  # };

  src = ./.;


  nativeBuildInputs = [
    pkgs.python3Packages.build
  ];

  propagatedBuildInputs = [
    pkgs.python3Packages.click
    pkgs.python3Packages.requests
    pkgs.python3Packages.pyside6
    pkgs.python3Packages.beautifulsoup4
    yaspin
    pkgs.python3Packages.python-dateutil
    socketio-client
    pkgs.python3Packages.flit
  ];

  # tests are not in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jrodez/overleaf-sync-ce";
    license = licenses.mit;
    description = "A command-line tool to synchronize Overleaf projects with local files";
    maintainers = with maintainers; [ jrodez ];
  };
}
