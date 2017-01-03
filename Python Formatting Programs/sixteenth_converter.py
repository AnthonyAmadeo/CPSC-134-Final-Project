import sys
import ast

x = open(sys.argv[1]) # Take a song corpus and convert the series of eighth note sequences into sixteenth note sequences
x = x.read().splitlines()

for i in range(len(x)):
    if i == 0:
        concat = False
    elif x[i][:2] == "[[":
        concat = True
        y = x[i]
    elif x[i][len(x[i])-2:len(x[i])] == ']]':
        y = y + x[i]
        concat = False
        y = ast.literal_eval(y)
        for each in y:
            counter = 0
            for i in range(len(each)):
                each.insert(i+counter+1,'-')
                counter = counter + 1
        counts = 0
        for i in range(len(y)):
            y.insert(i+counts+1,y[i+counts][4:])
            y[i+counts] = y[i+counts][:4]
            counts = counts + 1
        print(y)
    elif concat:
        y = y + x[i]
