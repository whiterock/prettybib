let doc = """
Prettybib.

Usage:
  prettybib <file> [--output <output>] [--indent <count>] [--max-line-length <length>] [--preserve-order]
  prettybib (-h | --help)
  prettybib --version

Options:
  -h --help                       Show this screen.
  --version                       Show version.
  -o --output <output>            File to write output to.
  -i --indent <count>             Number of spaces used to indent [default: 2].
  -l --max-line-length <length>   Maximum line length before word wrapping occurs [default: 80].
  --preserve_order                Preserve order of bibtex entries for an item as read.
"""
import docopt, streams, tables, strutils, sequtils#, wordwrap
import std/wordwrap

proc is_not_terminated(content: string): bool =
  let not_ended_by_delim = not (content.endsWith("},") or content.endsWith("\","))
  let not_ended_by_digit = not (content[content.len-1].isDigit() or (content.endsWith(",") and content[content.len-2].isDigit()))
  return not_ended_by_delim and not_ended_by_digit

proc surrounded_by(s: string, prefix: string, suffix: string = ""): bool = 
  var suff: string
  if suffix == "": suff = prefix
  else: suff = suffix
  s.startsWith(prefix) and s.endsWith(suff)

proc starts_legally(value: string): bool =
  value.startsWith("{") or value.startsWith("\"") or (value.len > 0 and value[0].isDigit())

proc parse_bibfile(strm: Stream): seq[Table[string, string]] =
  if not isNil(strm):
    var line = ""
    while strm.readLine(line):
      line = line.strip()
      if line.startsWith("@") and not line.startsWith("@comment"):
        var entry = initTable[string, string]()
        var t = line.split("{")
        entry["kind"] = t[0].toLower()
        entry["id"] = t[1].strip(chars={','})
        while strm.readLine(line):
          line = line.strip()
          # echo "    ", line
          if line == "": continue
          if line == "}": 
              # echo "ENTRY END"
              break
          var kv = line.split("=")
          var key = kv[0].strip().toLower()
          var content = kv[1].strip()
          

          # This relies on left-hand short circuiting.
          if content.starts_legally:
            while is_not_terminated(content) and strm.readLine(line):
              line = line.strip()
              if line == "}": break
              # echo "        ", line
              content &= " " & line
              if line.endsWith("},") or line.endsWith("\","):
                break
          else:
            # TODO: Throw some warning here.
            # As is now, illegal entries like >>month = apr,<< are parsed one line only as if they were legal.
            discard
          
          content.removeSuffix(',')
          if content.surrounded_by("{", "}") or content.surrounded_by("\""):
            content = content[1..^2]

          content = content.strip() # It could be like {  Hello }
          if content == "": continue
          
          entry[key] = content
          if line == "}": # We need to break a second time here
            break

        result.add(entry)

    strm.close()


proc write_bib_file(strm: Stream, entries: seq[Table[string, string]], indent: Natural, max_line_length: Natural) =
  for entry in entries:
    strm.writeLine(entry["kind"] & "{" & entry["id"] & ",")
    for k,v in entry.pairs:
      if k == "kind" or k == "id": continue
      if k == "url" and "doi" in entry:
        if v.endsWith(entry["doi"]): continue
          
      if v.all(isDigit):
        strm.writeLine(v & ",")
        continue
      
      let start = " ".repeat(indent) & k & " = "
      strm.write(start)
      let multi = wrapWords(v, max_line_length-start.len-3, false).replace("\n", "\n" & " ".repeat(start.len+1))
      var value: string
      if multi.contains("@"): value = "\"" & multi & "\""
      else: value = "{" & multi & "}"
      strm.writeLine(value & ",")
    strm.writeLine("}\n")


when isMainModule:
  let args = docopt(doc, version = "0.2.0")
  echo args

  var strm = newFileStream($args["<file>"], fmRead)
  var entries = parse_bibfile(strm)

  var f = newFileStream(stdout)
  if args["--output"]: f = newFileStream($args["--output"], fmWrite)

  f.write_bib_file(entries, parseInt($args["--indent"]), parseInt($args["--max-line-length"]))