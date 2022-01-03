# 下記3パターンでmain.ccとhoge.ccをbuildする
# [1] オブジェクトファイルをリンク(ライブラリ不使用)
# [2] 動的リンク
# [3] 静的リンク

CXX = g++
CXXFLAGS = -std=c++11 -O3 -Wall
LDFLAGS = -L./dynamic-lib
LDLIBS = -lhoge
OBJS = main.o hoge.o dynamic-lib/libhoge.so static-lib/libhoge.a
TARGETS = main-wo-lib.out main-dynamic-link.out main-static-link.out

### [1][2][3]をbuildし、実行する
run: all
	./main-wo-lib.out
	export LD_LIBRARY_PATH=./dynamic-lib:${LD_LIBRARY_PATH} ; ./main-dynamic-link.out
	./main-static-link.out

### [1][2][3]をbuildする
all: $(TARGETS)

# [1] オブジェクトファイルをリンク(ライブラリ不使用)
main-wo-lib.out: main.o hoge.o
	$(CXX) -o $@ $< $(CXXFLAGS) hoge.o

# [2] 動的リンク
main-dynamic-link.out: main.o dynamic-lib/libhoge.so
	$(CXX) -o $@ $< $(CXXFLAGS) $(LDFLAGS) $(LDLIBS)

# [3] 静的リンク
main-static-link.out: main.o static-lib/libhoge.a
	$(CXX) -o $@ $< $(CXXFLAGS) static-lib/libhoge.a

# [2] 動的ライブラリを生成
dynamic-lib/libhoge.so: hoge.cc
	mkdir -p dynamic-lib
	$(CXX) -o $@ $< $(CXXFLAGS) -fPIC -shared

# [3] 静的ライブラリを生成
static-lib/libhoge.a: hoge.o
	mkdir -p static-lib
	$(AR) rcs $@ $<

main.o: main.cc
	$(CXX) -o $@ $< $(CXXFLAGS) -c

hoge.o: hoge.cc
	$(CXX) -o $@ $< $(CXXFLAGS) -c

clean:
	$(RM) $(TARGETS) $(OBJS)

.PHONY: run all clean
