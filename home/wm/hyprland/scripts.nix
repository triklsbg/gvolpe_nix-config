{ lib, writeShellScriptBin }:

let
  monitorsConf = "$XDG_CONFIG_HOME/hypr/monitors.conf";

  monitorAdded = writeShellScriptBin "monitor-added" ''
    hyprctl dispatch moveworkspacetomonitor 1 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 2 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 3 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 4 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 5 HDMI-A-1
    echo "monitor=HDMI-A-1,3840x2160@59.99700,0x0,2" > ${monitorsConf}
    echo "monitor=eDP-1,2880x1800@90,1920x0,2,mirror,HDMI-A-1" >> ${monitorsConf}
  '';

  monitorRemoved = writeShellScriptBin "monitor-removed" ''
    echo "monitor=eDP-1,2880x1800@90,0x0,2" > ${monitorsConf}
  '';
in
{
  inherit monitorAdded monitorRemoved;

  wsNix = writeShellScriptBin "ws-nix" ''
    footclient -D ~/workspace/nix-config -E fish -C 'neofetch' &
    footclient -D ~/workspace/nix-config -E fish -C 'nitch' &
  '';

  monitorInit = writeShellScriptBin "monitor-init" ''
    monitors=$(hyprctl monitors)
    if [[ $monitors == *"HDMI-A-1"* ]]; then
      ${lib.exe monitorAdded}
    else
      ${lib.exe monitorRemoved}
    fi
  '';
}