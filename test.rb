require 'depictor'

depictor = Depictor.new
name = '3,3-dimethyl-7-oxo-6-[(2-phenylacetyl)amino]-4-thia-1-azabicyclo[3.2.0]heptane-2-carboxylic acid' #Penicillin G

depictor.depict_png(name, 'out.png', 300, 300)
