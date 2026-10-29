{
  lib,
  stdenvNoCC,
  kdePackages,
}:
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

    runHook postInstall
  '';

  meta = {
    description = "Modern Qt 6 SDDM theme with animated backgrounds and a virtual keyboard";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
