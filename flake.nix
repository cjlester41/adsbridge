{
  description = "WebSocket bridge for readsb SBS stream";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        adsbridge = pkgs.buildNpmPackage {
          pname = "adsbridge";
          version = "1.0.0";

          src = ./.;

          npmDepsHash = "sha256-L/h9zJeJnXOaiyLZxpoTFJwcY0xqCWktl4q7z5FP044";
          dontNpmBuild = true;

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