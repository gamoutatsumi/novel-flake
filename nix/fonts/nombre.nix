{ pkgs }:
let
  version = "2.0";
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "genei-nombre";
  version = "2.0";
  src = pkgs.fetchurl {
    url = "https://okoneya.jp/font/GenEiNombre_v${version}.zip";
    hash = "sha256-7JAPJMSaZFrahANpevg/T8F3tswIW8w9NTOpQ8GPjQQ=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm644 GenEiNombre_v${version}/*.ttf -t $tex/fonts/truetype/public/genei-nombre
    runHook postInstall
  '';
  unpackPhase = "unzip $src GenEiNombre_v${version}/GenEiNombre-Venice.ttf GenEiNombre_v${version}/GenEiNombre-Roman.ttf -d .";
  nativeBuildInputs = [ pkgs.unzip ];
  outputs = [
    "tex"
    "out"
  ];
}
