{ config, options, lib, home-manager, ... }:

with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs { };

    snowflake = {
      dir = mkOpt path (findFirst pathExists (toString ../.) [
        "${config.user.home}/git/Icy-Thought/Snowflake"
        "/etc/Snowflake"
      ]);

      binDir = mkOpt path "${config.snowflake.dir}/bin";
      configDir = mkOpt path "${config.snowflake.dir}/config";
      modulesDir = mkOpt path "${config.snowflake.dir}/modules";
      themeDir = mkOpt path "${config.snowflake.modulesDir}/theme";
    };

    homeManager = mkOpt' attrs { } "Define home-manager related settings.";

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    user = let
      user = builtins.getEnv "USER";
      name = if elem user [ "" "root" ] then "icy-thought" else user;
    in {
      inherit name;
      description = "Primary user account";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
    };

    # Necessary for nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      #   Allow home-manager access through homeManager:
      #   homeManager      ->  home-manager.users.icy-thought
      users.${config.user.name} = mkAliasDefinitions options.homeManager;
    };

    #   Quick access to homeManager without homeManager.home:
    #   home.file        ->  home-manager.users.icy-thought.home.file
    #   home.configFile  ->  home-manager.users.icy-thought.home.xdg.configFile
    #   home.dataFile    ->  home-manager.users.icy-thought.home.xdg.dataFile

    homeManager.home = {
      file = mkAliasDefinitions options.home.file;
      stateVersion = config.system.stateVersion;
    };

    homeManager.xdg = {
      configFile = mkAliasDefinitions options.home.configFile;
      dataFile = mkAliasDefinitions options.home.dataFile;
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let users = [ "root" config.user.name ];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    env.PATH = [ "$SNOWFLAKE_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
