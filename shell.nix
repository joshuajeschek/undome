{ pkgs ? import <nixpkgs> {} }:

let
  mkScript = name: text: let
    script = pkgs.writeShellScriptBin name text;
  in script;

  scripts = [
    (mkScript "west" ''
      ./exec.sh west "$@"
    '')
  ];
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    devcontainer
  ] ++ scripts;
}
