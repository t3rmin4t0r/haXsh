SRC=haXsh/MD5.hx 

all: $(SRC)
	haxe -debug -main haXsh.Test -swf Test.swf $(SRC) haXsh/Test.hx
	haxe -swf haXsh.swc $(SRC)
