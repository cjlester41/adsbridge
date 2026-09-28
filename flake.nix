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

          postInstall = ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.nodejs}/bin/node $out/bin/adsbridge \
              --add-flags "$out/lib/node_modules/readsb/bridge.js" \
              --prefix NODE_PATH : "$out/lib/node_modules/readsb/node_modules"
          '';

          nativeBuildInputs = [ pkgs.makeWrapper ];

          meta = {
            description = "WebSocket bridge for readsb SBS stream";
            license = pkgs.lib.licenses.isc;
            mainProgram = "adsbridge";
          };
        };
      in
      {
        packages = {
          default = adsbridge;
          adsbridge = adsbridge;
        };
      }
    );
}