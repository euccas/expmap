# MSVC: Microsoft Visual C++

Created since: 2017-1-26 by Euccas

## Contents

* Which files need be committed to version control in a MSVC project?


## Which files need be committed to version control in a MSVC project?

File types should be committed to version control:
- .cpp: source code
- .filters: project file
- .h: source code
- .ico: resource
- .rc: resource script
- .rc2: resource script
- .sln: project file
- .txt: project element
- .vcxproj: project file

File types should NOT be committed to version control:
- .aps: last resource editor state
- .exe: build result
- .idb: build state
- .ipch: build helper
- .lastbuildstate: build helper
- .lib: build result. Can be 3rd party
- .log: build log
- .manifest: build helper. Can be written yourself.
- .obj: build helper
- .pch: build helper
- .pdb: build database
- .res: build helper
- .sdf: intellisense dbase
- .suo: solution user options
- .tlog: build log
- .user: debug settings. Do preserve if just one dev or custom debug settings

Reference: [Stack Overflow: Which Visual C++ file types should be committed to version control?
](https://stackoverflow.com/questions/3922660/which-visual-c-file-types-should-be-committed-to-version-control)

