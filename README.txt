'main.scd' plays all the songs and is where most of the information is
^^^ most important file



'song_corpus.txt' is a file, where I stored midi note information and chord information for each of the 8 songs from Pokemon Red and Blue. Symbols are discussed in 'main.scd'.



'learning.py' is the HMM learning algorithm I used to generate
samples. I had to import hmmlearn from
"https://github.com/hmmlearn/hmmlearn".
^^^ 'learning.py' is the other important file (other files are ancillary, or were used
as inputs for this program)

How 'learning.py' works:
In the command line, you can input a text file containing the series
of observation sequences, organized by index number(one of the
'indexed.txt' in Observed Sequences).
You also have the option of inputting an additional command line
argument of the text file corresponding to the mapped sequences of
each index (one of the 'decoded.txt' in Observed Sequences). This
argument is OPTIONAL. If you do put it, 'learning.py' will be able to
tell you the sequences of 4 notes that correspond to each hidden
state.

'learning.py' prints out:
(1) The most probable hidden states for the songs that you put in (using Viterbi algorithm)
(2) The probability transition matrix between each of the hidden states (using Baum-Welch algorithm)
(3) The initial distribution vector across each of the hidden states
(4) **A generated sample of observed sequences from the HMM** (This is what we can use to generate new tunes)
(5) The hidden states corresponding to the generated observed sequences in (4)
OPTIONAL (6) A tally of each of the observed states corresponding to
the hidden states according to the prediction made with the Viterbi
algorithm in (1) (**only happens if you put in the 'decoded.txt'
argument**)



'Example learning output.txt' is an example of the printed output after running 'learning.py'.



Song Array folder:
contains 2 text files: 'eighth_notes.txt' and 'sixteenth_notes.txt'

'eighth_notes.txt' is a massive array containing all note sequences
(as 1/8 notes) for all songs. Used as argument for 'formater.py'

'sixteenth_notes.txt' is a massive array containing all note sequences
(as 1/16 notes) for all songs. Used as argument for 'formater.py'



Python Formatting Programs folder:
containing 2 programs: 'formater.py' and 'sixteenth_converter.py'

'formater.py' takes one of the .txt files from the Song Arrays folders
as an input, and it prints two lists. The first list can be copied and
pasted into the 'indexed.txt' file, and the second list can be copied
and pasted into the 'decoded.txt' file.

'sixteenth_converter.py' takes a song corpus (i.e. 'song_corpus.txt')
and converts the information within from a series of 4 eighth note
sequences to a series of 4 sixteenth note sequences. It prints this
out as a list, which I then copied into 'main.scd'.



Observed Sequences folder:
contains 2 folders: 1/8 Notes and 1/16 Notes (has essentially the same
material, but the song information is represented differently
(sequences of 1/8 notes in the former and 1/16 notes in the latter))

Each folder contains 2 .txt files: 'decoded.txt' and 'indexed.txt'

'indexed.txt' is a necessary command line argument in running 'learning.py'

'decoded.txt' is an optional (2nd command line) argument in running 'learning.py'
