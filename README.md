# haXsh.MD5

This was written as a drop-in replacement for the as3corelib MD5 function.

More accurately, it was written to be as fast as possible without using any
of the flash DomainMemory APIs.

The code is inherited from http://haxe.org/api/haxe/md5 adapted to work off
ByteArrays and the inner loops have been optimized. Read LICENSE file about
the HaXe Copyright notices.

The blooddy.by functions are faster, but they run into the alchemy licensing
constraints (Adobe wants 9% revenue if you use 3D and DomainMemory together).
