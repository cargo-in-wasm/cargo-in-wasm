.PHONY: all clean

all: build-rust

build/rust/config.toml:
	[ -f build/rust/.git ] || GIT_DIR=rust/.git git worktree add -f --detach build/rust
	GIT_DIR=build/rust/.git git checkout -q --detach master
	sed "s@#ROOT_PATH#@`pwd`@g" < rust-config.toml > build/rust/config.toml

build-rust: build/rust/config.toml
	cd build/rust; ./x.py build

clean:
	rm -rf build/