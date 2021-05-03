{ pkgs, ...}:

let
  # unstable_pkgs = import <nixpkgs-unstable> {};
  unstable_pkgs = import (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  ) {};

  python_version = pkgs.python38;
  custom_pkgs = pkgs.callPackage ./pkgs/all.nix { inherit pkgs; python3=python_version; };
in

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # Various packages I want my user to have access to
  home.packages = with pkgs; [
    alacritty
    bat
    brightnessctl
    bpytop
    #custom_pkgs.awscli
    custom_pkgs.i3-config
    custom_pkgs.polybar-launcher
    custom_pkgs.polybar-spotify
    discord
    docker-compose
    firefox-devedition-bin
    flameshot
    git-lfs
    gitAndTools.delta
    jq
    lsd
    meld
    mupdf
    neovim-nightly
    pass
    playerctl
    pstree
    rofi
    rofi-pass
    scrot
    signal-desktop
    spotify
    tldr
    universal-ctags
    unstable_pkgs.zplug
    vifm
    xclip
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xorg.xev
    xorg.xprop
    yubioath-desktop
    # zsh
  ];

  programs = {
    zsh = {
      enable = true;
      oh-my-zsh.enable = false;

      # Ensure ZSH setup pulls in my dotfiles stuff...
      initExtra = ''
        if [ -f "$HOME/.config/nixpkgs/dotfiles/zsh/zshrc" ]; then
          source "$HOME/.config/nixpkgs/dotfiles/zsh/zshrc"
        fi
      '';
    };
    alacritty = {
      enable = true;
    };
  };

  # Setup notifications
  services.dunst.enable = true;

  # Polybar
  services.polybar = {
    enable = true;
    config = ./dotfiles/polybar/config;
    package = pkgs.polybarFull;
    script = ''
      export HOME=/home/sam
      export DISPLAY=:0
      export PATH=/run/wrappers/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin
      IFS=$'\n'
      for line in $(polybar-launcher --no-kill --echo-only)
      do
        eval "$line"
      done
      unset IFS
    '';
  };

  # Enable FZF
  programs.fzf.enable = true;

  # Enable GPGAgent
  programs.gpg.enable = true;
  services.gpg-agent ={
    enable = true;
    pinentryFlavor = "qt";
    grabKeyboardAndMouse = true;
  };

  # Enable and manage tmux via home-manager
  programs.tmux = {
    enable = true;
    # extraConfig = readFile ./dotfiles/tmux/tmux.conf;
  };

  # File setup for various RC/Config files etc.
  home.file = {
    ".tmux.conf".source = ./dotfiles/tmux/tmux.conf;
    ".background-image".source = ./backgrounds/pexels-pixabay-220072.jpg;
  };

  # config file management
  xdg.configFile = {
    "i3/config".source = "${custom_pkgs.i3-config}/config";
    "i3/config".onChange = "i3-msg restart && systemctl --user restart polybar";

    "alacritty/alacritty.yml".source = ./dotfiles/alacritty/alacritty.yml;
  };

  # Attempt to sort out x Session.
  xsession.enable = true;
  xsession.windowManager.command = "i3";

}
