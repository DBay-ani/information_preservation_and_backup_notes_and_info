#!/bin/bash

#Copyright © 2021 David Bayani
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


# NOTE: this file has some issue properly handle some strange names, for example, the file created with the 
# following:
#     touch "example\" ther - *\'"

addNames=${2:-"addName"};


if [[ $addNames != "addName" && $addNames != "--no-name" ]];
then
    echo "Unrecognized second argument."; exit 1 ;  
fi;

# If processing a directory, the area that would print the sha512sum hash instead prints "Not_Applicable"
echo -n $( ( sha512sum  "$1" 2> /dev/null || echo "Not_Applicable") | awk -F" " '{print $1}')","$( TZ=utc stat --format="%F,%b,%B,%s,%w,%W,%x,%X,%y,%Y,%z,%Z" "$1" );

# By putting the file name at the end, we know where the file starts and end, even if the name contains
# commas, since the material before it had a fix number of fields.
if [ $addNames = "--no-name" ]; 
then
    echo "";
elif [ $addNames = "addName" ]; 
then
    echo ,"$1";
else 
    echo "Unrecognized second argument."; exit 1 ;  
fi;
