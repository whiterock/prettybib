import unittest, os

import prettybib

suite "ex":
  test "something":
    echo getCurrentDir()
    check(true)
    check("{string}".surrounded_by("{", "}"))