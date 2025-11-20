cd fuzz
make clean-corpus
make fuzz.o

for fuzzer in \
    api html lint reader regexp schema uri valid xinclude xml xpath
do
    OBJS="$fuzzer.o"
    if [ "$fuzzer" = lint ]; then
        OBJS="$OBJS ../xmllint.o ../shell.o"
    fi
    make $OBJS
    # Link with $CXX
    $CXX $CXXFLAGS \
        $OBJS fuzz.o \
        -o $OUT/$fuzzer \
        $LIB_FUZZING_ENGINE \
        ../.libs/libxml2.a -Wl,-Bstatic -lz -Wl,-Bdynamic

    if [ $fuzzer != api ]; then
        [ -e seed/$fuzzer ] || make seed/$fuzzer.stamp
        zip -j $OUT/${fuzzer}_seed_corpus.zip seed/$fuzzer/*
    fi
done

cp *.dict *.options $OUT/

