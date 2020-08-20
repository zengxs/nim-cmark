include "cmark/constants"

import cmark/native

proc cmark_version*(): string =
  result = $native.cmark_version_string()

proc markdown_to_html*(text: string, opt: int): string =
  let
    str: cstring = text
    len: csize_t = len(text).csize_t

  let html: cstring = cmark_markdown_to_html(str, len, opt.cint)
  defer: free(html)

  result = $html
