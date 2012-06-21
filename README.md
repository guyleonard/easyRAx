easyRAx
=======

The script aims to make execution of RAxML a little easier by use of simple command-line menus and some user input.

http://gna-phylo.nhm.ac.uk/


easyRAx | Version 1.3.2
=======================

NB - This version is for use with RAxML v7.1.0 and above ONLY. It will not work with v7.0.4, if you need a legacy version then you can visit my website but you should really update RAxML.

This is a small wrapper script for the program RAxML. RAxML is a program for sequential and parallel Maximum Likelihood based inference of large phylogenetic trees. RAxML is available from http://icwww.epfl.ch/~stamatak/index-Dateien/Page443.htm

The script aims to make execution of RAxML a little easier by use of simple command-line menus and some user input.

The script relies on a few assumptions, these are:

    * You are running linux, the tool was developed under Ubuntu. Sorry no Windows or Mac† at this time,
    * The programming language PERL is installed,
    * RAxML** is compiled and copied to the /usr/bin/ directory or a similar all environment path,
    * You run the easyRAx script from the easyRAx folder,
    * Your sequence files are within a folder under the easyRAx folder,
    * You don't wish to compute anything more complicated than with the options available to the 'Fast & Easy' or 'Hard & Slow' methods described in the RAxML manual.

To run the script, simply navigate to the easyRAx folder in your Terminal window and run perl easyRAx.pl.

* Some code has been adapted from perl-scripts available on the old RAxML homepage with permission and some new code has been adapted from user suggestions and fixes and they have been credited in the version log.

** Please make sure that if you have a multi-core machine you compile the RAxML-PTHREADS version as well as the normal version and place them both in the /usr/bin/ folder. This also goes for the SSE3 versions.

† A recent test showed that easyRAx does indeed run on a Mac. It was tested with OSX 10.4.1 but should, in theory, run on all newer versions of Mac OSX. NB - The "Guide to install RAxML on MACs" was used and may need to be followed for easyRAx.

Bug Fixes
=========
## Updates, * Change/Fix, + Addition, - Deletion
# * 2010-04-07 - Fixed Obtain confidence value change from new RAXML version / Minor bugfixes, negligible...
# * Please look at the changelog in the code...
# * 2009-03-25 - Fix for CPU prediction by Antonio Fernàndez-Guerra
# * 2009-03-25 - Fix for "Incorrect Menu Choice error" by Karl Nordström
# + 2008-07-15 - Switch to swap manually between pthreads and standard version.
# * 2008-06-26 - Moved bootstrap # selection to before BKL tree option - allows for automated analyses.
# * 2008-06-26 - Fixed bad comparison to get file/directory - caused problems selecting file/dir #0... 
# * 2008-05-19 - Split "hard way" into three steps...
# + 2008-05-19 - Added prediction of multi-core machines to use PTHREADS version
# + 2008-05-16 - INCLUDES the "HARD WAY"!!!! :)

Notes
=====
Some users have experienced an error menu when they try to select a folder in the range 2 to 9, to resolve this issue, for now, make sure you prepend a 0 infront of these numbers - i.e 05 instead of 5 .

License
=======
This work is licenced under the Creative Commons Attribution-Non-Commercial-Share Alike 3.0 Unported License. To view a copy of this licence, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.