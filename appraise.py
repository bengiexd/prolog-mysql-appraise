# A short Python script to demonstrate how the Prolog is meant to be used.
# Requires pyswip and a running instance of MySQL.
from pyswip import Prolog

prolog = Prolog()

prolog.consult("appraise.pl")

# A couple preliminary assertions.
prolog.assertz("value(banana, 1 rdiv 4, bitcoin)")
prolog.assertz("value(bitcoin, 1 rdiv 30, namecoin)")
prolog.assertz("value(apple, 3 rdiv 4, banana)")
prolog.assertz("value(orange, 1 rdiv 5, apple)")

# Now, how much is an orange worth in bitcoins?
result = prolog.query("appraise_float(orange, Price, bitcoin)").next()
print "An orange is worth %s bitcoins." % result["Price"]

# And how much is a bitcoin worth in apples?
result = prolog.query("appraise_float(bitcoin, Price, apple)").next()
print "A bitcoin is worth %s apples." % result["Price"]
