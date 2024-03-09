{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, python3Packages ? pkgs.python3Packages
, fetchPypi ? pkgs.fetchPypi
, nixosTests ? pkgs.nixosTests
}:

python3Packages.buildPythonPackage rec {
  pname = "overleaf-sync-ce";
  version = "2.0.0";
  format = "pyproject";

  # src = fetchPypi {
  #   inherit version;
  #   pname = "overleaf_sync_ce";
  #   sha256 = "cMK//eReF6Wr1b2MMXVwGiy8knVOLSZQdPPwJqfeK4o=";
  # };

  src = ./.;


  nativeBuildInputs = with python3Packages; [
    build
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    requests
    pyside6
    beautifulsoup4
    yaspin
    python-dateutil
    socketio-client
    flit
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