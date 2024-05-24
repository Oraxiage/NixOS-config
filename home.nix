{ pkgs, inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  home.username = "adriaan";
  home.homeDirectory = "/home/adriaan";
  # Link configuration file in current directory to the specified location in home directory
  home.file.".config/wallpaper.jpg".source = ./wallpaper.jpg;
  # Link configuration files recursively
  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
    executable = true;
  };
  home.file.".config/ranger" = {
    source = ./ranger;
    recursive = true;
  };

  # User packages
  home.packages = with pkgs; [
    # System Administration & Utils
    hyprlock
    grim
    slurp
    wl-clipboard
    wev
    fzf
    zoxide
    eza
    bat
    tlp
    file
    which
    gnumake
    btop
    strace
    ltrace
    nix-output-monitor
    ranger
    ripgrep 
    jq
    gnutar
    zip
    xz
    unzip
    p7zip
    # Development Tools
    texliveFull
    gcc
    # Security Tools
    burpsuite
    nmap
    exiftool
    stegseek
    # Networking
    mtr
    dnsutils
    ipcalc
    # Internet
    firefox
    discord
    # Multimedia
    imv
    mpv
    playerctl
    spotify
    # Productivity
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_US
    libreoffice
    zathura
    glow
    anytype
    # Ricing & Funny
    pipes-rs
    cmatrix
    fastfetch
    cava
    sl
    fortune
    cowsay
  ];
  
  # User packages that require more configuration
  # Desktop
  programs.waybar = {
    enable = true;
    style = ./waybar/style.css;
    settings = pkgs.lib.importJSON ./waybar/config.json;
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "gruvbox-dark";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark-BL";
      package = pkgs.gruvbox-gtk-theme;
    };
  };
  # Terminal
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    theme = "Gruvbox Dark Hard";
  };
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship/starship.toml;
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      eval "$(starship init bash)"
      eval "$(zoxide init --cmd cd bash)"
      '';
    shellAliases = {
      l = "eza -loah --icons=always";
      cat = "bat --paging=never";
    };
  };
  # Git
  programs.git = {
    enable = true;
    userName = "Oraxiage";
    userEmail = "a.brumsen@protonmail.com";
  };
  # Nixvim
  programs.nixvim = {
    globals.mapleader = ",";
    opts = {
      number = true;
    };
    keymaps = [
      {
        mode = "n";
	key = "ff";
	action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
	key = "fb";
	action = "<cmd>Telescope buffers<cr>";
      }
    ];
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.gruvbox.enable = true;
    plugins = {
      bufferline.enable = true;
      lualine.enable = true;
      vimtex.enable = true;
      telescope.enable = true;
      startify.enable = true;
      lsp = {
        enable = true;
	servers = {
	  nil_ls.enable = true;
	  pyright.enable = true;
	  tsserver.enable = true;
	};
      };
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
