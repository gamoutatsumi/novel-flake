{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "genei-koburi-min";
  version = "6.1";
  src = pkgs.fetchzip {
    url = "https://okoneya.jp/font/GenEiKoburiMin_v6.1.zip";
    hash = "sha256-tbUSxev+1BmQnM4rHsnUByJgK7xIXmT164rjBA/2hBI=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm644 *.ttf -t $tex/fonts/truetype/public/genei-koburi-min
    runHook postInstall
  '';
  outputs = [
    "tex"
    "out"
  ];
}
