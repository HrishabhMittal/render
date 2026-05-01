all:
	mkdir -p build
	odin build src -o:none -out:./build/main
run:
	odin run src
clean:
	rm -rf build
