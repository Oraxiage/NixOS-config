{ pkgs, inputs, ... }:
#  config, pkgs, lib, builtins, inputs, ... before nil 
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  home.username = "adriaan";
  home.homeDirectory = "/home/adriaan";
  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
  home.file.".config/wallpaper.jpg".source = ./wallpaper.jpg;
  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };
  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
    executable = true;
  };
  home.file.".config/ranger" = {
    source = ./ranger;
    recursive = true;
  };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    firefox
    onlyoffice-bin
    spotify
    playerctl # control media
    vesktop # discord alt.
    neofetch
    imv # image viewer
    mpv # video viewer
    zathura # pdf viewer
    glow # render markdown cli
    ranger

    # show-off
    cmatrix
    pipes-rs

    texliveFull

    # cybersecurity tools
    burpsuite
    nmap
    exiftool
    stegseek

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    grim
    slurp
    wl-clipboard
    #swappy
    wev # input detection for keybinds
    fzf
    zoxide
    eza
    bat
    tlp

    # archives
    gnutar
    zip
    xz
    unzip
    p7zip

    # networking tools
    mtr # A network diagnostic tool
    dnsutils  # `dig` + `nslookup`
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    which
    gcc
    gnumake

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
  ];
  programs.git = {
    enable = true;
    userName = "Oraxiage";
    userEmail = "a.brumsen@protonmail.com";
  };
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
  programs.nixvim = {
    globals.mapleader = ",";
    options = {
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
	  # nix
	  nil_ls.enable = true;
	  # python
	  pyright.enable = true;
	  # typescript/javascript
	  tsserver.enable = true;
	};
      };
    };
  };
  programs.swaylock = {
    enable = true;
    settings = {
      color = "3C3836";
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
