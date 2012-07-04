package haXsh;
import flash.utils.ByteArray;
import flash.Lib;

class Test
{
	static inline function main()
	{
		var start = flash.Lib.getTimer();
		var b = new ByteArray();
		for(i in 0...1024) b.writeUTFBytes("Hello World");
		trace(MD5.hashBytes(b));
		var duration = flash.Lib.getTimer() - start;
		trace("MD5("+b.length+" bytes) in "+duration+" milliseconds");

	}
}
