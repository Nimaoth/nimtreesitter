import treesitter/api
import treesitter_markdown/markdown

var p = tsParserNew()

assert p.tsParserSetLanguage(treeSitterMarkdown()) == true

p.tsParserDelete()