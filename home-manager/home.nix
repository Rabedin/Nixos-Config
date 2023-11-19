# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./configs/hyprland/hyprland.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "red";
    homeDirectory = "/home/red";
  };

  # Programs
  programs = {
    # chromium
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions =
      let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in 
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:1y5bcba6w97mdq0cmw75k25rw7fxnlyy4165vls7vf6xkw9aqy3z";
          version = "1.53.0";
         })
        (createChromiumExtension {
          # proton pass
          id = "ghmbeldphafepmbegfdlkpapadhbakde";
          sha256 = "sha256:1yy03kix9zi1xwnhd7v3bi8q53yhf5h0yhk1b1k53j8xymkydhwl";
          version = "1.8.4";
         })
      ];
    };
    # git
    git = {
      enable = true;
      aliases = {
        co = "checkout";
        cm = "commit";
      };
      userName = "rabedin";
      userEmail = "chromeplated@protonmail.com";
    };
    # kitty
    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
    };
    # neovim
    neovim = {
      enable = true;
      vimAlias = true;
    };
    # zsh
    zsh = {
      enable = true;
      shellAliases = {
        updateconfig = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
        updatehome = "home-manager switch --flake ~/nixos-config/#red@nixos";
      };
      # histSize = 10000;
      # histFile = "${config.xdg.dataHome}/zsh/history";
      oh-my-zsh = {
        enable = true;
        plugins = [  ];
        theme = "agnoster";
      };
    };
    # eww
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./configs/eww;
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    wl-clipboard
    gnumake
    iosevka
    nerdfonts
    steam
    pavucontrol
    discord
    swww
    remmina
    ranger
    mako
    neofetch
    htop
    rustup
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
