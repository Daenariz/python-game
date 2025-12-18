{
  description = "Pygame Entwicklungsumgebung für uns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      myPython = pkgs.python3.withPackages (ps: with ps; [
        pygame
      ]);

      ninjinLuaConfig = pkgs.writeText "config.lua" ''
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
        })

      vim.opt.clipboard = "unnamedplus"

        if vim.fn.has("wsl") == 1 or os.getenv("NixOS") ~= nil then
          vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
              ['+'] = 'clip.exe',
              ['*'] = 'clip.exe',
            },
            paste = {
              ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
          }
        end
      '';

      ninjinBase = pkgs.neovim.override {
      configure = {
      customRC = ''
          set number
          set termguicolors

          " --- COLORSCHEME SETTINGS ---
          set background=dark
          colorscheme gruvbox

          luafile ${ninjinLuaConfig}
          '';
      packages.ninjinPlugins = with pkgs.vimPlugins; {
        start = [
          gruvbox-nvim
          (nvim-treesitter.withPlugins (p: [p.python p.lua p.nix p.vim p.vimdoc ]))
      ];
    };
    };
    };

      ninjinNeovim = pkgs.writeShellScriptBin "nv" ''
        ${ninjinBase}/bin/nvim "$@"
        '';
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          myPython
          pkgs.python3
          pkgs.git
          ninjinNeovim
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
           # --- GIT CONFIG AUTO-SETUP ---
          # Prüft, ob wir in einem Git Repo sind und ob user.name fehlt
          if [ -d .git ]; then
            if [ -z "$(git config user.name)" ]; then
              echo ""
              echo "⚠️  Git ist für dieses Repo noch nicht konfiguriert."
              echo "Bitte gib deine Daten ein (werden nur lokal für dieses Projekt gespeichert):"

              read -p "Dein Name: " gname
              git config user.name "$gname"

              read -p "Deine Email: " gmail
              git config user.email "$gmail"

              echo "✅ Git konfiguriert als: $gname <$gmail>"
              echo ""
            fi
          fi
        '';
      };
    };
}
