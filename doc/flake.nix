{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    hse-sans-src = {
      url = "https://www.hse.ru/mirror/pubs/share/533611868";
      type = "tarball";
      flake = false;
    };

    hse-slab-src = {
      url = "https://www.hse.ru/mirror/pubs/share/533611928";
      type = "tarball";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    hse-sans-src,
    hse-slab-src,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;

        # for corefonts
        config.allowUnfree = true;
      };
      lib = pkgs.lib;

      inherit (pkgs) mkShell stdenvNoCC;
      inherit (lib) concatMapStringsSep;

      python = pkgs.python3.withPackages (pypkgs:
        with pypkgs; [
          click
        ]);

      mkHseFont = {
        pname,
        src,
      }:
        stdenvNoCC.mkDerivation {
          inherit pname src;
          version = "0.0.0";

          installPhase = ''
            runHook preInstall
            install -Dm644 -t "$out/share/fonts/opentype" *.otf
            runHook postInstall
          '';
        };

      hse-sans = mkHseFont {
        pname = "hse-sans";
        src = hse-sans-src;
      };

      hse-slab = mkHseFont {
        pname = "hse-slab";
        src = hse-slab-src;
      };

      fonts =
        [
          hse-sans
          hse-slab
        ]
        ++ (with pkgs; [
          corefonts
          dejavu_fonts
        ]);

      shell = mkShell {
        name = "upm-doc-shell";

        buildInputs =
          [python]
          ++ fonts
          ++ (with pkgs; [
            typst
          ]);

        TYPST_FONT_PATHS =
          concatMapStringsSep
          ":"
          (font_pkg: "${font_pkg}/share/fonts/")
          fonts;
      };
    in {
      devShell = shell;
    });
}
