.PHONY: all clean

all: build-rust

build/wasi-sdk/build/package.BUILT:
	[ -f build/wasi-sdk/.git ] || GIT_DIR=wasi-sdk/.git git worktree add -f --detach build/wasi-sdk
	GIT_DIR=build/wasi-sdk/.git git checkout -q --detach main
	cd build/wasi-sdk && git submodule update --init --checkout --recursive --progress
	$(MAKE) -C build/wasi-sdk package

build/rust/config.toml: rust-config.toml
	[ -f build/rust/.git ] || GIT_DIR=rust/.git git worktree add -f --detach build/rust
	GIT_DIR=build/rust/.git git checkout -q --detach master
	sed "s@#ROOT_PATH#@`pwd`@g" < rust-config.toml > build/rust/config.toml

build-rust: build/rust/config.toml build/wasi-sdk/build/package.BUILT
	cd build/rust; ./x.py build

clean:
	rm -rf build/
