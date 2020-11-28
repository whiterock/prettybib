# prettybib

![build](https://github.com/whiterock/prettybib/workflows/build/badge.svg)

This is a tool for the perfectionist. It aims to prettify and normalize/standardize `.bib` files which are used by bibtex, biblatex, biber, etc. for bibliography management in LaTeX.

## Motivation
When writing research articles I faced the issue of a rapidly growing list of bibliographic references. Now my problem wasn't the size, rather that I did not know which style guideline to follow for my `.bib` files which made them ugly very quickly, but more importantly, it made the files harder to parse for a human. This was especially intensified by the use of exported citations. Many journals (the corresponding online versions) have features for exporting citations in bibtex style, then there are also tools like doi2bib and isbn2bib, etc. which all output bibtex references in different formats, i.e. different style, indendation, sometimes also errorneous fields or deprecated syntax etc. which all lead me to build this simple tool. 

Now surely there are lots of bibliography managers and full blown solutions out there that try to solve this same problem (and more), but I personally find them overkill for many scenarios and I try to avoid learning a whole new tool whenever possible. All my tool does is parse the (potentially ugly) input file and produce a normalized and pretty output `.bib` file. It can also do tiny optimizations like removing the `url` field when a `doi` field is set and the doi is contained in the url. (This was something I personally needed badly)

## Usage
```
Usage:
  prettybib <file> [--output <output>] [--indent <count>] [--max-line-length <length>] [--keep-url-if-doi] [--preserve-order]
  prettybib (-h | --help)
  prettybib --version

Options:
  -h --help                       Show this screen.
  --version                       Show version.
  -o --output <output>            File to write output to.
  -i --indent <count>             Number of spaces used to indent [default: 2].
  -l --max-line-length <length>   Maximum line length before word wrapping occurs [default: 88].
  --keep-url-if-doi               Keeps the url field if it contains the doi set in the doi field.
                                  Normally it would be removed due to ugly redundancy.
  --preserve-order                Preserve order of bibtex entries for an item as read. (not implemented)
```

## Example
The following minimalistic `.bib` file
```bibtex
@book{klement2000,
  doi = {10.1007/978-94-015-9540-7},
  url = {https://doi.org/10.1007/978-94-015-9540-7},
  year = {2000},
  publisher = {Springer Netherlands},
  author = {Erich Peter Klement and Radko Mesiar and Endre Pap},
  title = {Triangular Norms}
}


@Book{klir1995fuzzy,
 author = {Klir, George and Bo Yuan},
 title = {Fuzzy sets and fuzzy logic : theory and applications},
 publisher = {Prentice Hall PTR},
 year = {1995},
 address = {Upper Saddle River, N.J},
 isbn = {9780131011717}
 }
@phdthesis{liebscher2007,
author = {Liebscher, Martin},
year = {2007},
month = {01},
pages = {},
journal = {Publikationen des Instituts für Statik und Dynamik der Tragwerke},
school = {Technische Universit\"{a}t Dresden},
title = {Dimensionierung und Bewertung von Tragwerken bei Unschärfe - Lösung des inversen Problems mit Methoden der explorativen Datenanalyse}
}
@Book{bandemer1997ratschlage,
  Author         = {Bandemer, Hans},
  Title          = {Ratschl\"age zum mathematischen {U}mgang mit
                   {U}ngewi\ss{}heit: {R}easonable {C}omputing},
  Publisher      = {Teubner Verlag},
  Address        = {Leipzig},
  year           = 1997
}
```
gets turned into this
```bibtex
@book{klement2000,
  year      = 2000,
  title     = {Triangular Norms},
  doi       = {10.1007/978-94-015-9540-7},
  author    = {Erich Peter Klement and Radko Mesiar and Endre Pap},
  publisher = {Springer Netherlands},
}

@book{klir1995fuzzy,
  isbn      = 9780131011717,
  year      = 1995,
  address   = {Upper Saddle River, N.J},
  title     = {Fuzzy sets and fuzzy logic : theory and applications},
  author    = {Klir, George and Bo Yuan},
  publisher = {Prentice Hall PTR},
}

@phdthesis{liebscher2007,
  journal   = {Publikationen des Instituts für Statik und Dynamik der
               Tragwerke},
  year      = 2007,
  month     = 01,
  school    = {Technische Universit\"{a}t Dresden},
  title     = {Dimensionierung und Bewertung von Tragwerken bei Unschärfe -
               Lösung des inversen Problems mit Methoden der explorativen
               Datenanalyse},
  author    = {Liebscher, Martin},
}

@book{bandemer1997ratschlage,
  year      = 1997,
  address   = {Leipzig},
  title     = {Ratschl\"age zum mathematischen {U}mgang mit {U}ngewi\ss{}heit:
               {R}easonable {C}omputing},
  author    = {Bandemer, Hans},
  publisher = {Teubner Verlag},
}
```
using `prettybib examples/tiny_test.bib -o examples/tiny_test.pretty.bib`. (see examples directory)

## Installing
Clone this repo and run `nimble install` inside of it.

## Troubleshooting
If you cannot execute `prettybib` from your shell, make sure that `~/.nimble/bin` is in your path, i.e. do this: 
```sh
export PATH="$HOME/.nimble/bin:$PATH"
```

## Contributing
Just fork this repo, change to your likings and open a pull request. This project is very alpha and I am happy for improvements, features or bug fixes. Also feel free to propose ideas in the issues tab.
