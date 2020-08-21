# Package

version       = "0.1.0"
author        = "zengxs"
description   = "libcmark wrapper for Nim"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["a", "nim"]


# Dependencies

requires "nim >= 1.0.0"

when defined(nimdistros):
  import distros
  foreignDep "cmake"


# Tasks

task prebuild, "Generate required headers for libcmark":
  withDir "libcmark":
    exec "make"

  cpFile "./libcmark/build/src/libcmark.a", "./src/libcmark.a"

before install:
  exec "nimble prebuild"

before test:
  exec "nimble prebuild"
