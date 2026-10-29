{
  lib,
  stdenvNoCC,
  kdePackages,
  theme ? "hyprland_kath",
  font ? null,
  background ? null,
}: let
  backgroundName = let
    name = baseNameOf (toString background);
    extension = builtins.match ".*(\\.[^.]+)$" name;
  in "custom-background${
    if extension == null
    then ""
    else builtins.head extension
  }";
in
  assert lib.assertMsg (builtins.pathExists (../Themes + "/${theme}.conf"))
  "Unknown theme '${theme}'. Choose a theme from the Themes directory.";
    stdenvNoCC.mkDerivation {
      pname = "sddm-astronaut-theme";
      version = "1.4";

      src = lib.fileset.toSource {
        root = ../.;
        fileset = lib.fileset.unions [
          ../Assets
          ../Backgrounds
          ../Components
          ../Previews
          ../Themes
          ../Main.qml
          ../metadata.desktop
          ../LICENSE
          ../README.md
        ];
      };

      dontWrapQtApps = true;

      propagatedBuildInputs = with kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
        cp -r . $out/share/sddm/themes/sddm-astronaut-theme

        themeDir=$out/share/sddm/themes/sddm-astronaut-theme

        sed -i \
          "s|^ConfigFile=.*|ConfigFile=Themes/${theme}.conf|" \
          "$themeDir/metadata.desktop"

        ${lib.optionalString (font != null) ''
          sed -i \
            "s|^Font=.*|Font=\"${font}\"|" \
            "$themeDir/Themes/${theme}.conf"
        ''}

        ${lib.optionalString (background != null) ''
          install -m644 "${background}" \
            "$themeDir/Backgrounds/${backgroundName}"

          sed -i \
            "s|^Background=.*|Background=\"Backgrounds/${backgroundName}\"|" \
            "$themeDir/Themes/${theme}.conf"
        ''}

        runHook postInstall
      '';

      meta = {
        description = "Modern Qt 6 SDDM theme with animated backgrounds and a virtual keyboard";
        homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.linux;
      };
    }
