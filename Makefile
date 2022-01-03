CXX = g++
CXXFLAGS = -std=c++11 -O3 -Wall
LDFLAGS = -L./dynamic-lib
LDLIBS = -lhoge
OBJS = main.o hoge.o dynamic-lib/libhoge.so static-lib/libhoge.a
TARGETS = main-wo-lib.out main-dynamic-link.out main-static-link.out

run: all
	./main-wo-lib.out
	export LD_LIBRARY_PATH=./dynamic-lib:${LD_LIBRARY_PATH} ; ./main-dynamic-link.out
	./main-static-link.out

all: $(TARGETS)

main-wo-lib.out: main.o hoge.o
	$(CXX) -o $@ $< $(CXXFLAGS) hoge.o

main-dynamic-link.out: main.o dynamic-lib/libhoge.so
	$(CXX) -o $@ $< $(CXXFLAGS) $(LDFLAGS) $(LDLIBS)

main-static-link.out: main.o static-lib/libhoge.a
	$(CXX) -o $@ $< $(CXXFLAGS) static-lib/libhoge.a

main.o: main.cc
	$(CXX) -o $@ $< $(CXXFLAGS) -c

hoge.o: hoge.cc
	$(CXX) -o $@ $< $(CXXFLAGS) -c

dynamic-lib/libhoge.so: hoge.cc
	mkdir -p dynamic-lib
	$(CXX) -o $@ $< $(CXXFLAGS) -fPIC -shared

static-lib/libhoge.a: hoge.o
	mkdir -p static-lib
	$(AR) rcs $@ $<

clean:
	$(RM) $(TARGETS) $(OBJS)

.PHONY: run all clean
