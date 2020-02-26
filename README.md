# prettybib
This is a tool for perfectionist. It aims to prettify and normalize/standardize `.bib` files which are used by bibtex, biblatex, etc. for bibliography management in LaTeX.

## Motivation
When writing research articles I faced the issue of rapidyl growly bibliographic references. Now my problem wasn't the size, rather that I did not know which style guideline to follow for my `.bib` files which made them ugly quickly, but more importantly, it made the files harder to parse for a human. This was especially intensified by the use of exported citations. Many journals (the corresponding online versions) have features for exporting citations in bibtex style, then there are also tools like doi2bib and isbn2bib, etc. which all output bibtex references in different formats, i.e. different style, indendation, sometimes also errorneous fields or deprecated syntax etc. which lead me to build this simple tool. 

Now surely there are lots of bibliography managers and full blown solutions out there that try to solve this same problem (and more), but I personally find them overkill for many scenarios and I try to avoid learning a whole new tool when possible. All my tool does is parse the (ugly) input file and produce a normalized and pretty output `.bib` file.
