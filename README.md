# nim-cmark

[libcmark] wrapper for Nim.

## Installation
**nim-cmark** requires that [libcmark] is installed and the shared library is available.

#### How to install libcmark?
macOS
```sh
brew install cmark
```

Ubuntu
```sh
sudo apt install libcmark-dev
```

Windows
> Refer to <https://github.com/commonmark/cmark#installing-windows>.


## Getting Started
~~~nim
import cmark

let markdown = """
# hello

```nim
echo "hello world"
```
"""

echo markdown_to_html(markdown, CMARK_OPT_DEFAULT)
~~~

Got output:
```html
<h1>hello</h1>
<pre><code class="language-nim">echo &quot;hello world&quot;
</code></pre>
```

## License
All code is released under the [Apache-2.0](./LICENSE) license.


[libcmark]: https://github.com/commonmark/cmark
