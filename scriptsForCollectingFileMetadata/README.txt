V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
LICENSE
===============================================================================

Copyright © 2021 David Bayani

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
Overview / Description
===============================================================================

This directory contains scripts used to collect useful metadata - such as 
modification times, file sizes, checksums, etc. - for all files and descendant
directories present in a directory users specify. Note: these scripts were 
made for use in a Linux environment; see ./DEPENDENCIES for details.

The scripts themselves - or, at least the parts I wrote, not necessarily the
system commands called internally - are pretty simple. That said, I provided 
the content I wrote here:
(1) because they've been useful for me, 
(2) so that the types / degrees of metadata can be uniform across collections,
    as opposed to typing in something fresh - and possibly different - across
    time and place.
(3) since sometimes the devil is in the details in collecting such info, and
    thus pinning down a script for doing it right (or improving it until it does
    right) is prudent.
Still, it may appear a bit odd to write this much for scripts so short.

^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
Content and Use
===============================================================================

V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
getMetadataForAllFilesAndDirs.sh
===============================================================================

Outputs:
    Output is sent to STDOUT and is in roughly CSV format. If the user specifies
    the --no-name flag (see the description of the script's inputs below), then
    13 columns are produced; in this case, the output should conform to CSV 
    exactly. If the --no-name flag is not specified, then there will be at least
    14 columns, where the 14th column is the name of the file; it is possible, 
    due to commas in a file's name, that a strict CSV interpreter may see more 
    than 14 "columns" since we do not sanitize file names. Unless a filename 
    contains a new-line character or cursor control elements (e.g., backspace),
    then all content on a line after the 13th field should be a filename
    whenever the --no-name flag is not specified. 

    Output column 1:
        If the record is in regard to a file, this column will list the 
        file's sha512 hash. If this record is in regard to a directory, the
        value "Not_Applicable" will be present.

    Output columns 2 through 13 inclusive:
        The columns are generated, in order, by the following subcommand:
            TZ=utc stat --format="%F,%b,%B,%s,%w,%W,%x,%X,%y,%Y,%z,%Z" <name of file or directory that the record is about>
        See "man stat" or (depending on your system) 
        "info '(coreutils) stat invocation'" for a detail of each field.
        The high-level take away is that these fields list the size and
        modification date(s) of a file / directory, along with a few other
        pieces of potentially worthwhile information. 

        Strictly speaking, the columns that are specified by letters of 
        different case in --format should be repetitive with one another; 
        one should list the time in a human readable format, and the other
        in seconds since an epoch. Both are provided primarily for convenience,
        though ensuring there are human-readable fields may assist with 
        usability in a more substantial sense.

    Output column 14 onward (if present):
        The name of the file / directory that the record is in regard to, 
        bearing in mind all the caveats previously mentioned. Note how 
        placing filenames anywhere other than the end of a record would
        have made parsing the rest of the record more difficult in general,
        given that the unescaped nature of filenames presented and the
        effect of the --no-name flag.

Inputs:
    first argument: required
        Relative path to the directory or file to capture metadata 
        for. If a directory is specified, all of its containing files and 
        directories will have their metadata reported, in addition to the
        starting directory. Effects of symbolic links have not been investigated
        at this time.

    second argument: optional
        If users provide the --no-name flag, the names of files will not be
        listed in the metadata. This is useful if you want to demonstrate you
        have material while limiting what information is revealed about it - 
        file names can contain surprising amounts of semantic insight in certain
        situations. 

    example invocation:
       user@computer:/home/userName/myStuff$ ../scriptsDir/getMetadataForAllFilesAndDirs.sh ../../photos/client23 --no-name > ../../photos_metadata.csv

See the "TODOs for Developers" section below for more details and potential 
improvements.

^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
.helper_getFileMetadata.sh
==============================================================================
 
This file is a helper script repeatedly invoked by 
getMetadataForAllFilesAndDirs.sh . Users should not have to use this script
directly in normal circumstances, hence why it is normally hidden (starting with
dot (.) in a file name).

^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
Miscellaneous Notes
===============================================================================
 

I have previously written scripts for collecting this sort of metadata on files
and directories. For instance, a simple implementation I used regularly in the
past involved a two-step process: (1) collect all the director and file names,
and write them to a file, preceded by the command to collect the metadata (i.e.,
write a file in which each line is <command><name of file / directory> ) (2) run
the command generated in (1), writing all successful results and errors to (a)
file(s). On one hand, the creation and reading of an intermediate
file is clearly inelegant and boarding on improper / hacky (for what its worth,
it was a simple implementation to get the job done from what I recall). On the
other hand, this framework may have made debugging and detecting issues easier,
operation a bit more robust, and allowed file names to stay separate from the 
metadata while easily matching the two.* 

The scripts included in this directory are a version I wrote sometime in the 
range of day 23 to day 26, month 9, year 2021. Hopefully these scripts are less
"hacky" than the previous version (with the exception of how input is taken ; 
see the "TODOs for Developers" section). There are rough edges, making it less
robust than I would like (for instance, to pathologically named files). 

I might include the older version of the script(s) here later for the sake
of completeness, comparison, and choice.

Footnotes:

* This sentence may be a bit silly, since it more-or-less seems like I'm 
arguing for why this "bug" is a feature - like arguing that model-T cars were
better, since they were slower and thus potentially had less serious accidents 
in some cases.

^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^


V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V~V
TODOs for Developers
===============================================================================

Make the script more robust to filenames with characters that could potentially
be interpreted by bash as something other than a literal part of the name. For
example, handling a file created with the following:
    touch "example\" ther - *\'"

Make the user interface more robust and user-friendly. For example, see the 
pointers at: 
https://web.archive.org/web/20210928003035/https://opensource.com/article/19/12/help-bash-program


^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^

