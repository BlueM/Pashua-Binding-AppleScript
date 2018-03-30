Overview
===========
This is an AppleSript language binding (glue code) for using Pashua with AppleScript. Pashua is a macOS application for using native GUI dialog windows in various programming languages.

This code can be found in a GitHub repository at https://github.com/BlueM/Pashua-Binding-AppleScript. For examples in other programming languages, see https://github.com/BlueM/Pashua-Bindings.

Other related links:
* [Pashua homepage](https://www.bluem.net/jump/pashua)
* [Pashua repository on GitHub](https://github.com/BlueM/Pashua)

Usage
======
This repository contains uncompiled AppleScript code. You can open “Example.applescript” and run it in the script editor, but it needs a compiled version of “Pashua.applescript” (which is also in this folder).

Solution: simply open a Terminal window, run “compile.sh” (i.e.: drag the icon onto the Terminal window and hit Return) and you’re done. You will now have “Example.scpt” and “Pashua.scpt”. “Example.scpt” is the actual example, and “Pashua.scpt” is the “library” for handling the communication with Pashua.

Of course, you will need Pashua on your Mac to run the example. The code expects Pashua.app in one of the “typical” locations, such as the global or the user’s “Applications” folder, or in the folder which contains “Example.scpt” and
“Pashua.scpt”.


Compatibility
=============
This code should run at least on Mac OS X 10.6 or later.

It is compatible with Pashua 0.10. It will work with earlier versions of Pashua, but non-ASCII characters will not be displayed correctly, as any versions before 0.10 required an argument for marking input as UTF-8. If you want to use this code with Pashua < 0.10, you can remove partial line `as «class utf8»` in “Pashua.applescript” or “Pashua.scpt” respectively.


Authors
=========
This code was written by Carsten Blüm, contributions by Eddy Roosnek and Hans Haesler.


License
=========
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

