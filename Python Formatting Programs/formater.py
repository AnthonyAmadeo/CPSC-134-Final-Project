from collections import Counter
import sys
import ast

x = open(sys.argv[1]) # Have massive array file as the first argument
x = x.readlines()[0]
x = ast.literal_eval(x)

q = []
for song in x:
    for quartet in song:
        q.append(quartet)


y = Counter(str(e) for e in q)
l = list(y)
z = []

for song in x:
	t = []
	for quartet in song:
		for i in range(len(y)):
			if str(quartet) == l[i]:
				t.append(i)
	z.append(t)


print(z)

for i in range(len(l)):
    l[i] = ast.literal_eval(l[i])
    
print(l)
print("Counter has", str(len(y)), "elements.")
