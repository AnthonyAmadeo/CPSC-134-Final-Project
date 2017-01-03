"""
Sampling from HMM
-----------------

This script shows how to sample points from a Hiden Markov Model (HMM):
we use a 4-components with specified mean and covariance.

The plot show the sequence of observations generated with the transitions
between them. We can see that, as specified by our transition matrix,
there are no transition between component 1 and 3.
"""
print(__doc__)

import numpy as np
import matplotlib.pyplot as plt

import numpy as np
from hmmlearn import hmm
import ast
import sys

decode = False
if len(sys.argv) == 2:
    y = open(sys.argv[1]) # Take in observation sequences, already indexed
elif len(sys.argv) == 3:
    y = open(sys.argv[1]) # Take in observation sequences, already indexed
    decoded = open(sys.argv[2]) # If there's another argument, read it as a file of decoded observation sequences
    decoded = decoded.readlines()[0]
    decoded = ast.literal_eval(decoded)
    decode = True
    
x = y.readlines()[0]
x = ast.literal_eval(x)

lengths = []
for each in x:
    lengths.append(len(each))

for each in x:
	for i in range(len(each)):
		each[i] = [each[i]]

X = np.concatenate(x)

# I used a Multinomial HMM because it was the only discrete option
# Documentation for hmmlearn is at "https://github.com/hmmlearn/hmmlearn".
model = hmm.MultinomialHMM(n_components = 16, n_iter = 1000)
model.fit(X, lengths)
hiddens = model.predict(X, lengths)

print("\nViterbi most probable hidden states for data")
print(hiddens)

print(model)
print("Transition matrix")
print(model.transmat_)
print("Emission matrix")
print(model.emissionprob_)
print("Initial Distribution")
print(model.startprob_)

print("Generated Sample")
sample = model.sample(64)
sequence = []
hidden_seq = []
for each in sample[0]:
    sequence.append(each[0])
for each in sample[1]:
    hidden_seq.append(each)
print(sequence)
print('Hidden States of Generated Sample')
print(hidden_seq)

if decode: # Print the observed sequences each hidden state maps to in the Viterbi prediction
    print('Tally of Observed States Corresponding to each Hidden State:')
    for i in range(model.n_components):
        print('{0}th hidden state'.format(i))
        corresponds = []
        for each in X[hiddens == i]:
            corresponds.append(decoded[each[0]])
        print(corresponds)
