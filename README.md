# haXsh.MD5

This was written as a drop-in replacement for the as3corelib MD5 function.

More accurately, it was written to be as fast as possible without using any
of the flash DomainMemory APIs.

<table>
	<tr>
		<td>com.adobe.crypto.MD5</td>
		<td>haXsh.MD5</td>
	</tr>
	<tr>
		<td>134.71 ms</td>
		<td>4.884 ms</td>
	</tr>
</table>

This was over 1000 runs on a 100kb ByteArray.

The code is inherited from [haxe.MD5][http://haxe.org/api/haxe/md5] which was
adapted to work off ByteArrays. The inner loops have been optimized to about
twice as fast as the original. Read COPYING file about the HaXe Copyright notices.

The blooddy.by functions are faster, but they run into the alchemy licensing
constraints (Adobe wants 9% revenue if you use 3D and DomainMemory together).

But if you need Stage3D and a fast MD5, this is your best bet.


