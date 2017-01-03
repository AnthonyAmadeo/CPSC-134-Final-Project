// Anthony Amadeo
// Final Project
// CPSC 134
// December 15, 2016


// Note: Run all blocks of code in order, and read the comments to understand what's going on

// Gameboy-esque synth
(
SynthDef(\pulse, {|freq = 440, sustain = 1, amp = 1, width = 0.5|
	var sig;
	sig = Pulse.ar(freq, width, amp);
	sig = FreeVerb.ar(sig,0.01,0.4);
	sig = sig * EnvGen.kr(Env.perc(0.015, sustain), doneAction: 2); //added an envelope
	Out.ar([0,1], sig ! 2); //outputs signal to stereo
}).add;
)

// General Settings
(
~key = 60;
~speed = 1;
~save = true;
)


// PART 1: Melody Replication and Harmony Generator

/*
Melody Repository: Contains melodies for 8 different Pokemon Red and Blue songs.

Structure: Array of subarrays, where each subarray represents a sequence of 4 eighth notes, and the main array corresponds to the song

Symbols: Each note is represented by its midi value (where 0 is the major tonic). '-' corresponds to a sustained note, and '~' corresponds to a rest
*/
(
~pallet = [[7,5,4,2],[12,9,11,9],[7,'-','-',4],[0,0,2,4],[5,'-','-','-'],['-',-1,0,2],[4,'-','-','-'],[2,'-','-','-'],[7,5,4,7],[12,11,11,12],[9,'-','-',7],[7,'-','-','-'],[5,4,2,0],[7,5,4,2],[0,'-','-','-'],['~',0,2,4],[5,'-','-','-'],[7,'-','-',5],[4,'-','-','-'],['~',0,2,4],[5,'-',5,'-'],[7,'-','-',5],[4,'-','-','-'],['~',4,2,0],[2,'-','-','-'],[-3,'-',4,'-'],[2,'-','-','-'],[0,'-',-3,'-'],[-1,'-','-','-'],[0,'-',4,'-'],[4,'-','-','-'],[2,'-','-','-']];

~route1 = [[4,'-',4,'-'],[4,'-',0,2],[4,'-',4,'-'],[4,'-',0,2],[4,'-',4,'-'],[5,'-','~',4],[2,'-','-','-'],['~','~',-1,0],[2,'-',2,'-'],[2,'-',-1,0],[2,'-',2,'-'],[2,'-',-1,0],[2,'-',2,'-'],[4,2,2,4],[0,'~','~','~'],[4,'~',0,2],[4,'-',4,'-'],[4,'-',0,2],[4,'-',4,'-'],[4,'-',0,2],[4,'-',4,'-'],[5,'-','~',4],[2,'-','-','-'],['~','~',-1,0],[2,'-',5,'-'],[4,'-',2,'-'],[0,'-',-1,'-'],[-3,'-',-1,'-'],[9,'-','-','-'],[-1,'-',-3,-1],[0,'-','-','-'],['~','~',4,5],[7,'-',7,'-'],[4,'-',0,'-'],[12,'-',11,'-'],[9,'-',11,'-'],[7,'-',4,'-'],[0,'-','~',4],[2,'-','~','~'],['~','~',4,5],[7,'-',7,'-'],[4,'-',7,'-'],[12,'-',11,'-'],[9,'-','~',5],[7,'-',12,'-'],[11,'-',14,'-'],[12,'-','-','-'],['~','~','~','~']];

~viridian = [[7,'-',5,'-'],[4,'-','-','-'],['~',4,5,7],['-',7,5,4],[5,2,'-','-'],['-','-','-','-'],['~','~','~','~'],['~','~','~','~'],[5,'-',4,'-'],[2,'-','-','-'],['~',2,4,5],['~',5,4,2],[4,0,'-','-'],['-','-','-','-'],['~','~','~','~'],['~','~','~','~'],[7,'-',5,'-'],[4,'-','-','-'],['~',4,5,7],['-',7,5,4],[5,2,'-','-'],['-','-','-','-'],['~','~','~','~'],['~','~','~','~'],[5,'-',4,'-'],[2,'-','-','-'],['~',2,4,5],['~',5,4,2],[4,0,'-','-'],['-','-','-','-'],['~','~','~','~'],['~','~','~','~'],[9,'-','-','-'],['-','-',5,'-'],[12,'-','-','-'],[14,12,11,9],[7,'-','-','-'],['-','-',4,'-'],[7,'-','-','-'],['-','-','~','~'],[2,'-','-','-'],['-','-',4,5],[7,'-',5,'-'],[4,'-',2,'-'],[4,'-','-','-'],['-','-',0,'-'],[7,'-','-','-'],['-','-','-','-'],[9,'-','-','-'],['-','-',11,12],[14,'-',12,'-'],[11,'-',9,'-'],[7,'-','-','-'],['-','-',9,11],[9,'-',7,'-'],[5,'-',4,'-'],[5,'-','-','-'],['-','-',7,8],['-','-',7,'-'],[5,'-',2,'-'],[5,'-','-','-'],[8,'-','-','-'],[7,'-','-','-'],['-','-','-','-']];

~pkmncenter = [[0,-5,0,7],['-',5,'-',4],[2,-1,'-','-'],[-5,'-',-10,'-'],[-1,-5,-1,4],['-',2,'-',-1],[0,4,'-','-'],[-5,'-',-10,'-'],[0,-5,0,7],['-',5,'-',4],[2,-1,'-','-'],[-5,'-',-10,'-'],[-1,-5,-1,4],['-',2,'-',-1],[0,'-','-','-'],[-12,'-',-10,'-'],[4,'-','-','-'],[7,'-','-','-'],[5,7,5,4],[2,'-','-','-'],[-1,'-','-','-'],[2,'-','-','-'],[4,5,4,2],[0,'-','-','-'],[4,'-','-','-'],[7,'-','-','-'],[5,4,5,7],[9,'-','-','-'],[7,'-',5,4],[5,'-','-','-'],[4,5,4,2],[0,'-','-','-']];

~route3 = [[0,'-','-','-'],[4,'-','-','-'],['~',-5,0,7],[5,4,2,0],[2,'-','-','-'],[5,'-','-','-'],[-2,'-','-','-'],[-3,'-','-','-'],[0,'-','-','-'],[4,'-','-','-'],['~',-5,0,7],[5,4,2,0],[2,'-','-','-'],[5,'-','-','-'],[-2,'-','-','-'],[2,'-','-','-'],[4,2,4,0],['-','-',-1,0],[2,-5,'-',7],['-','-',5,4],[5,4,'-',0],['-','-','-','-'],[-3,'-','-','-'],[-1,'-','-','-']];

~gym = [[0,'-','-','-'],['-','-',-5,0],[2,'-',-2,'-'],['-','-','-','-'],[0,'-','-','-'],['-','-',-5,0],[-2,0,2,'-'],['-','-','-','-'],[4,'-','-','-'],['-','-',2,4],[5,'-',2,'-'],[10,'-',5,'-'],[4,'-','-','-'],['-','-',2,4],[5,2,10,'-'],['-','-',9,'-'],[7,'-','-',12],['-','-',7,'-'],[10,'-',9,'-'],[7,'-',5,'-'],[4,5,7,'-'],['-','-',12,7],[10,'-',9,'-'],[7,'-',5,'-'],[7,'-','-',12],['-','-',7,'-'],[10,'-',9,'-'],[7,'-',5,'-'],[4,5,7,'-'],[7,9,10,'-'],[12,14,16,'-'],['-','-','-','-']];

~bicycle = [[4,'-',5,'-'],[7,'-',12,'-'],[11,'-','-','-'],[9,'-','-','-'],['~',5,7,9],[14,12,11,9],[12,'-','-',9],[7,'-',10,'-'],['~',12,11,12],[9,'-','-','-'],['~',12,11,12],[7,'-','-','-'],['~',12,'-',16],[14,12,11,12],[14,'-','-','-'],['-','-','-',12],[11,'-','-','-'],['-','-','-','-'],[5,'-','-',5],[7,5,4,2],[4,'-','-',4],[5,4,2,0],[5,4,2,5],[7,9,'-',5],[4,7,'-',5],[4,'-','-','-'],[12,11,9,12],[11,'-',9,'-'],[7,10,'-',9],[7,'-',5,4],[9,'-',7,5],[11,'-',9,7],[12,'-',11,9],[14,16,'-',12],[14,'-','-','-'],['-','-',12,'-'],[11,'-','-','-'],['-','-','-','-']];

~celadon = [[4,'-',0,'-'],[4,0,'-','-'],[4,'-',5,4],[2,'-','-','-'],[2,'-',-1,'-'],[2,-1,'-','-'],[2,'-',4,2],[0,'-','-','-'],[4,'-',0,'-'],[4,0,'-','-'],[4,'-',5,4],[2,'-','-','-'],[2,0,-1,0],[-1,-3,-5,-6],[-5,'-','-','-'],[7,'-','-','-'],[7,'-','-','-'],[5,4,2,4],[9,'-',11,'-'],[7,'-','-','-'],[5,'-','-','-'],[2,4,5,7],[9,'-',7,9],[7,'-','-','-'],[7,'-','-','-'],[5,4,2,4],[9,'-',7,9],[7,'-','-','-'],[5,'-','-','-'],[14,12,11,9],[11,9,7,9],[7,'-','-','-']];
)


// Format Conversion: Take the arrays above and convert them into usable pitch and duration arrays
(
~unzip = {|argv, type| // Unzipping function: takes an array from above and outputs either the note array, the duration array, or an amplitude array
	var counter = 0, notes = List[], durations = List[], amps = List[], array = List[];
	argv.size.do{arg i; argv[i].size.do{arg j; array.add(argv[i][j])}};
	array = array + ~key;
	array.size.do{arg i;
		if(array[i - counter] == '~',
			{amps.add(0); array[i - counter] = '0'},
			{amps.add(1)});
		if(array[i - counter] != '-',
			{notes.add(array[i - counter]); durations.add(0.25)},
			{array.removeAt(i - counter);
				counter = counter + 1;
				durations[i - counter] = durations[i - counter] + 0.25;
		});
	};
	case
	{type == \notes} {notes}
	{type == \durations} {durations}
	{type == \amps} {amps}
};


// Pallet Town
~pallet_notes = ~unzip.value(~pallet, \notes);
~pallet_dur = ~unzip.value(~pallet, \durations);
~pallet_ampl = ~unzip.value(~pallet, \amps);


// Route 1
~route1_notes = ~unzip.value(~route1, \notes);
~route1_dur = ~unzip.value(~route1, \durations);
~route1_ampl = ~unzip.value(~route1, \amps);


// Viridian City
~viridian_notes = ~unzip.value(~viridian, \notes);
~viridian_dur = ~unzip.value(~viridian, \durations);
~viridian_ampl = ~unzip.value(~viridian, \amps);


// Pokemon Center
~pkmncenter_notes = ~unzip.value(~pkmncenter, \notes);
~pkmncenter_dur = ~unzip.value(~pkmncenter, \durations);
~pkmncenter_ampl = ~unzip.value(~pkmncenter, \amps);


// Route 3
~route3_notes = ~unzip.value(~route3, \notes);
~route3_dur = ~unzip.value(~route3, \durations);
~route3_ampl = ~unzip.value(~route3, \amps);


// Gym
~gym_notes = ~unzip.value(~gym, \notes);
~gym_dur = ~unzip.value(~gym, \durations);
~gym_ampl = ~unzip.value(~gym, \amps);


// Bicycle
~bicycle_notes = ~unzip.value(~bicycle, \notes);
~bicycle_dur = ~unzip.value(~bicycle, \durations);
~bicycle_ampl = ~unzip.value(~bicycle, \amps);


// Celadon City
~celadon_notes = ~unzip.value(~celadon, \notes);
~celadon_dur = ~unzip.value(~celadon, \durations);
~celadon_ampl = ~unzip.value(~celadon, \amps);
)


// Play some example melodies
(
// Pokemon Center Theme: https://www.youtube.com/watch?v=MjZIjHu0OfY
Pbind(
	\instrument, \pulse,
	\freq, Pseq(~pkmncenter_notes.midicps,1),
	\dur, Pseq(~pkmncenter_dur/~speed,1)).play;
)

(
// Route 3 Theme: https://www.youtube.com/watch?v=llhmkq-vsc0
Pbind(
	\instrument, \pulse,
	\freq, Pseq(~route3_notes.midicps,1),
	\dur, Pseq(~route3_dur/~speed,1)).play;
)

(
// Gym Theme: https://www.youtube.com/watch?v=biLeC5D4S48
Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gym_notes.midicps,1),
	\dur, Pseq(~gym_dur/~speed,1)).play;
)

(
// Viridian City Theme: https://www.youtube.com/watch?v=xVoWwE-7Gec
Pbind(
	\instrument, \pulse,
	\freq, Pseq(~viridian_notes.midicps,1),
	\dur, Pseq(~viridian_dur/~speed,1)).play;
)


// Harmony Dictionary: Contains an array of notes corresponding the 16 chords I identified in the songs
// I fleshed out each of the chords to incoporate notes from the octaves below and above the main one
(
// Tonic Chord
~t = [0,4,7]; // Start with skeleton and add some notes from higher and lower octaves, and rest note
~t = ~t ++ ([~t[~t.size-1], ~t[~t.size-2]] - 12) ++ ([~t[0], ~t[1]] + 12) ++ '~';

// Subdominant Chord
~s =[0,5,9];
~s = ~s ++ ([~s[~s.size-1], ~s[~s.size-2]] - 12) ++ ([~s[0], ~s[1]] + 12) ++ '~';

//Dominant Chord
~d = [2,7,11];
~d = ~d ++ ([~d[~d.size-1], ~d[~d.size-2]] - 12) ++ ([~d[0], ~d[1]] + 12) ++ '~';

// Tonic minor
~tm = [0,4,9];
~tm = ~tm ++ ([~tm[~tm.size-1], ~tm[~tm.size-2]] - 12) ++ ([~tm[0], ~tm[1]] + 12) ++ '~';

// Subdominant minor
~sm = [2,5,9];
~sm = ~sm ++ ([~sm[~sm.size-1], ~sm[~sm.size-2]] - 12) ++ ([~sm[0], ~sm[1]] + 12) ++ '~';

// Dominant minor
~dm = [4,7,11];
~dm = ~dm ++ ([~dm[~dm.size-1], ~dm[~dm.size-2]] - 12) ++ ([~dm[0], ~dm[1]] + 12) ++ '~';

//Dominant 7
~d7 =[2,5,7,11];
~d7 = ~d7 ++ ([~d7[~d7.size-1], ~d7[~d7.size-2]] - 12) ++ ([~d7[0], ~d7[1]] + 12) ++ '~';

// I don't know the name for this chord, but it's diminished and starts on midi note 2
~ch_2dim = [2,5,8];
~ch_2dim = ~ch_2dim ++ ([~ch_2dim[~ch_2dim.size-1], ~ch_2dim[~ch_2dim.size-2]] - 12) ++ ([~ch_2dim[0], ~ch_2dim[1]] + 12) ++ '~';

// Diminished chord starting on midi note 9
~ch_9dim = [-3,0,3];
~ch_9dim = ~ch_9dim ++ ([~ch_9dim[~ch_9dim.size-1], ~ch_9dim[~ch_9dim.size-2]] - 12) ++ ([~ch_9dim[0], ~ch_9dim[1]] + 12) ++ '~';

// Diminished 7th chord starting on midi note 9
~ch_9dim7 = [-3,0,3,6];
~ch_9dim7 = ~ch_9dim7 ++ ([~ch_9dim7[~ch_9dim7.size-1], ~ch_9dim7[~ch_9dim7.size-2]] - 12) ++ ([~ch_9dim7[0], ~ch_9dim7[1]] + 12) ++ '~';

// Augmented chord starting on midi note 11
~ch_11aug = [-1,3,7];
~ch_11aug = ~ch_11aug ++ ([~ch_11aug[~ch_11aug.size-1], ~ch_11aug[~ch_11aug.size-2]] - 12) ++ ([~ch_11aug[0], ~ch_11aug[1]] + 12) ++ '~';

// Major chord 2 semitones below tonic chord
~ch_10 =[-2,2,5];
~ch_10 = ~ch_10 ++ ([~ch_10[~ch_10.size-1], ~ch_10[~ch_10.size-2]] - 12) ++ ([~ch_10[0], ~ch_10[1]] + 12) ++ '~';

// Tonic 7th chord
~t7 =[0,4,7,10];
~t7 = ~t7 ++ ([~t7[~t7.size-1], ~t7[~t7.size-2]] - 12) ++ ([~t7[0], ~t7[1]] + 12) ++ '~';

// Diminished chord starting on midi note 4
~ch_4dim = [4,7,10];
~ch_4dim = ~ch_4dim ++ ([~ch_4dim[~ch_4dim.size-1], ~ch_4dim[~ch_4dim.size-2]] - 12) ++ ([~ch_4dim[0], ~ch_4dim[1]] + 12) ++ '~';

// Major chord 2 semitones above tonic chord
~ch_2 = [2,6,9];
~ch_2 = ~ch_2 ++ ([~ch_2[~ch_2.size-1], ~ch_2[~ch_2.size-2]] - 12) ++ ([~ch_2[0], ~ch_2[1]] + 12) ++ '~';

// Dominant sus4 chord
~dsus4 = [-5,0,2];
~dsus4 = ~dsus4 ++ ([~dsus4[~dsus4.size-1], ~dsus4[~dsus4.size-2]] - 12) ++ ([~dsus4[0], ~dsus4[1]] + 12) ++ '~';
)


// Harmony Repository: Contains arrays of chords underlying the sequences of 4 eighth notes
(
~pallet_h = [~t,~s,~dm,~tm,~s,~d,~t,~d,~t,~s,~tm,~dm,~s,~d,~d7,~t,~s,~d,~t,~tm,~s,~d,~t,~t,~sm,~sm,~sm,~sm,~d7,~d7,~s,~d7];

~route1_h = [~t,~t,~t,~t,~t,~t,~d,~d,~d,~d,~d,~d,~d,~d,~t,~t,~t,~t,~t,~t,~t,~t,~d,~d,~d,~d,~d,~d,~d,~d7,~t,~t,~t,~t,~s,~s,~t,~t,~d7,~d7,~t,~t,~s,~s,~d7,~d7,~t,~t];

~viridian_h = [~t,~t,~t,~t,~d7,~d7,~d7,~d7,~d7,~d7,~d7,~d7,~t,~t,~t,~t,~t,~t,~t,~t,~d7,~d7,~d7,~d7,~d7,~d7,~d7,~d7,~t,~t,~t,~t,~s,~s,~s,~s,~t,~t,~t,~t,~d7,~d7,~d7,~d7,~t,~t,~t,~t,~s,~s,~s,~s,~t,~t,~tm,~tm,~d7,~d7,~ch_2dim,~ch_2dim,~ch_2dim,~ch_2dim,~t,~t];

~pkmncenter_h = [~t,~t,~d7,~d7,~d7,~d7,~t,~t,~t,~t,~d7,~d7,~d7,~d7,~t,~t,~t,~t,~sm,~sm,~d7,~d7,~t,~t,~t,~t,~sm,~sm,~d7,~d7,~t,~t];

~route3_h = [~t,~t,~t,~t,~ch_10,~ch_10,~ch_10,~ch_10,~t,~t,~t,~t,~ch_10,~ch_10,~ch_10,~ch_10,~t,~t,~d,~d,~s,~s,~s,~d];

~gym_h = [~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~ch_10,~ch_10,~t,~t,~t,~t];

~bicycle_h = [~t,~t,~s,~s,~sm,~d7,~t,~t7,~s,~s,~t,~t,~s,~ch_2,~d,~d,~d,~d,~s,~s,~t,~t,~s,~d,~t,~t7,~s,~s,~ch_4dim,~ch_4dim,~sm,~dm,~s,~ch_2,~dsus4,~dsus4,~d,~d7];

~celadon_h = [~t,~t,~t,~d,~d,~d,~d,~t,~t,~t,~t,~d,~d,~d,~d,~d,~t,~t,~t,~t,~d,~d,~d,~d,~t,~t,~t,~t,~d,~d,~d,~d];
)


// Harmonizing the Melody: Function that will play the main melody with notes from the underlying chords
(
~rand_harmony = {|chord_array| // Comes up with a random sequence of notes based off the chords
	var out_sequence;          // the song is playing in at the time
	out_sequence = List[];
	chord_array.do{arg arr;
		4.do{arg i; out_sequence.add(arr[arr.size.rand])};

	};
	out_sequence;
};

// Plays both the melody and the randomly generated harmony notes
// *There is an option to save the generatd harmony, but I didn't have time to develop this
~harmonize = { |note_array, dur_array, chord_array, save = false|
	var harmony;
	harmony = ~rand_harmony.value(chord_array);
	if (save == true,
		{harmony.postln;};
	);
	//Plays the main melody
	Pbind(
		\instrument, \pulse,
		\freq, Pseq(note_array.midicps,1),
		\dur, Pseq(dur_array/~speed,1)).play;
	// Plays the harmony
	Pbind(
		\instrument, \pulse,
		\width, 0.6,
		\freq, Pseq((~key - 12 + harmony).midicps,1),
		\amp, 0.07,
		\dur, Pseq(0.25 ! (4*chord_array.size)/~speed,1)).play;
};
)

// Some examples:
(
// Route 3 Theme: https://www.youtube.com/watch?v=llhmkq-vsc0
~harmonize.value(~route3_notes, ~route3_dur, ~route3_h, ~save);
)

(
// Gym Theme: https://www.youtube.com/watch?v=biLeC5D4S48
~harmonize.value(~gym_notes, ~gym_dur, ~gym_h, ~save);
)

(
// Celadon City: https://www.youtube.com/watch?v=iMyDrhNf2t0
~harmonize.value(~celadon_notes, ~celadon_dur, ~celadon_h, ~save);
)

(
// Bicycle Theme: https://www.youtube.com/watch?v=nxU2UjAjN24
~harmonize.value(~bicycle_notes, ~bicycle_dur, ~bicycle_h, ~save);
)

(
// Pallet Town Theme: https://www.youtube.com/watch?v=cOWRNLaCMJg
~harmonize.value(~pallet_notes, ~pallet_dur, ~pallet_h, ~save);
)

(
// Pokemon Center Theme: https://www.youtube.com/watch?v=MjZIjHu0OfY
~harmonize.value(~pkmncenter_notes, ~pkmncenter_dur, ~pkmncenter_h, ~save);
)

(
// Viridian City Theme: https://www.youtube.com/watch?v=xVoWwE-7Gec
~harmonize.value(~viridian_notes, ~viridian_dur, ~viridian_h, ~save);
)


// PART 2: Hidden Markov Generations

// Using SCMIR's HMM Algorithm:
(
h = HMM(16, 140); // Train an HMM with 16 hidden states (chords) and 140 observable sequences


// Data is an array of subarrays, where each subarray corresponds to a song. Each of the integers in the subarray map to one of the 140 distinct sets of 4 eighth notes from the note repository above

/* I used formater.py, which takes in a massive array of all the midi notes for all the songs in the command line, and first prints out ~data, the array that assigns an integer to each sequence of 4 eighth notes in the song, and then prints out ~mapped_data, the array of the sequence of 4 eighth notes arranged in order of index according to ~data.

For example, Pallet town, the first song, is represented in ~data by the first subarray, [106, 53, ..., 45]. Each of these integers is an index in ~mapped_data. So the first 4 eighth notes in Pallet Town are ~mapped_data[106], which is [ 7, 5, 4, 2 ], and the last 4 eighth notes are ~mapped_data[45], which is [ 2, -, -, - ].
*/

~data = [[106, 53, 23, 0, 59, 131, 117, 45, 43, 58, 97, 123, 52, 106, 7, 130, 59, 118, 117, 130, 65, 118, 117, 24, 45, 4, 45, 81, 31, 61, 117, 45], [2, 116, 2, 116, 2, 95, 45, 29, 62, 93, 62, 93, 62, 39, 11, 94, 2, 116, 2, 116, 2, 95, 45, 29, 91, 15, 46, 14, 66, 42, 7, 109, 119, 87, 114, 13, 37, 112, 60, 109, 119, 101, 114, 50, 85, 111, 89, 76], [77, 117, 51, 128, 86, 102, 76, 76, 26, 45, 135, 134, 6, 102, 76, 76, 77, 117, 51, 128, 86, 102, 76, 76, 26, 45, 135, 134, 6, 102, 76, 76, 66, 64, 89, 83, 123, 21, 123, 88, 45, 103, 77, 15, 117, 68, 123, 102, 66, 22, 27, 74, 123, 55, 17, 26, 59, 16, 120, 137, 59, 82, 123, 102], [105, 80, 30, 48, 133, 92, 34, 48, 105, 80, 30, 48, 133, 92, 7, 124, 117, 123, 47, 45, 31, 45, 122, 7, 117, 123, 8, 66, 9, 59, 122, 7], [7, 117, 104, 52, 45, 59, 32, 70, 7, 117, 104, 52, 45, 59, 32, 45, 5, 36, 35, 69, 20, 102, 70, 31], [7, 33, 75, 102, 7, 33, 63, 102, 117, 49, 137, 84, 117, 49, 121, 67, 98, 120, 41, 77, 40, 25, 41, 77, 98, 120, 41, 77, 40, 99, 100, 102], [71, 85, 72, 66, 127, 83, 125, 1, 18, 66, 18, 123, 113, 139, 107, 138, 72, 102, 38, 106, 129, 52, 108, 110, 132, 117, 115, 74, 10, 9, 3, 96, 126, 28, 107, 56, 72, 102], [87, 6, 90, 45, 136, 30, 73, 7, 87, 6, 90, 45, 79, 57, 44, 123, 123, 54, 13, 123, 59, 19, 78, 123, 123, 54, 78, 123, 59, 83, 12, 123]];

h.train(~data,10); // Train the HMM based off the observed sequences from the repository


// This is the array of the 4 eighth note sequences that each index in ~data maps to
~mapped_data = [[0, 0, 2, 4], [7, '-', 10, '-'], [4, '-', 4, '-'], [9, '-', 7, 5], [-3, '-', 4, '-'], [4, 2, 4, 0], [4, 0, '-', '-'], [0, '-', '-', '-'], [5, 4, 5, 7], [7, '-', 5, 4], [7, 10, '-', 9], [0, '~', '~', '~'], [11, 9, 7, 9], [9, '-', 11, '-'], [-3, '-', -1, '-'], [4, '-', 2, '-'], ['-', '-', 7, 8], [9, '-', 7, '-'], ['~', 12, 11, 12], [2, 4, 5, 7], [5, 4, '-', 0], ['-', '-', 4, '-'], ['-', '-', 11, 12], [7, '-', '-', 4], ['~', 4, 2, 0], ['-', '-', 12, 7], [5, '-', 4, '-'], [14, '-', 12, '-'], [14, 16, '-', 12], ['~', '~', -1, 0], [2, -1, '-', '-'], [-1, '-', '-', '-'], [-2, '-', '-', '-'], ['-', '-', -5, 0], [0, 4, '-', '-'], [2, -5, '-', 7], ['-', '-', -1, 0], [7, '-', 4, '-'], [5, '-', '-', 5], [4, 2, 2, 4], [4, 5, 7, '-'], [10, '-', 9, '-'], [-1, '-', -3, -1], [7, 5, 4, 7], [-5, '-', '-', '-'], [2, '-', '-', '-'], [0, '-', -1, '-'], [5, 7, 5, 4], [-5, '-', -10, '-'], ['-', '-', 2, 4], [9, '-', '~', 5], ['~', 4, 5, 7], [5, 4, 2, 0], [12, 9, 11, 9], [5, 4, 2, 4], ['-', '-', 9, 11], ['-', '-', 12, '-'], [-1, -3, -5, -6], [12, 11, 11, 12], [5, '-', '-', '-'], [2, '-', '~', '~'], [0, '-', 4, '-'], [2, '-', 2, '-'], [-2, 0, 2, '-'], ['-', '-', 5, '-'], [5, '-', 5, '-'], [9, '-', '-', '-'], ['-', '-', 9, '-'], ['-', '-', 0, '-'], ['-', '-', 5, 4], [-3, '-', '-', '-'], [4, '-', 5, '-'], [11, '-', '-', '-'], [2, '-', 4, 2], [11, '-', 9, '-'], [2, '-', -2, '-'], ['~', '~', '~', '~'], [7, '-', 5, '-'], [9, '-', 7, 9], [2, 0, -1, 0], ['-', 5, '-', 4], [0, '-', -3, '-'], [8, '-', '-', '-'], [14, 12, 11, 9], [10, '-', 5, '-'], [7, '-', 12, '-'], [5, 2, '-', '-'], [4, '-', 0, '-'], ['-', '-', '~', '~'], [12, '-', '-', '-'], [4, '-', 5, 4], [2, '-', 5, '-'], ['-', 2, '-', -1], [2, '-', -1, 0], [4, '~', 0, 2], [5, '-', '~', 4], [11, '-', 9, 7], [9, '-', '-', 7], [7, '-', '-', 12], [7, 9, 10, '-'], [12, 14, 16, '-'], [4, '-', 7, '-'], ['-', '-', '-', '-'], ['-', '-', 4, 5], ['~', -5, 0, 7], [0, -5, 0, 7], [7, 5, 4, 2], [14, '-', '-', '-'], [5, 4, 2, 5], ['~', '~', 4, 5], [7, 9, '-', 5], [11, '-', 14, '-'], [0, '-', '~', 4], ['~', 12, '-', 16], [12, '-', 11, '-'], [12, 11, 9, 12], [4, '-', 0, 2], [4, '-', '-', '-'], [7, '-', '-', 5], [7, '-', 7, '-'], ['-', '-', 7, '-'], [5, 2, 10, '-'], [4, 5, 4, 2], [7, '-', '-', '-'], [-12, '-', -10, '-'], [12, '-', '-', 9], [12, '-', 11, 9], ['~', 5, 7, 9], ['-', 7, 5, 4], [4, '-', '-', 4], ['~', 0, 2, 4], ['-', -1, 0, 2], [4, 7, '-', 5], [-1, -5, -1, 4], ['~', 5, 4, 2], ['~', 2, 4, 5], [2, '-', -1, '-'], [5, '-', 2, '-'], ['-', '-', '-', 12], [14, 12, 11, 12]];


// This function takes a series of indexes from ~data and unwraps it according to the corresponding 4 eight note sequence in ~mapped_data
~mapper = {|array|
	var list = List[];
	array.size.do{arg i; list.add(~mapped_data[array[i]])};
	list;
};

// This line samples from the trained Hidden Markov Model and generates a sequence of 16-bar song
~gen = h.generate(32).postln;

~gen_full = List[];
~gen_full = ~mapper.value(~gen);


~gen_notes = ~unzip.value(~gen_full, \notes);
~gen_dur = ~unzip.value(~gen_full, \durations);
~gen_ampl = ~unzip.value(~gen_full, \amps);

~gen_full.postln;

// After we unzip the song, we can play it here
Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen_notes.midicps,1),
	\dur, Pseq(~gen_dur/~speed,1)).play;

// ***Problem is no matter how many times I run it, HMM always generates the same pattern***
)


/* So, instead of relying on SCMIR's HMM class, I created a program in Python that accomplishes the same thing.

The program is called learning.py. In the command line, you can input a text file containing the series of observation sequences, organized by index number (i.e. ~data).

You also have the option of inputting an additional command line argument of the text file corresponding to the mapped sequences of each index (i.e. ~mapped_data). This argument is OPTIONAL. If you do put it, learning.py will be able to tell you the sequences of 4 eighth notes that correspond to each hidden state.

learning.py prints out:
(1) The most probable hidden states for the songs that you put in (using Viterbi algorithm)
(2) The probability transition matrix between each of the hidden states (using Baum-Welch algorithm)
(3) The initial distribution vector across each of the hidden states
(4) **A generated sample of observed sequences from the HMM** (This is what we can use to generate new tunes)
(5) The hidden states corresponding to the generated observed sequences in (4)
OPTIONAL (6) A tally of each of the observed states corresponding to the hidden states according to the prediction made with the Viterbi algorithm in (1) (**only happens if you put in the ~mapped_data text file argument**)

TL;DR: Put in observed sequences and learning.py will run some stuff and output several things, including a generated sample, which you can copy and paste to make tunes
*/

// First Sample
(
~gen1_full = List[];

// Here is the first generated sample I got from learning.py
~gen1 = [7, 98, 130, 41, 2, 53, 45, 59, 117, 102, 76, 76, 116, 2, 20, 38, 87, 40, 130, 41, 7, 117, 49, 52, 59, 30, 66, 139, 83, 11, 52, 105];
~gen1_full = ~mapper.value(~gen1);

~gen1_notes = ~unzip.value(~gen1_full, \notes);
~gen1_dur = ~unzip.value(~gen1_full, \durations);
~gen1_ampl = ~unzip.value(~gen1_full, \amps);

~gen1_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen1_notes.midicps,1),
	\dur, Pseq(~gen1_dur/~speed,1)).play;
)

// Second Sample
(
~gen2_full = List[];
~gen2 = [118, 117, 123, 32, 10, 45, 59, 58, 123, 123, 83, 123, 1, 123, 12, 137, 59, 48, 67, 23, 117, 45, 128, 102, 102, 76, 1, 54, 59, 26, 97, 93];
~gen2_full = ~mapper.value(~gen2);

~gen2_notes = ~unzip.value(~gen2_full, \notes);
~gen2_dur = ~unzip.value(~gen2_full, \durations);
~gen2_ampl = ~unzip.value(~gen2_full, \amps);

~gen2_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen2_notes.midicps,1),
	\dur, Pseq(~gen2_dur/~speed,1)).play;
)

// Third Sample
(
~gen3_full = List[];
~gen3 = [34, 98, 104, 52, 120, 123, 45, 61, 66, 83, 107, 15, 83, 107, 123, 72, 102, 94, 7, 117, 23, 122, 2, 48, 120, 52, 45, 55, 117, 26, 49, 59];
~gen3_full = ~mapper.value(~gen3);

~gen3_notes = ~unzip.value(~gen3_full, \notes);
~gen3_dur = ~unzip.value(~gen3_full, \durations);
~gen3_ampl = ~unzip.value(~gen3_full, \amps);

~gen3_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen3_notes.midicps,1),
	\dur, Pseq(~gen3_dur/~speed,1)).play;
)



// PART 3: Hidden Markov Model with Restructured Data

// Now I'm going to try the same thing but documenting it so that each observed state is a group of 4 16th notes (I used sixteenth_converter.py to accomplish the conversion)

// This should not only make the playbacks of the original song more accurate, but it should also make Markov-generated pieces a little less faithful and more creative
(
~pallet_16 = [[7, '-', 5, '-'], [4, '-', 2, '-'], [12, '-', 9, '-'], [11, '-', 9, '-'], [7, '-', '-', '-'], ['-', '-', 4, '-'], [0, '-', 0, '-'], [2, '-', 4, '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', -1, '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], ['-', '-', 5, 4], [2, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', 5, '-'], [4, '-', 7, '-'], [12, '-', 11, '-'], [11, '-', 12, '-'], [9, '-', '-', '-'], ['-', '-', 7, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', 4, '-'], [2, '-', 0, '-'], [7, '-', 5, '-'], [4, '-', 2, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 0, '-'], [2, '-', 4, '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', 5, '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 0, '-'], [2, '-', 4, '-'], [5, '-', '-', '-'], [5, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', 5, 7], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 4, '-'], [2, '-', 0, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [-3, '-', '-', '-'], [4, '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [0, '-', '-', '-'], [-3, '-', '-', '-'], [-1, '-', '-', '-'], ['-', '-', '-', '-'], [0, '-', '-', '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-']];

~route1_16 = [[4, '-', '-', '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [5, '-', '-', '-'], ['~', '-', 4, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], [-1, '-', 0, '-'], [2, '-', '-', '-'], [2, '-', '-', '-'], [2, '-', '-', '-'], [-1, '-', 0, '-'], [2, '-', '-', '-'], [2, '-', '-', '-'], [2, '-', '-', '-'], [-1, '-', 0, '-'], [2, '-', '-', '-'], [2, '-', '-', '-'], [4, '-', 2, '-'], [2, '-', 4, '-'], [0, '-', '~', '-'], ['~', '-', '~', '-'], [4, '-', '~', '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', 2, '-'], [4, '-', '-', '-'], [4, '-', '-', '-'], [5, '-', '-', '-'], ['~', '-', 4, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], [-1, '-', 0, '-'], [2, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], [2, '-', '-', '-'], [0, '-', '-', '-'], [-1, '-', '-', '-'], [-3, '-', '-', '-'], [-1, '-', '-', '-'], [9, '-', '-', '-'], ['-', '-', '-', '-'], [-1, '-', '-', '-'], [-3, '-', -1, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], [4, '-', 5, '-'], [7, '-', '-', '-'], [7, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], [9, '-', '-', '-'], [11, '-', '-', '-'], [7, '-', '-', '-'], [4, '-', '-', '-'], [0, '-', '-', '-'], ['~', '-', 4, '-'], [2, '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], [4, '-', 5, '-'], [7, '-', '-', '-'], [7, '-', '-', '-'], [4, '-', '-', '-'], [7, '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], [9, '-', '-', '-'], ['~', '-', 5, '-'], [7, '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], [14, '-', '-', '-'], [12, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-']];

~viridian_16 = [[7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 4, '-'], [5, '-', 7, '-'], ['-', '-', 7, '-'], [5, '-', 4, '-'], [5, '-', 2, '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 2, '-'], [4, '-', 5, '-'], ['~', '-', 5, '-'], [4, '-', 2, '-'], [4, '-', 0, '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 4, '-'], [5, '-', 7, '-'], ['-', '-', 7, '-'], [5, '-', 4, '-'], [5, '-', 2, '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 2, '-'], [4, '-', 5, '-'], ['~', '-', 5, '-'], [4, '-', 2, '-'], [4, '-', 0, '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], ['~', '-', '~', '-'], [9, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], [12, '-', '-', '-'], ['-', '-', '-', '-'], [14, '-', 12, '-'], [11, '-', 9, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', '~', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', 5, '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], [2, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [0, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [9, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [11, '-', 12, '-'], [14, '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [9, '-', 11, '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', 8, '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [2, '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [8, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-']];

~pkmncenter_16 = [[0, '-', -5, '-'], [0, '-', 7, '-'], ['-', '-', 5, '-'], ['-', '-', 4, '-'], [2, '-', -1, '-'], ['-', '-', '-', '-'], [-5, '-', '-', '-'], [-10, '-', '-', '-'], [-1, '-', -5, '-'], [-1, '-', 4, '-'], ['-', '-', 2, '-'], ['-', '-', -1, '-'], [0, '-', 4, '-'], ['-', '-', '-', '-'], [-5, '-', '-', '-'], [-10, '-', '-', '-'], [0, '-', -5, '-'], [0, '-', 7, '-'], ['-', '-', 5, '-'], ['-', '-', 4, '-'], [2, '-', -1, '-'], ['-', '-', '-', '-'], [-5, '-', '-', '-'], [-10, '-', '-', '-'], [-1, '-', -5, '-'], [-1, '-', 4, '-'], ['-', '-', 2, '-'], ['-', '-', -1, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], [-12, '-', '-', '-'], [-10, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', 7, '-'], [5, '-', 4, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [-1, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', 5, '-'], [4, '-', 2, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', 4, '-'], [5, '-', 7, '-'], [9, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], [5, '-', 4, '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', 5, '-'], [4, '-', 2, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-']];

~route3_16 = [[0, '-', '-', '-'], ['-', '-', -5, 0], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', -5, '-'], [0, '-', 7, '-'], [5, '-', 4, '-'], [2, '-', 0, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [-2, '-', '-', '-'], ['-', '-', '-', '-'], [-3, '-', '-', '-'], ['-', '-', '-', '-'], [0, '-', '-', '-'], ['-', '-', -5, 0], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', -5, '-'], [0, '-', 7, '-'], [5, '-', 4, '-'], [2, '-', 0, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [-2, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', '-', '-'], ['-', '-', 0, 2], [4, '-', 2, '-'], [4, '-', 0, '-'], ['-', '-', '-', '-'],['-', '-', -1, 0], [2, '-', -5, '-'], ['-', '-', 7, '-'], ['-', '-', '-', '-'], ['-', '-', 5, 4], [5, '-', 4, '-'], [0, '-', 0, '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [-3, '-', '-', '-'], ['-', '-', '-', '-'], [-1, '-', '-', '-'], ['-', '-', '-', '-']];

~gym_16 = [[0, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [-5, '-', 0, '-'], [2, '-', '-', -2], [-2, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [-5, '-', 0, '-'], [-2, '-', -2, 0], [2, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', 4, '-'], [5, '-', '-', 2], [2, '-', '-', '-'], [10, '-', '-', 5], [5, '-', '-', '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', 4, '-'], [5, '-', 2, 5], [10, '-', '-', '-'], ['-', '-', '-', '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', 12, '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], [10, '-', '-', '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', 4, 5], [7, '-', '-', '-'], ['-', '-', 7, '-'], [12, '-', 7, '-'], [10, '-', '-', '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], [4, '-', 5, '-'], [7, '-', '-', '-'], ['-', '-', 12, '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], [10, '-', '-', '-'], [9, '-', '-', '-'], [7, '-', '-', '-'], [5, '-', '-', '-'], [4, '-', 4, 5], [7, '-', '-', '-'], [7, '-', 7, 9], [10, '-', '-', '-'], [12, '-', 12, 14], [16, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-']];

~bicycle_16 = [[4, '-', '-', '-'], [5, '-', '-', '-'], [7, '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], ['-', '-', 9, 11], [9, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 5, '-'], [7, '-', 9, '-'], [14, '-', 12, '-'], [11, '-', 9, 11], [12, '-', '-', '-'], ['-', '-', 9, '-'], [7, '-', '-', '-'], [10, '-', '-', '-'], ['~', '-', 12, '-'], [11, '-', 12, '-'], [9, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 12, '-'], [11, '-', 12, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], ['~', '-', 12, '-'], ['-', '-', 16, '-'], [14, '-', 12, '-'], [11, '-', 11, 12], [14, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', 14, 12], [11, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', 5, '-'], [7, '-', 5, '-'], [4, '-', 2, '-'], [4, '-', '-', '-'], ['-', '-', 4, '-'], [5, '-', 4, '-'], [2, '-', 0, '-'], [5, '-', 4, '-'], [2, '-', 5, '-'], [7, '-', 9, '-'], ['-', '-', 5, '-'], [4, '-', 7, '-'], ['-', '-', 5, '-'], [4, '-', '-', '-'], ['-', '-', '-', '-'], [12, '-', 11, '-'], [9, '-', 12, '-'], [11, '-', '-', '-'], [9, '-', '-', '-'], [7, '-', 10, '-'], ['-', '-', 9, '-'], [7, '-', '-', '-'], [5, '-', 4, '-'], [9, '-', '-', '-'], [7, '-', 5, '-'], [11, '-', '-', '-'], [9, '-', 7, '-'], [12, '-', '-', '-'], [11, '-', 9, '-'], [14, '-', 16, '-'], ['-', '-', 12, '-'], [14, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], [12, '-', '-', '-'], [11, '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-'], ['-', '-', '-', '-']];

~celadon_16 = [[4, '-', '-', '-'], [0, '-', '-', '-'], [4, '-', 0, '-'], ['-', '-', '-', '-'], [4, 0, 2, 4], [5, '-', 4, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', '-', '-'], [-1, '-', '-', '-'], [2, '-', -1, '-'], ['-', '-', '-', '-'], [2, 0, -1, 0], [2, '-', 4, '-'], [0, '-', '-', '-'], ['-', '-', '-', '-'], [4, '-', '-', '-'], [0, '-', '-', '-'], [4, '-', 0, '-'], ['-', '-', '-', '-'], [4, 0, 2, 4], [5, '-', 4, '-'], [2, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', 0, '-'], [-1, '-', 0, '-'], [-1, '-', -3, '-'], [-5, '-', -6, '-'], [-5, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', 4, '-'], [2, '-', 4, '-'], [9, '-', '-', '-'], [11, '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [2, '-', 4, '-'], [5, '-', 7, '-'], [9, '-', '-', '-'], [7, '-', 9, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', 4, '-'], [2, '-', 4, '-'], [9, '-', '-', '-'], [7, '-', 9, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-'], [5, '-', '-', '-'], ['-', '-', '-', '-'], [14, '-', 12, '-'], [11, '-', 9, '-'], [11, '-', 9, '-'], [7, '-', 9, '-'], [7, '-', '-', '-'], ['-', '-', '-', '-']];
)

// Once again, we have to unzip this information
(
// Convenience function to unpack repository information above into usable note and duration arrays
~unzip_16 = {|argv, type|
	var counter = 0, notes = List[], durations = List[], amps = List[], array = List[];
	argv.size.do{arg i; argv[i].size.do{arg j; array.add(argv[i][j])}};
	array = array + ~key;
	array.size.do{arg i;
		if(array[i - counter] == '~',
			{amps.add(0); array[i - counter] = '0'},
			{amps.add(1)});
		if(array[i - counter] != '-',
			{notes.add(array[i - counter]); durations.add(0.125)},
			{array.removeAt(i - counter);
				counter = counter + 1;
				durations[i - counter] = durations[i - counter] + 0.125;
		});
	};
	case
	{type == \notes} {notes}
	{type == \durations} {durations}
	{type == \amps} {amps}
};


// Pallet Town
~pallet_notes_16 = ~unzip_16.value(~pallet_16, \notes);
~pallet_dur_16 = ~unzip_16.value(~pallet_16, \durations);
~pallet_ampl_16 = ~unzip_16.value(~pallet_16, \amps);


// Route 1
~route1_notes_16 = ~unzip_16.value(~route1_16, \notes);
~route1_dur_16 = ~unzip_16.value(~route1_16, \durations);
~route1_ampl_16 = ~unzip_16.value(~route1_16, \amps);


// Viridian City
~viridian_notes_16 = ~unzip_16.value(~viridian_16, \notes);
~viridian_dur_16 = ~unzip_16.value(~viridian_16, \durations);
~viridian_ampl_16 = ~unzip_16.value(~viridian_16, \amps);


// Pokemon Center
~pkmncenter_notes_16 = ~unzip_16.value(~pkmncenter_16, \notes);
~pkmncenter_dur_16 = ~unzip_16.value(~pkmncenter_16, \durations);
~pkmncenter_ampl_16 = ~unzip_16.value(~pkmncenter_16, \amps);


// Route 3
~route3_notes_16 = ~unzip_16.value(~route3_16, \notes);
~route3_dur_16 = ~unzip_16.value(~route3_16, \durations);
~route3_ampl_16 = ~unzip_16.value(~route3_16, \amps);


// Gym
~gym_notes_16 = ~unzip_16.value(~gym_16, \notes);
~gym_dur_16 = ~unzip_16.value(~gym_16, \durations);
~gym_ampl_16 = ~unzip_16.value(~gym_16, \amps);


// Bicycle
~bicycle_notes_16 = ~unzip_16.value(~bicycle_16, \notes);
~bicycle_dur_16 = ~unzip_16.value(~bicycle_16, \durations);
~bicycle_ampl_16 = ~unzip_16.value(~bicycle_16, \amps);


// Celadon City
~celadon_notes_16 = ~unzip_16.value(~celadon_16, \notes);
~celadon_dur_16 = ~unzip_16.value(~celadon_16, \durations);
~celadon_ampl_16 = ~unzip_16.value(~celadon_16, \amps);
)

// Notice the inclusion of 16th notes in these melodies
(
// Route 3 with 16th notes
~harmonize.value(~route3_notes_16, ~route3_dur_16, ~route3_h, ~save);
)

(
// Bicycle Theme with 16th notes
~harmonize.value(~bicycle_notes_16, ~bicycle_dur_16, ~bicycle_h, ~save);
)

(
// Gym Theme with 16th notes
~harmonize.value(~gym_notes_16, ~gym_dur_16, ~gym_h, ~save);
)

(
// Pallet Town with 16th notes
~harmonize.value(~pallet_notes_16, ~pallet_dur_16, ~pallet_h, ~save);
)



// I used formater.py to come up with a new ~data and ~mapped_data array, with respective names ~data_16 and ~mapped_16. The observed sequences this time were the songs arranged by sequences of 4 16th notes. Instead of 140 distinct observed sequences, there are only 93 this time.
(
~data_16 = [[51, 68, 23, 91, 3, 11, 79, 83, 77, 49, 12, 10, 37, 82, 8, 49, 51, 58, 20, 56, 5, 48, 3, 49, 57, 64, 51, 68, 26, 49, 30, 83, 77, 49, 3, 67, 37, 49, 30, 83, 77, 77, 3, 85, 37, 49, 33, 64, 8, 49, 16, 37, 8, 49, 26, 16, 35, 49, 26, 37, 37, 49, 8, 49], [37, 37, 37, 10, 37, 37, 37, 10, 37, 37, 77, 33, 8, 49, 72, 74, 8, 8, 8, 74, 8, 8, 8, 74, 8, 8, 68, 83, 7, 72, 87, 10, 37, 37, 37, 10, 37, 37, 37, 10, 37, 37, 77, 33, 8, 49, 72, 74, 8, 77, 37, 8, 26, 35, 16, 35, 5, 49, 35, 92, 26, 49, 72, 6, 3, 3, 37, 26, 13, 62, 5, 62, 3, 37, 26, 33, 8, 72, 72, 6, 3, 3, 37, 3, 13, 62, 5, 22, 3, 13, 62, 81, 13, 49, 72, 72], [3, 77, 37, 49, 33, 32, 48, 57, 39, 49, 49, 49, 72, 72, 72, 72, 77, 37, 8, 49, 34, 6, 22, 68, 69, 49, 49, 49, 72, 72, 72, 72, 3, 77, 37, 49, 33, 32, 48, 57, 39, 49, 49, 49, 72, 72, 72, 72, 77, 37, 8, 49, 34, 6, 22, 68, 69, 49, 49, 49, 72, 72, 72, 72, 5, 49, 49, 77, 13, 49, 4, 91, 3, 49, 49, 37, 3, 49, 49, 72, 8, 49, 49, 6, 3, 77, 37, 8, 37, 49, 49, 26, 3, 49, 49, 49, 5, 49, 49, 56, 81, 13, 62, 5, 3, 49, 49, 54, 5, 3, 77, 37, 77, 49, 49, 78, 49, 3, 77, 8, 77, 49, 53, 49, 3, 49, 49, 49], [43, 47, 67, 11, 84, 49, 31, 29, 46, 80, 0, 12, 65, 49, 31, 29, 43, 47, 67, 11, 84, 49, 31, 29, 46, 80, 0, 12, 26, 49, 1, 29, 37, 49, 3, 49, 32, 57, 8, 49, 35, 49, 8, 49, 6, 68, 26, 49, 37, 49, 3, 49, 57, 32, 5, 49, 3, 57, 77, 49, 6, 68, 26, 49], [26, 73, 37, 49, 70, 47, 57, 64, 8, 49, 77, 49, 19, 49, 16, 49, 26, 73, 37, 49, 70, 47, 57, 64, 8, 49, 77, 49, 19, 49, 8, 76, 68, 69, 49, 28, 55, 48, 49, 82, 57, 79, 49, 49, 16, 49, 35, 49], [26, 49, 49, 24, 59, 19, 49, 49, 26, 49, 49, 24, 52, 8, 49, 49, 37, 49, 49, 83, 40, 8, 15, 77, 37, 49, 49, 83, 9, 60, 49, 5, 3, 44, 49, 3, 60, 5, 3, 77, 2, 3, 48, 27, 60, 5, 3, 6, 3, 44, 49, 3, 60, 5, 3, 77, 2, 3, 89, 60, 45, 38, 49, 49], [37, 77, 3, 13, 62, 18, 5, 49, 22, 21, 4, 88, 13, 75, 3, 60, 50, 56, 5, 49, 50, 56, 3, 49, 50, 71, 4, 66, 81, 49, 49, 41, 62, 49, 49, 49, 77, 67, 51, 68, 37, 11, 57, 64, 57, 42, 21, 67, 58, 67, 37, 49, 20, 17, 62, 5, 61, 75, 3, 57, 5, 51, 62, 36, 13, 91, 14, 44, 81, 49, 49, 13, 62, 49, 49, 49], [37, 26, 69, 49, 86, 57, 8, 49, 8, 35, 84, 49, 90, 83, 26, 49, 37, 26, 69, 49, 86, 57, 8, 49, 64, 74, 25, 63, 31, 49, 3, 49, 3, 49, 57, 83, 5, 62, 3, 49, 77, 49, 83, 32, 5, 21, 3, 49, 3, 49, 57, 83, 5, 21, 3, 49, 77, 49, 4, 91, 91, 21, 3, 49]];


// This is an array of the 4 sixteenth note sequences that each index in ~data_16 maps to
~mapped_data_16 = [['-', '-', 2, '-'], [-12, '-', '-', '-'], [4, '-', 4, 5], [7, '-', '-', '-'], [14, '-', 12, '-'], [9, '-', '-', '-'], [4, '-', 5, '-'], [0, '-', '~', '-'], [2, '-', '-', '-'], [5, '-', 2, 5], [0, '-', 2, '-'], ['-', '-', 4, '-'], ['-', '-', -1, '-'], [12, '-', '-', '-'], [14, '-', 16, '-'], [10, '-', '-', 5], [-3, '-', '-', '-'], [9, '-', 12, '-'], ['-', '-', 9, 11], [-2, '-', '-', '-'], [12, '-', 11, '-'], [7, '-', 9, '-'], ['~', '-', 5, '-'], [12, '-', 9, '-'], [-5, '-', 0, '-'], [-1, '-', -3, '-'], [0, '-', '-', '-'], [12, '-', 7, '-'], ['-', '-', -1, 0], [-10, '-', '-', '-'], ['~', '-', 0, '-'], [-5, '-', '-', '-'], [5, '-', 7, '-'], ['~', '-', 4, '-'], ['~', '-', 2, '-'], [-1, '-', '-', '-'], [9, '-', 7, '-'], [4, '-', '-', '-'], [16, '-', '-', '-'], [5, '-', 2, '-'], [5, '-', '-', 2], ['-', '-', 14, 12], [2, '-', 5, '-'], [0, '-', -5, '-'], ['-', '-', 12, '-'], [12, '-', 12, 14], [-1, '-', -5, '-'], [0, '-', 7, '-'], ['-', '-', 7, '-'], ['-', '-', '-', '-'], ['~', '-', 12, '-'], [7, '-', 5, '-'], [-2, '-', -2, 0], [8, '-', '-', '-'], [9, '-', 11, '-'], [2, '-', -5, '-'], [11, '-', 12, '-'], [5, '-', 4, '-'], [4, '-', 7, '-'], [2, '-', '-', -2], [10, '-', '-', '-'], [7, '-', 10, '-'], [11, '-', '-', '-'], [-5, '-', -6, '-'], [2, '-', 0, '-'], [0, '-', 4, '-'], [11, '-', 11, 12], ['-', '-', 5, '-'], [4, '-', 2, '-'], [4, '-', 0, '-'], ['~', '-', -5, '-'], ['-', '-', 16, '-'], ['~', '-', '~', '-'], ['-', '-', -5, 0], [-1, '-', 0, '-'], ['-', '-', 9, '-'], ['-', '-', 0, 2], [5, '-', '-', '-'], [7, '-', 8, '-'], [0, '-', 0, '-'], [-1, '-', 4, '-'], [14, '-', '-', '-'], ['-', '-', 5, 4], [2, '-', 4, '-'], [2, '-', -1, '-'], ['-', '-', 5, 7], [4, 0, 2, 4], [4, '-', '~', '-'], [11, '-', 9, 11], [7, '-', 7, 9], [2, 0, -1, 0], [11, '-', 9, '-'], [-3, '-', -1, '-']];

~mapper_16 = {|array|
	var list = List[];
	array.size.do{arg i; list.add(~mapped_data_16[array[i]])};
	list;
};
)

// I ran learning.py on this new data to generate some more samples
// First Sample from data with 16th notes
(
~gen4_full = List[];
~gen4 = [37, 77, 37, 49, 13, 64, 27, 49, 3, 37, 49, 26, 29, 29, 37, 67, 67, 80, 3, 77, 49, 16, 30, 72, 77, 49, 16, 49, 25, 77, 50, 16, 8, 49, 86, 5, 49, 37, 2, 13, 91, 32, 3, 51, 3, 47, 49, 49, 72, 64, 62, 5, 27, 49, 18, 49, 34, 5, 62, 66, 22, 3, 49, 3];
~gen4_full = ~mapper_16.value(~gen4);

~gen4_notes = ~unzip_16.value(~gen4_full, \notes);
~gen4_dur = ~unzip_16.value(~gen4_full, \durations);
~gen4_ampl = ~unzip_16.value(~gen4_full, \amps);

~gen4_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen4_notes.midicps,1),
	\dur, Pseq(~gen4_dur/~speed,1)).play;
)

// Second Sample from data with 16th notes
(
~gen5_full = List[];
~gen5 = [37, 8, 49, 33, 8, 8, 72, 40, 37, 37, 37, 8, 49, 64, 8, 77, 12, 43, 16, 13, 51, 49, 4, 11, 62, 49, 49, 6, 3, 52, 22, 68, 37, 49, 26, 49, 3, 49, 32, 60, 70, 11, 50, 11, 57, 17, 81, 44, 13, 49, 31, 8, 74, 72, 8, 64, 72, 43, 37, 15, 37, 10, 33, 72];
~gen5_full = ~mapper_16.value(~gen5);

~gen5_notes = ~unzip_16.value(~gen5_full, \notes);
~gen5_dur = ~unzip_16.value(~gen5_full, \durations);
~gen5_ampl = ~unzip_16.value(~gen5_full, \amps);

~gen5_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen5_notes.midicps,1),
	\dur, Pseq(~gen5_dur/~speed,1)).play;
)

// Third Sample from data with 16th notes
(
~gen6_full = List[];
~gen6 = [37, 49, 49, 83, 13, 62, 81, 61, 49, 3, 77, 91, 81, 51, 21, 5, 49, 3, 77, 30, 83, 26, 49, 8, 49, 15, 72, 10, 26, 49, 49, 87, 72, 81, 84, 62, 3, 3, 21, 3, 22, 49, 86, 57, 83, 3, 49, 49, 68, 49, 78, 49, 49, 3, 37, 37, 49, 70, 8, 77, 49, 12, 23, 49];
~gen6_full = ~mapper_16.value(~gen6);

~gen6_notes = ~unzip_16.value(~gen6_full, \notes);
~gen6_dur = ~unzip_16.value(~gen6_full, \durations);
~gen6_ampl = ~unzip_16.value(~gen6_full, \amps);

~gen6_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen6_notes.midicps,1),
	\dur, Pseq(~gen6_dur/~speed,1)).play;
)

// Fourth sample from data with 16th notes
(
~gen7_full = List[];
~gen7 = [37, 37, 49, 57, 3, 49, 49, 13, 62, 81, 5, 62, 77, 2, 3, 48, 3, 49, 1, 65, 6, 3, 49, 82, 3, 49, 49, 79, 3, 80, 3, 63, 3, 3, 54, 33, 3, 5, 62, 3, 49, 89, 5, 83, 2, 43, 77, 49, 53, 47, 3, 49, 56, 3, 49, 3, 5, 22, 38, 49, 54, 4, 62, 32];
~gen7_full = ~mapper_16.value(~gen7);

~gen7_notes = ~unzip_16.value(~gen7_full, \notes);
~gen7_dur = ~unzip_16.value(~gen7_full, \durations);
~gen7_ampl = ~unzip_16.value(~gen7_full, \amps);

~gen7_full.postln;

Pbind(
	\instrument, \pulse,
	\freq, Pseq(~gen7_notes.midicps,1),
	\dur, Pseq(~gen7_dur/~speed,1)).play;
)

// Notice these are lot less faithful to the original songs. They're more sporadic and seemingly random. They don't sound that good.

/*
**For these generated samples, I wanted to harmonize with underlying chords as I did previously, but the hidden states did not really correspond to underlying chords the way I wanted it to. Instead, it seemed to pick up on structural components of each song. I included an example output from learning.py, labeled 'Example learning output.txt'.

If you look at the hidden states from 'Example learning output.txt', you can see some of the states don't correspond to chords at all. The 7th hidden state almost exclusively sustained notes, which each probably correspond to distinct chord values. The 4th hidden state contains quarter notes around the midi number 0 (again not really an indication of the underlying chord). One way to test it for sure would be to see the corresponding chords for the observed sequences in each hidden state, but I didn't have time to incorporate this.

So the HMM does seem to pick up on some of the underlying structure, but as is, it is not really picking up on the different chords. To accomplish this, the way of representing the data might need to be restructured, or you could experiment with the number of hidden states in the Hidden Markov Model.
*/