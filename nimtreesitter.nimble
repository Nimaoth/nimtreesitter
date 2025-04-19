# Package

version       = "0.1.9"
author        = "genotrance,Nimaoth"
description   = "tree-sitter wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

const languages = ["agda", "bash", "c", "c_sharp", "cpp", "css", "go", "haskell", "html", "java", "javascript", "nim", "python", "php", "ruby", "rust", "scala", "zig", "json", "markdown"]

const cmd = when defined(Windows): "cmd /c " else: ""

task setup, "Checkout and generate":
  for language in languages:
    let name = "treesitter_" & language
    withDir(name):
      echo "build language ", language
      exec cmd & "nimgen " & name & ".cfg"

before install:
  setupTask()
