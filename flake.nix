{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  # inputs.idris2-pkgs.url = "github:claymager/idris2-pkgs";
  inputs.taffy-nix.url = "github:xavierzwirtz/taffy-nix";
  inputs.idris2 = {
    url = "github:idris-lang/Idris2";
  };
  inputs.json = {
    url = "github:stefan-hoeck/idris2-json";
    flake = false;
  };
  inputs.elab-util = {
    url = "github:stefan-hoeck/idris2-elab-util";
    flake = false;
  };

  inputs.idris2-pkgs = {
    url = "github:lizard-business/idris2-pkgs/idris0.6.0";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.idris2.follows = "idris2";
    inputs.json.follows = "json";
    inputs.elab-util.follows = "elab-util";
  };

  inputs.idris2-ffigen.url = "github:xavierzwirtz/idris2-ffigen";
  # inputs.idris2-ffigen.url = "path:/home/xavier/projects/idris2-ffigen";
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , taffy-nix
    , idris2-pkgs
    , idris2
    , json
    , elab-util
    , idris2-ffigen
    }:
    let
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          overlays = [
            idris2-pkgs.overlay
            idris2-ffigen.overlay
          ];
        };
      mainExports = flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = mkPkgs system;
            taffy-clib = taffy-nix.packages.${system}.taffy-clib;
            libidris2-taffy-ext = pkgs.stdenv.mkDerivation {
              name = "libidris2-taffy-ext";
              unpackPhase = "true";
              installPhase = "true";
              buildInputs = with pkgs; [ taffy-clib ];
              buildPhase = ''
                mkdir -p $out/lib
                cc -c -fPIC -o libidris2-taffy-ext.o \
                    -I${self}/src/idris2-taffy-ext \
                    ${self}/src/idris2-taffy-ext/idris2-taffy-ext.c
                cc -shared -fPIC -Wl,-soname,libidris2-taffy-ext.so.1 \
                    -o libidris2-taffy-ext.so.0.0.1 libidris2-taffy-ext.o -lc \
                    -L${taffy-clib}/lib/\
                    -ltaffy
                cp libidris2-taffy-ext.so.0.0.1 libidris2-taffy-ext.o $out/lib
                ln -s $out/lib/libidris2-taffy-ext.so.0.0.1 $out/lib/libidris2-taffy-ext.so
                ln -s $out/lib/libidris2-taffy-ext.so.0.0.1 $out/lib/libidris2-taffy-ext.so.1
              '';
              keepDebugInfo = true;
              dontStrip = true;
            };
            idris2-taffy-ext-bindings = pkgs.idris2-ffigen-make-package {
              authors = "xavierzwirtz";
              packageName = "idris2-taffy-ext-bindings";
              header = "${self}/src/idris2-taffy-ext/idris2-taffy-ext.h";
              libName = "libidris2-taffy-ext";
              clib = libidris2-taffy-ext;
              ccArgs = "-I${taffy-clib}/include";
              moduleName = "TaffyExtBindings";
              structs = [
                {
                  structName = "Idris2_Taffy_Ext_Layout";
                  createConstructor = false;
                  members = [
                    {
                      memberName = "x";
                      createSet = false;
                      createGet = true;
                    }
                    {
                      memberName = "y";
                      createSet = false;
                      createGet = true;
                    }
                    {
                      memberName = "width";
                      createSet = false;
                      createGet = true;
                    }
                    {
                      memberName = "height";
                      createSet = false;
                      createGet = true;
                    }
                    {
                      memberName = "childCount";
                      createSet = false;
                      createGet = true;
                    }
                    {
                      memberName = "children";
                      createSet = false;
                      createGet = false;
                    }
                  ];
                }
              ];
              functions = [
                {
                  functionName = "Idris2_Taffy_Ext_Layout_get_child";
                  hasIO = true;
                  functionArgSettings = [ ];
                }
                {
                  functionName = "idris2_taffy_ext_compute_layout";
                  hasIO = true;
                  functionArgSettings = [ ];
                }
              ];
            };
            idris2-taffy-bindings = pkgs.idris2-ffigen-make-package {
              authors = "xavierzwirtz";
              packageName = "idris2-taffy-bindings";
              header = "${taffy-clib}/include/taffy.h";
              libName = "libtaffy";
              clib = taffy-clib;
              moduleName = "TaffyBindings";
              structs = [
                {
                  structName = "TaffyStyleDimension";
                  createConstructor = true;
                  members = [];
                }
                {
                  structName = "TaffyStyleRect";
                  createConstructor = true;
                  members = [];
                }
                {
                  structName = "TaffyStyleSize";
                  createConstructor = true;
                  members = [];
                }
                {
                  structName = "TaffySize";
                  createConstructor = true;
                  members = [];
                }
              ];
              functions = [
                {
                  "functionName" = "taffy_style_create";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_style_free";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_init";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_free";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_create";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_free";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_set_style";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_dirty";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_mark_dirty";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_add_child";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_replace_child_at_index";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_remove_child";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_remove_child_at_index";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
                {
                  "functionName" = "taffy_node_compute_layout";
                  "hasIO" = true;
                  "functionArgSettings" = [ ];
                }
              ];
            };


            #   pkgs.runCommand "bindings" { } ''
            #   mkdir $out
            #   cd $out
            #   ${pkgs.idris2-ffigen}/bin/idris2-ffigen \
            #     ${raw-bindings}/taffy.h.json '{
            #       "libName": "libtaffy",
            #       "moduleName": "Taffy.Bindings",
            #       "structsToParse": [
            #         "TaffyStyleDimension",
            #         "TaffyStyleRect",
            #         "TaffyStyleSize",
            #         "TaffySize"
            #       ],
            #       "functionsToParse": [
            #         {
            #           "functionName": "taffy_style_create",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_style_free",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "strech_init",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_free",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_create",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_free",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_set_measure",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_set_style",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_dirty",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_mark_dirty",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_add_child",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_replace_child_at_index",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_remove_child",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_remove_child_at_index",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         },
            #         {
            #           "functionName": "taffy_node_compute_layout",
            #           "hasIO": true,
            #           "functionArgSettings": []
            #         }
            #       ]
            #     }'
            # '';
          in
          rec {
            packages =
              {
                inherit idris2-taffy-bindings libidris2-taffy-ext idris2-taffy-ext-bindings;
              };
            devShells.idris2-taffy = pkgs.mkShell {
              buildInputs = [
                taffy-clib
                pkgs.idris2
                idris2-taffy-bindings.clib
                idris2-taffy-ext-bindings.clib
                libidris2-taffy-ext
              ];
              LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
                taffy-clib
                pkgs.idris2
                idris2-taffy-bindings.clib
                idris2-taffy-ext-bindings.clib
                libidris2-taffy-ext
              ];
              IDRIS2_PACKAGE_PATH =
                builtins.concatStringsSep ":" [
                  "${pkgs.idris2}/${pkgs.idris2.name}"
                  "${idris2-taffy-bindings.idris2Lib.asLib}/idris2-${pkgs.idris2.version}"
                  "${idris2-taffy-ext-bindings.idris2Lib.asLib}/idris2-${pkgs.idris2.version}"
                ];
            };
            devShell = pkgs.mkShell {
              buildInputs = [
                pkgs.idris2
              ];
              IDRIS2_PACKAGE_PATH = "${pkgs.idris2}/${pkgs.idris2.name}";
            };
          }
        );
    in
    mainExports;
}
