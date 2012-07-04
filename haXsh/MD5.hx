/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

/* Modifed to be a faster replacement for the com.adobe MD5 */

package haXsh;

import flash.utils.ByteArray;
import haxe.io.Bytes;
/**
	Creates a MD5 of a String.
**/
class MD5 {	
/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Copyright (C) Paul Johnston 1999 - 2000.
 * Updated by Greg Holt 2000 - 2001.
 * See http://pajhome.org.uk/site/legal.html for details.
 */

	/* Unlike javascript, we do not worry about int sizes at all with these functions */

	static inline function bitOR(a, b){
		return a | b;
	}

	static inline function bitXOR(a, b){
		return a ^ b;
	}

	static inline function bitAND(a, b){
		return a & b;
	}

	static inline function addme(x, y) {
		return x+y;
	}

	static inline function rhex( num ){
		var str = "";
		var hex_chr = "0123456789abcdef";
		for( j in 0...4 ){
			str += hex_chr.charAt((num >> (j * 8 + 4)) & 0x0F) +
						 hex_chr.charAt((num >> (j * 8)) & 0x0F);
		}
		return str;
	}

	/* function modified from haXe forum post - http://haxe.org/forum/thread/1637 */
	static inline function bytes2blks( buf:ByteArray ) {
		var bstr:Bytes = Bytes.ofData(buf);
		var nblk = ((bstr.length + 8) >> 6) + 1;
		var blks = new Array();
		for( i in 0...(nblk <<4 ) ) blks[i] = 0;

		var i = 0;
		var len = bstr.length;
		var n = len >> 2;
		for(i in 0...n) {
			var j = 4*i;
			var i0 = bstr.get(j);
			var i1 = bstr.get(j+1);
			var i2 = bstr.get(j+2);
			var i3 = bstr.get(j+3);
			blks[i] = i0 | (i1 << 8) | (i2 << 16) | (i3 << 24);
		}
		i = n*4;
		while( i < len ) {
			blks[i >> 2] |= bstr.get(i) << ((i & 0x3) << 3);
			i++;
		}
		blks[i >> 2] |= 0x80 << (( i & 0x3) << 3);
		var l = len << 3;
		var k = (nblk <<4) - 2;

		var z = 0; 
		z = (l & 0xFF);
		z |= ((l >>> 8) & 0xFF) << 8;
		z |= ((l >>> 16) & 0xFF) << 16;
		z |= ((l >>> 24) & 0xFF) << 24;

		blks[k] |= z;

		return blks;
	}

	static inline function rol(num, cnt){
		return (num << cnt) | (num >>> (32 - cnt));
	}

	static inline function cmn(q, a, b, x, s, t){
		return addme(rol((addme(addme(a, q), addme(x, t))), s), b);
	}

	static inline function ff(a, b, c, d, x, s, t){
		return cmn(bitOR(bitAND(b, c), bitAND((~b), d)), a, b, x, s, t);
	}

	static inline function gg(a, b, c, d, x, s, t){
		return cmn(bitOR(bitAND(b, d), bitAND(c, (~d))), a, b, x, s, t);
	}

	static inline function hh(a, b, c, d, x, s, t){
		return cmn(bitXOR(bitXOR(b, c), d), a, b, x, s, t);
	}

	static inline function ii(a, b, c, d, x, s, t){
		return cmn(bitXOR(c, bitOR(b, (~d))), a, b, x, s, t);
	}

	public static function hashBytes( buf:ByteArray ) : String {

		var x = bytes2blks(buf);
		var a =  1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d =  271733878;

		var step;

		var i = 0;
		var len = x.length;
		while( i < len )  {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;

			var h0=x[i+0];
			var h1=x[i+1];
			var h2=x[i+2];
			var h3=x[i+3];
			var h4=x[i+4];
			var h5=x[i+5];
			var h6=x[i+6];
			var h7=x[i+7];
			var h8=x[i+8];
			var h9=x[i+9];
			var h10=x[i+10];
			var h11=x[i+11];
			var h12=x[i+12];
			var h13=x[i+13];
			var h14=x[i+14];
			var h15=x[i+15];


			step = 0;
			a = ff(a, b, c, d, h0, 7 , -680876936);
			d = ff(d, a, b, c, h1, 12, -389564586);
			c = ff(c, d, a, b, h2, 17,  606105819);
			b = ff(b, c, d, a, h3, 22, -1044525330);
			a = ff(a, b, c, d, h4, 7 , -176418897);
			d = ff(d, a, b, c, h5, 12,  1200080426);
			c = ff(c, d, a, b, h6, 17, -1473231341);
			b = ff(b, c, d, a, h7, 22, -45705983);
			a = ff(a, b, c, d, h8, 7 ,  1770035416);
			d = ff(d, a, b, c, h9, 12, -1958414417);
			c = ff(c, d, a, b, h10, 17, -42063);
			b = ff(b, c, d, a, h11, 22, -1990404162);
			a = ff(a, b, c, d, h12, 7 ,  1804603682);
			d = ff(d, a, b, c, h13, 12, -40341101);
			c = ff(c, d, a, b, h14, 17, -1502002290);
			b = ff(b, c, d, a, h15, 22,  1236535329);
			a = gg(a, b, c, d, h1, 5 , -165796510);
			d = gg(d, a, b, c, h6, 9 , -1069501632);
			c = gg(c, d, a, b, h11, 14,  643717713);
			b = gg(b, c, d, a, h0, 20, -373897302);
			a = gg(a, b, c, d, h5, 5 , -701558691);
			d = gg(d, a, b, c, h10, 9 ,  38016083);
			c = gg(c, d, a, b, h15, 14, -660478335);
			b = gg(b, c, d, a, h4, 20, -405537848);
			a = gg(a, b, c, d, h9, 5 ,  568446438);
			d = gg(d, a, b, c, h14, 9 , -1019803690);
			c = gg(c, d, a, b, h3, 14, -187363961);
			b = gg(b, c, d, a, h8, 20,  1163531501);
			a = gg(a, b, c, d, h13, 5 , -1444681467);
			d = gg(d, a, b, c, h2, 9 , -51403784);
			c = gg(c, d, a, b, h7, 14,  1735328473);
			b = gg(b, c, d, a, h12, 20, -1926607734);
			a = hh(a, b, c, d, h5, 4 , -378558);
			d = hh(d, a, b, c, h8, 11, -2022574463);
			c = hh(c, d, a, b, h11, 16,  1839030562);
			b = hh(b, c, d, a, h14, 23, -35309556);
			a = hh(a, b, c, d, h1, 4 , -1530992060);
			d = hh(d, a, b, c, h4, 11,  1272893353);
			c = hh(c, d, a, b, h7, 16, -155497632);
			b = hh(b, c, d, a, h10, 23, -1094730640);
			a = hh(a, b, c, d, h13, 4 ,  681279174);
			d = hh(d, a, b, c, h0, 11, -358537222);
			c = hh(c, d, a, b, h3, 16, -722521979);
			b = hh(b, c, d, a, h6, 23,  76029189);
			a = hh(a, b, c, d, h9, 4 , -640364487);
			d = hh(d, a, b, c, h12, 11, -421815835);
			c = hh(c, d, a, b, h15, 16,  530742520);
			b = hh(b, c, d, a, h2, 23, -995338651);
			a = ii(a, b, c, d, h0, 6 , -198630844);
			d = ii(d, a, b, c, h7, 10,  1126891415);
			c = ii(c, d, a, b, h14, 15, -1416354905);
			b = ii(b, c, d, a, h5, 21, -57434055);
			a = ii(a, b, c, d, h12, 6 ,  1700485571);
			d = ii(d, a, b, c, h3, 10, -1894986606);
			c = ii(c, d, a, b, h10, 15, -1051523);
			b = ii(b, c, d, a, h1, 21, -2054922799);
			a = ii(a, b, c, d, h8, 6 ,  1873313359);
			d = ii(d, a, b, c, h15, 10, -30611744);
			c = ii(c, d, a, b, h6, 15, -1560198380);
			b = ii(b, c, d, a, h13, 21,  1309151649);
			a = ii(a, b, c, d, h4, 6 , -145523070);
			d = ii(d, a, b, c, h11, 10, -1120210379);
			c = ii(c, d, a, b, h2, 15,  718787259);
			b = ii(b, c, d, a, h9, 21, -343485551);

			a = addme(a, olda);
			b = addme(b, oldb);
			c = addme(c, oldc);
			d = addme(d, oldd);

			i += 16;
		}
		return rhex(a) + rhex(b) + rhex(c) + rhex(d);
	}
}
