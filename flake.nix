{
  description = "Pygame Entwicklungsumgebung für uns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Wir gehen hier von 64-bit Systemen aus (Standard für WSL und Desktop)
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Hier definieren wir unser Python inklusive Pakete
      myPython = pkgs.python3.withPackages (ps: with ps; [
        pygame
        # Hier könntet ihr später mehr hinzufügen, z.B. numpy
      ]);

    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          myPython
          pkgs.python3
          pkgs.git
        ];

        # Optional: Umgebungsvariablen für bessere Kompatibilität
        # Besonders wichtig unter WSL oder NixOS für Grafiktreiber-Links
        shellHook = ''
          echo "🎮 Willkommen in der Pygame-Entwicklungsumgebung!"
          echo "Python Version: $(python --version)"
          
          # Manchmal braucht Pygame Hilfe, um Bibliotheken auf NixOS zu finden
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXinerama
            pkgs.xorg.libXi
            pkgs.xorg.libXrandr
            pkgs.libGL
            pkgs.libGLU
          ]}:$LD_LIBRARY_PATH
        '';
      };
    };
}
