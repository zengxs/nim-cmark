import unittest

import cmark

test "cmark version":
  let version = cmark_version()

  check len(version) > 0

test "markdown to html":
  let html = markdown_to_html("# hello", CMARK_OPT_DEFAULT)
  check html == "<h1>hello</h1>\n"
