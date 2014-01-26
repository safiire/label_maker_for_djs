
h1.Label Maker for DJs

This Ruby script allows you to quickly create HTML CD inserts that you can put into your CD Book.

h2.Requirements

* Ruby 
* A specific directory and filename structure


h2.Filename structure

Directory: Name of Album
 * 01 - 04 130 "Artist" - "Title".wav
 * 02 - 05 132 "Artist" - "Title".wav
 * 03 - 06 134 "Artist" - "Title".wav

The filename structure is {Track Number} - {Camalot Key Number} {BPM} "{Artist Name}" - "{Track Name}".ext

h2. Installation

Install this repository in the same directory as your albums, running it wil automatically produce a label.html file in each album directory, which you can open in your browser and print.
Make sure you have "Print Background colors and Images" enabled during printing, and the tracks will be color coded as they are on the camalot key wheel.

You can also run the script and give it a list of album directories on the commandline to process.
