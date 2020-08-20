import unittest

import cmark/native

test "cmark_version":
  let
    version = cmark_version()
    version_string = cmark_version_string()

  check $typeof(version) == "cint"
  check $typeof(version_string) == "cstring"

  check version.int > 0
  check len($version_string) > 0

test "cmark_markdown_to_html":
  let
    md: cstring = "# hello\n---"
    html = cmark_markdown_to_html(md, len(md).csize_t, 0)
  defer:
    free(html)

  check $html == "<h1>hello</h1>\n<hr />\n"

test "cmark_parse_document":
  let
    md: cstring = "# hello\n---"
    tree = cmark_parse_document(md, len(md).csize_t, CMARK_OPT_DEFAULT)
  defer:
    cmark_node_free(tree)

  check not tree.isNil()
