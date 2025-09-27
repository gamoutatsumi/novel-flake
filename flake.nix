{
  inputs = {
    # keep-sorted start block=yes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs = {
        nixpkgs-lib = {
          follows = "nixpkgs";
        };
      };
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    # keep-sorted end
  };

  outputs =
    {
      self,
      flake-parts,
      systems,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        inputs,
        lib,
        withSystem,
        ...
      }:
      {
        systems = import systems;
        imports = [
          inputs.pre-commit-hooks.flakeModule
          inputs.treefmt-nix.flakeModule
        ];

        perSystem =
          {
            system,
            pkgs,
            config,
            lib,
            ...
          }:
          let
            treefmtBuild = config.treefmt.build;
            nodejs = pkgs.nodejs_24;
            inherit (pkgs) importNpmLock;
            npmDeps = importNpmLock.buildNodeModules {
              inherit nodejs;
              npmRoot = ./node-pkgs;
            };
            texlive = pkgs.texliveBasic.withPackages (
              ps: with ps; [
                # keep-sorted start
                filehook
                fontspec
                haranoaji
                hyperref
                hyperxmp
                ifmtarg
                jlreq
                luacode
                luatexja
                newunicodechar
                pxrubrica
                xkeyval
                # keep-sorted end
                (pkgs.callPackage ./nix/fonts/koburimin.nix { })
                (pkgs.callPackage ./nix/fonts/nombre.nix { })
              ]
            );
          in
          {
            apps = {
              build = {
                type = "app";
                program = pkgs.writeShellApplication {
                  name = "build";
                  runtimeInputs = [ texlive ];
                  text = ''
                    luaotfload-tool --update
                    lualatex text.tex
                  '';
                };
              };
            };
            devShells = {
              default = pkgs.mkShell {
                inherit npmDeps;
                PFPATH = "${
                  pkgs.buildEnv {
                    name = "zsh-comp";
                    paths = config.devShells.default.nativeBuildInputs;
                    pathsToLink = [ "/share/zsh" ];
                  }
                }/share/zsh/site-functions";
                inputsFrom = [
                  treefmtBuild.devShell
                ];
                shellHook = ''
                  ${config.pre-commit.installationScript}
                  source ${importNpmLock.hooks.linkNodeModulesHook}/nix-support/setup-hook
                  linkNodeModulesHook
                '';
                packages =
                  (with pkgs; [
                    # keep-sorted start
                    efm-langserver
                    nil
                    nixfmt
                    texlab
                    # keep-sorted end
                  ])
                  ++ [
                    texlive
                    nodejs
                  ];
              };
            };
            pre-commit = {
              check = {
                enable = true;
              };
              settings = {
                src = ./.;
                hooks = {
                  textlint = {
                    enable = true;
                    entry = "${npmDeps}/node_modules/.bin/textlint";
                    files = "\\.(md|tex)$";
                    excludes = [ "preamble\\.tex" ];
                  };
                  biome = {
                    enable = true;
                    types_or = [
                      # keep-sorted start
                      "javascript"
                      "json"
                      "markdown"
                      "ts"
                      # keep-sorted end
                    ];
                  };
                  treefmt = {
                    enable = true;
                    packageOverrides = {
                      treefmt = treefmtBuild.wrapper;
                    };
                  };
                };
              };
            };
            formatter = treefmtBuild.wrapper;
            treefmt = {
              projectRootFile = "flake.nix";
              flakeCheck = false;
              programs = {
                # keep-sorted start block=yes
                biome = {
                  enable = true;
                };
                keep-sorted = {
                  enable = true;
                };
                nixfmt = {
                  enable = true;
                };
                # keep-sorted end
              };
            };
          };
      }
    );
}
