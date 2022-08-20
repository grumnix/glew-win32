{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    # glew_src.url = "github:nigels-com/glew";
    # glew_src.flake = false;

    glew_src.url = "https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0-win32.zip";
    glew_src.flake = false;
  };

  outputs = { self, nixpkgs, tinycmmc, glew_src }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = glew;

          glew = pkgs.stdenv.mkDerivation rec {
            pname = "glew";
            version = "2.2.0";

            src = glew_src;

            configurePhase = "# do nothing";
            buildPhase = "# do nothing";
            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/lib
              cp -vr include include $out
            '' + (if pkgs.system == "i686-windows"
                  then ''
                    cp -vr bin/Release/Win32/* $out/bin
                    cp -vr lib/Release/Win32/* $out/lib
                  ''
                  else ''
                    cp -vr bin/Release/x64/* $out/bin
                    cp -vr lib/Release/x64/* $out/lib
                  '');
          };
        };
      }
    );
}

