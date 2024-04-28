# Package

version       = "0.1.2"
author        = "genotrance"
description   = "tree-sitter-haskell wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

requires "nimgen >= 0.5.4", "treesitter >= " & version

var
  name = "treesitter_haskell"
  cmd = when defined(Windows): "cmd /c " else: ""
  cc = when defined(MacOSX): "clang" else: "gcc"

if fileExists(name & ".nimble"):
  mkDir(name)

task setup, "Checkout and generate":
  if gorgeEx(cmd & "nimgen").exitCode != 0:
    withDir(".."):
      exec "nimble install nimgen -y"
  exec cmd & "nimgen " & name & ".cfg"

before install:
  setupTask()

task test, "Run tests":
  exec "nim c --" & cc & ".linkerexe:\"g++\" -f -r tests/t" & name & ".nim"

task buildDll, "Build DLL":
  setupTask()
  exec cmd & "nim c --app:lib --gc:none treesitter_haskell/haskell.nim"
