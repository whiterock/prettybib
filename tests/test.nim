import unittest

import prettybib

suite "prettybib":
  test "auxiliary":
    check("{string}".surrounded_by("{", "}"))
    check(not "{string".surrounded_by("{", "}"))
    check("\"text\"".surrounded_by("\""))
    check(not "\"text".surrounded_by("\""))

# TODO: Write proper tests for parse_bibfile and write_bibfile