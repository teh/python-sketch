# Python library build sketches

This was inspired by a blog post from Akihiro Matsukawa [1]. Sketches are useful for heavy hitter detection amongst other things. The implementation uses Bob Jenkins lookup3 hash function [2] which is very good for this type of application.

# Example

    from _sketch import Sketch

    # First argument is the number of hashes.The second argument is
    # the number of buckets and needs to be a power of two.
    sketch = Sketch(4, 16)
    print sketch.data

    for word in 'Look at mee! Dr Zoidberg, homeowner!'.split():
        sketch.update(word, 1)

    print sketch.data

# The rest

Licence is 3-clause BSD. 

[1]
http://amatsukawa.posterous.com/heavy-hitter-detection

[2]
http://burtleburtle.net/bob/

