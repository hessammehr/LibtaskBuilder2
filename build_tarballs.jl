using BinaryBuilder

# Collection of sources required to build LibtaskBuilder
sources = [
    "https://github.com/yebai/Turing.jl.git" =>
    "e3c430d3a53d413e51e14cb47f0b1817a47ca358",

]

# Bash recipe for building across all platforms
script = raw"""
if [ $target = "aarch64-linux-gnu" ]; then
cd $WORKSPACE/srcdir
wget "https://julialang-s3.julialang.org/bin/linux/aarch64/0.6/julia-0.6.2-linux-aarch64.tar.gz"
tar xzvf julia-0.6.2-linux-aarch64.tar.gz 
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-dynamic -ljulia -o libtask.so
mv libtask.so $WORKSPACE/destdir
exit
fi

if [ $target = "arm-linux-gnueabihf" ]; then
cd $WORKSPACE/srcdir
wget "https://julialang-s3.julialang.org/bin/linux/armv7l/0.6/julia-0.6.2-linux-armv7l.tar.gz"
tar xzvf julia-0.6.2-linux-armv7l.tar.gz
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-dynamic -ljulia -o libtask.so
mv libtask.so $WORKSPACE/destdir
exit
fi

if [ $target = "powerpc64le-linux-gnu" ]; then
cd $WORKSPACE/srcdir
wget "https://julialang-s3.julialang.org/bin/linux/ppc64le/0.6/julia-0.6-latest-linux-ppc64le.tar.gz"
tar xzvf julia-0.6-latest-linux-ppc64le.tar.gz
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-dynamic -ljulia -o libtask.so
mv libtask.so $WORKSPACE/destdir
exit
fi

if [ $target = "i686-linux-gnu" ]; then
cd $WORKSPACE/srcdir
wget "https://julialang-s3.julialang.org/bin/linux/x86/0.6/julia-0.6.2-linux-i686.tar.gz"
tar xzvf julia-0.6.2-linux-i686.tar.gz
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-dynamic -ljulia -o libtask.so
mv libtask.so $WORKSPACE/destdir
exit
fi

if [ $target = "x86_64-linux-gnu" ]; then
cd $WORKSPACE/srcdir
wget "https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz"
tar xzvf julia-0.6.2-linux-x86_64.tar.gz 
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-dynamic -ljulia -o libtask.so
mv libtask.so $WORKSPACE/destdir
exit
fi

if [ $target = "x86_64-w64-mingw32" ]; then
cd $WORKSPACE/srcdir
wget "http://mlg.eng.cam.ac.uk/hong/julia-0.6.2-win64.tar.gz"
tar xzvf julia-0.6.2-win64.tar.gz 
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-all-symbols -ljulia -o libtask.dll
mv libtask.dll $WORKSPACE/destdir/
exit

fi

if [ $target = "i686-w64-mingw32" ]; then
cd $WORKSPACE/srcdir
wget "http://mlg.eng.cam.ac.uk/hong/julia-0.6.2-win32.tar.gz"
tar xzvf julia-0.6.2-win32.tar.gz 
rm *.tar.gz
mv julia* julia
LIBS="`pwd`/julia/lib"
LIBSJL="`pwd`/julia/lib/julia"
INCLUDES="`pwd`/julia/include/julia"
cd Turing.jl/deps/
gcc -O2 -shared -std=gnu99 -I$INCLUDES -DJULIA_ENABLE_THREADING=1 -fPIC -L$LIBSJL -L$LIBS -Wl,--export-all-symbols -ljulia -o libtask.dll
mv libtask.dll $WORKSPACE/destdir/
exit

fi


"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtask", Symbol("\e\eLibTask"))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "LibtaskBuilder", sources, script, platforms, products, dependencies)

