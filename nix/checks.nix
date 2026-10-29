{
  pkgs,
  theme,
}: let
  qt = pkgs.kdePackages;

  themePath = "${theme}/share/sddm/themes/sddm-astronaut-theme";

  greeter = qt.sddm.override {
    extraPackages = with qt; [
      qtmultimedia
      qtvirtualkeyboard
    ];
  };

  # SDDM logs to journald unless stderr is a TTY. `script` allocates a PTY so
  # the greeter's QML diagnostics end up in a file that can be inspected.
  runGreeter = {
    name,
    package,
    script,
    timeout ? 15,
  }:
    pkgs.runCommand name {
      nativeBuildInputs = [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.util-linux
      ];
    } ''
      export HOME=$TMPDIR
      export XDG_RUNTIME_DIR=$TMPDIR/xdg
      mkdir -p "$XDG_RUNTIME_DIR"
      chmod 700 "$XDG_RUNTIME_DIR"

      set +e
      timeout ${toString timeout}s script -qefc \
        'env QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software ${package}/bin/sddm-greeter-qt6 --test-mode --theme ${themePath}' \
        "$TMPDIR/greeter.log" >/dev/null 2>&1
      set -e

      ${script}
    '';
in {
  theme-package =
    pkgs.runCommand "sddm-astronaut-theme-package-check" {
      nativeBuildInputs = [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gnused
      ];
    } ''
      themeDir=${themePath}

      test -f "$themeDir/metadata.desktop"
      test -f "$themeDir/Main.qml"

      configFile=$(sed -n 's/^ConfigFile=//p' "$themeDir/metadata.desktop")
      test -n "$configFile"
      test -f "$themeDir/$configFile"

      for conf in "$themeDir"/Themes/*.conf; do
        for key in Background BackgroundPlaceholder; do
          value=$(sed -n "s/^$key=\"\(.*\)\"$/\1/p" "$conf")
          if [ -n "$value" ] && ! test -f "$themeDir/$value"; then
            echo "$conf references missing $key: $value" >&2
            exit 1
          fi
        done
      done

      touch $out
    '';

  greeter-loads-theme = runGreeter {
    name = "sddm-astronaut-greeter-loads-theme";
    package = greeter;
    script = ''
      log="$TMPDIR/greeter.log"
      cat "$log"

      grep -F 'Loading file://${themePath}/Main.qml' "$log"
      grep -F 'Adding view for' "$log"
      grep -F 'qml: Video started.' "$log"

      ! grep -F 'Fallback to embedded theme' "$log"
      ! grep -F 'QQmlApplicationEngine failed' "$log"
      ! grep -E 'module "[^"]+" is not installed' "$log"
      ! grep -F 'Cannot open: file://${themePath}' "$log"
      ! grep -E 'QML (Error|error)' "$log"

      touch $out
    '';
  };

  missing-multimedia-is-detected = runGreeter {
    name = "sddm-astronaut-missing-multimedia-is-detected";
    package = qt.sddm;
    script = ''
      cat "$TMPDIR/greeter.log"

      grep -F 'module "QtMultimedia" is not installed' "$TMPDIR/greeter.log"
      touch $out
    '';
  };
}
