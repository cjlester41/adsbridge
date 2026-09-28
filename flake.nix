{
  description = "WebSocket bridge for readsb SBS stream";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        adsbridge = pkgs.buildNpmPackage {
          pname = "adsbridge";
          version = "1.0.0";

          src = ./.;

          npmDepsHash = pkgs.lib.fakeSha256; # replace after first build

          meta = {
            description = "WebSocket bridge for readsb SBS stream";
            license = pkgs.lib.licenses.isc;
          };
        };
      in
      {
        packages = {
          default = adsbridge;
          adsbridge = adsbridge;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ nodejs ];
        };
      }
    );
}