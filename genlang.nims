import ospaths, strutils, strformat

let
  langs = @["bash", "c", "cpp", "css", "go", "html", "javascript",
            "ocaml", "php", "python", "ruby", "rust", "typescript",
            "agda", "c_sharp", "haskell", "java", "scala", "nim"]
  broken = @["julia"]

var
  gen = false
  git = false
  test = false
  install = false
  uninstall = false
  clean = false
  lib = false

for i in 3 .. paramCount():
  echo paramStr(i)
  case paramStr(i):
    of "--gen":
      gen = true
    of "--git":
      git = true
    of "--test":
      test = true
    of "--uninstall":
      uninstall = true
    of "--clean":
      clean = true
    of "--lib":
      lib = true
    of "--install":
      install = true

if clean:
  withDir("treesitter"):
    rmDir("treesitter")

if test:
  withDir("treesitter"):
    exec "nimble develop -y"
    exec "nimble setup"
    exec "nimble test"

for lang in langs:
  let flang = "treesitter_" & lang

  if gen:
    mkDir(flang)
    mkDir(flang/"tests")

    for file in ["treesitter_lang.cfg", "treesitter_lang.nimble", "tests"/"ttreesitter_lang.nim"]:
      let nfile = file.replace("lang", lang)
      cpFile("lang"/file, flang/nfile)

      writeFile(flang/nfile,
        readFile(flang/nfile).
          replace("${LANG}", lang).
          replace("${HLANG}", lang.replace("_", "-")))

  withDir(flang):
    if clean:
      rmDir("treesitter")
      rmDir(flang)

    if test:
      exec "nimble develop -y"
      exec "nimble setup"
      exec "nimble test"

    if install:
      exec "nimble setup"
      exec "nimble install"

    if lib:
      echo "build dynamic lib"
      exec fmt"nim --app:lib c treesitter_{lang}/{lang}.nim"

    if uninstall:
      discard gorgeEx("nimble uninstall -y " & flang)

    if git:
      exec "git add " & flang & ".cfg"
      exec "git add " & flang & ".nimble"
      exec "git add -f tests/ttreesitter_" & lang & ".nim"

if uninstall:
  discard gorgeEx("nimble uninstall -y treesitter")