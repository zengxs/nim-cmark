import os

include "./constants"

{.passL: joinPath(currentSourcePath.parentDir(), r"../libcmark.a").}

type
  NodeType* = enum ## cmark node types.
    ntNone
      ## Error status

    # Block
    ntDocument
    ntBlockQuote
    ntList
    ntItem
    ntCodeBlock
    ntHtmlBlock
    ntCustomBlock
    ntParagraph
    ntHeading
    ntThematicBreak

    # Inline
    ntText
    ntSoftBreak
    ntLineBreak
    ntCode
    ntHtmlInline
    ntCustomInline
    ntEmph
    ntStrong
    ntLink
    ntImage

  NodeBlock* = range[ntDocument..ntThematicBreak] ## Node block types range.
  NodeInline* = range[ntText..ntImage] ## Node inline types range.

  ListType* = enum
    ltNoList
    ltBulletList
    ltOrderedList

  DelimType* = enum ## Delimiter types.
    dtNoDelim       ## No delimiter
    dtPeriodDelim   ## Period delimiter: `[]`
    dtParenDelim    ## Parenthesis delimiter: `()`

  EventType* = enum ## Event types.
    etNone
    etDone
    etEnter
    etExit

  Node* = object ## `struct cmark_node`
  NodePtr* = ptr Node ## `cmark_node*`

  Parser* = object ## `struct cmark_parser`
  ParserPtr* = ptr Parser ## `cmark_parser*`

  Iter* = object ## `struct cmark_iter`
  IterPtr* = ptr Iter ## `cmark_iter*`


# === Simple Interface ===

proc cmark_markdown_to_html*(text: cstring, len: csize_t, opt: cint): cstring {.importc.}
  ## Convert 'text' (assumed to be a UTF-8 encoded string with length 'len') from
  ## CommonMark Markdown to HTML, returning a null-terminated, UTF-8-encoded string.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_markdown_to_html(const char *text, size_t len, int options);`


# === Creating and Destroying Nodes ===

proc cmark_node_new*(nodeType: NodeType): NodePtr {.importc.}
  ## Creates a new node of type `nodeType`.
  ##
  ## Note that the node may have other required properties, which it is the
  ## caller's responsibility to assign.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_new(cmark_node_type type);`

proc cmark_node_free*(node: NodePtr): void {.importc.}
  ## Frees the memory allocated for a node and any children.
  ##
  ## Native function signature:
  ## `void cmark_node_free(cmark_node *node);`


# === Tree Traversal ===

proc cmark_node_next*(node: NodePtr): NodePtr {.importc.}
  ## Returns the next node in the sequence after `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_next(cmark_node *node);`

proc cmark_node_previous*(node: NodePtr): NodePtr {.importc.}
  ## Returns the previous node in the sequence after `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_previous(cmark_node *node);`

proc cmark_node_parent*(node: NodePtr): NodePtr {.importc.}
  ## Returns the parent of `node`, or `nil` if there is none.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_parent(cmark_node *node);`

proc cmark_node_first_child*(node: NodePtr): NodePtr {.importc.}
  ## Returns the first child of `node`, or `nil` if `node` has no children.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_first_child(cmark_node *node);`

proc cmark_node_last_child*(node: NodePtr): NodePtr {.importc.}
  ## Returns the last child of `node`, or `nil` if `node` has no children.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_node_last_child(cmark_node *node);`


# === Iterator ===

proc cmark_iter_new*(root: NodePtr): IterPtr {.importc.}
  ## Creates a new iterator starting at `root`.
  ##
  ## The current node and event type are undefined until `cmark_iter_next`
  ## is called for the first time.
  ##
  ## The memory allocated for the iterator should be released using
  ## `cmark_iter_free` when it is no longer needed.
  ##
  ## Native function signature:
  ## `cmark_iter *cmark_iter_new(cmark_node *root);`

proc cmark_iter_free*(iter: IterPtr): void {.importc.}
  ## Frees the memory allocated for an iterator.
  ##
  ## Native function signature:
  ## `void cmark_iter_free(cmark_iter *iter);`

proc cmark_iter_next*(iter: IterPtr): EventType {.importc.}
  ## Advances to the next node and returns the event type (`etEnter`,
  ## `etExit` or `etDone`).
  ##
  ## Native function signature:
  ## `cmark_event_type cmark_iter_next(cmark_iter *iter);`

proc cmark_iter_get_node*(iter: IterPtr): NodePtr {.importc.}
  ## Returns the current node.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_iter_get_node(cmark_iter *iter);`

proc cmark_iter_get_event_type*(iter: IterPtr): EventType {.importc.}
  ## Returns the current event type.
  ##
  ## Native function signature:
  ## `cmark_event_type cmark_iter_get_event_type(cmark_iter *iter);`

proc cmark_iter_get_root*(iter: IterPtr): NodePtr {.importc.}
  ## Returns the root node.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_iter_get_root(cmark_iter *iter);`

proc cmark_iter_reset*(iter: IterPtr, node: NodePtr, event: EventType): void {.importc.}
  ## Resets the iterator so that the current node is 'current' and
  ## the event type is 'event_type'.  The new current node must be a
  ## descendant of the root node or the root node itself.
  ##
  ## Native function signature:
  ## `void cmark_iter_reset(cmark_iter *iter, cmark_node *current, cmark_event_type event_type);`


# === Accessors ===
proc cmark_node_get_type*(node: NodePtr): NodeType {.importc.}

proc cmark_node_get_type_string*(node: NodePtr): cstring {.importc.}

proc cmark_node_get_literal*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_literal*(node: NodePtr, content: cstring): cint {.importc.}

proc cmark_node_get_heading_level*(node: NodePtr): cint {.importc.}

proc cmark_node_set_heading_level*(node: NodePtr, level: cint): cint {.importc.}

proc cmark_node_get_list_type*(node: NodePtr): ListType {.importc.}

proc cmark_node_set_list_type*(node: NodePtr, listType: ListType): cint {.importc.}

proc cmark_node_get_list_delim*(node: NodePtr): DelimType {.importc.}

proc cmark_node_set_list_delim*(node: NodePtr, delim: DelimType): cint {.importc.}

proc cmark_node_get_list_start*(node: NodePtr): cint {.importc.}

proc cmark_node_set_list_start*(node: NodePtr, start: cint): cint {.importc.}

proc cmark_node_get_list_tight*(node: NodePtr): cint {.importc.}

proc cmark_node_set_list_tight*(node: NodePtr, tight: cint): cint {.importc.}

proc cmark_node_get_fence_info*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_fence_info*(node: NodePtr, info: cstring) {.importc.}

proc cmark_node_get_url*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_url*(node: NodePtr, url: cstring): cint {.importc.}

proc cmark_node_get_title*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_title*(node: NodePtr, title: cstring): cint {.importc.}

proc cmark_node_get_on_enter*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_on_enter*(node: NodePtr, onEnter: cstring): cint {.importc.}

proc cmark_node_get_on_exit*(node: NodePtr): cstring {.importc.}

proc cmark_node_set_on_exit*(node: NodePtr, onExit: cstring): cint {.importc.}

proc cmark_node_get_start_line*(node: NodePtr): cint {.importc.}

proc cmark_node_get_start_column*(node: NodePtr): cint {.importc.}

proc cmark_node_get_end_line*(node: NodePtr): cint {.importc.}

proc cmark_node_get_end_column*(node: NodePtr): cint {.importc.}


# === Tree Manipulation ===
proc cmark_node_unlink*(node: NodePtr): void {.importc.}

proc cmark_node_insert_before*(node, sibling: NodePtr): cint {.importc.}

proc cmark_node_insert_after*(node, sibling: NodePtr): cint {.importc.}

proc cmark_node_replace*(oldnode, newnode: NodePtr): cint {.importc.}

proc cmark_node_prepend_child*(node, child: NodePtr): cint {.importc.}

proc cmark_node_append_child*(node, child: NodePtr): cint {.importc.}

proc cmark_consolidate_text_nodes*(root: NodePtr): void {.importc.}


# === Parsing ===

proc cmark_parse_document*(text: cstring, len: csize_t, opt: cint): NodePtr {.importc.}
  ## **Simple interface**
  ##
  ## Parse a CommonMark document in `text` of length `len`.
  ## Returns a pointer to a tree of nodes.
  ##
  ## The memory allocated for the node tree should be released
  ## using `cmark_node_free` when it is no longer needed.
  ##
  ## Native function signature:
  ## `cmark_node *cmark_parse_document(const char *buffer, size_t len, int options);`

proc cmark_parser_new*(opt: cint): ParserPtr {.importc.}
  ## Creates a new parser object.
  ##
  ## Native function signature:
  ## `cmark_parser *cmark_parser_new(int options);`

proc cmark_parser_free*(p: ParserPtr): void {.importc.}
  ## Frees memory allocated for a parser object.
  ##
  ## Native function signature:
  ## `void cmark_parser_free(cmark_parser *parser);`

proc cmark_parser_feed*(parser: ParserPtr, buffer: cstring, len: csize_t): void {.importc.}

proc cmark_parser_finish*(parser: ParserPtr): NodePtr {.importc.}


# === Rendering ===

proc cmark_render_xml*(root: NodePtr, opt: cint): cstring {.importc.}
  ## Render a `node` tree as XML.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_xml(cmark_node *root, int options);`

proc cmark_render_html*(root: NodePtr, opt: cint): cstring {.importc.}
  ## Render a `node` tree as an HTML fragment.
  ##
  ## It is up to the user to add an appropriate header and footer.
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_html(cmark_node *root, int options);`

proc cmark_render_man*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a groff man page, without the header.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_man(cmark_node *root, int options, int width);`

proc cmark_render_commonmark*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a commonmark document.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_commonmark(cmark_node *root, int options, int width);`

proc cmark_render_latex*(root: NodePtr, opt, width: cint): cstring {.importc.}
  ## Render a `node` tree as a LaTeX document.
  ##
  ## It is the caller's responsibility to free the returned buffer.
  ##
  ## Native function signature:
  ## `char *cmark_render_latex(cmark_node *root, int options, int width);`


# === Version information ===

proc cmark_version*(): cint {.importc.}
  ## The library version as integer for runtime checks.
  ##
  ## In hexadecimal format, the number `0x010203` represents version `1.2.3`.
  ##
  ## Native function signature:
  ## `int cmark_version(void);`

proc cmark_version_string*(): cstring {.importc.}
  ## The library version string for runtime checks.
  ##
  ## Native function signature:
  ## `const char *cmark_version_string(void);`

# ====================================================

proc free*(str: pointer): void {.importc.}
  ## `free()` function in C library. (`stdlib.h`)
  ##
  ## Native function signature:
  ## `void free(void *);`

