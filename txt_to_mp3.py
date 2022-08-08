# Import the Gtts module for text  
# to speech conversion 
from gtts import gTTS 
  
# import Os module to start the audio file
import os
import sys

fichiertexte = sys.argv[1]
print(fichiertexte)

fh = open(fichiertexte, "r")
myText = fh.read().replace("\n", " ")

# Language we want to use 
language = 'fr'

output = gTTS(text=myText, lang=language, slow=False)

output.save("output.mp3")
fh.close()

