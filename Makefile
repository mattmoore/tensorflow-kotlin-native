ifeq ($(shell uname), Darwin)
	OS=darwin
	TARGET=libtensorflow_c_api.dylib
else
ifeq ($(shell uname), Linux)
	OS=linux
	TARGET=libtensorflow_c_api.so
endif
endif

all: prepare tensorflow-kotlin-bindings kotlin-native

prepare:
	@if [ ! -d build ]; then mkdir -p build; fi

tensorflow-kotlin-bindings: prepare
	@echo "Generating Kotlin binding library for TensorFlow C API."
	@cinterop \
		-def src/nativeInterop/cinterop/tensorflow.def \
		-o build/tensorflow.klib \
		-compilerOpts -I/usr/local/include \
		&& echo "Finished generating TensorFlow Kotlin bindings."

kotlin-native: prepare
	@echo "Compiling Kotlin Native code."
	@kotlinc-native \
		-o build/main \
		-l build/tensorflow.klib \
		-linker-options /usr/local/lib/libtensorflow.so \
		-e io.mattmoore.tensorflow.main \
		src/nativeMain/kotlin/io/mattmoore/tensorflow/*.kt \
		&& echo "Success."

clean:
	@if [ -e build ]; then rm -rf build; fi
	@echo "Cleaned."

run:
	@build/main.kexe
