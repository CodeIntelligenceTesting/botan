# forces script to fail on error
set -e

# determine which build-dir to use depending on cifuzz step
if [ "$CIFUZZ_BUILD_STEP" == "fuzzing" ]; then
    build_dir="build-fuzzing"
elif [ "$CIFUZZ_BUILD_STEP" == "coverage" ]; then
    build_dir="build-coverage"
fi

# make sure one argument (fuzz test name) is passed
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <fuzz_test_name>"
	exit 1
fi

# recompile if necessary
if [ "$CONFIGURE" == "1" ] || [ ! -d ${build_dir} ]; then
  rm -rf ${build_dir}
  mkdir -p ${build_dir}
  ./configure.py --with-build-dir=${build_dir} 
fi 

make -f ${build_dir}/Makefile

#cifuzz:build-template:begin
#if [ "$FUZZ_TEST" == "{{ .FuzzTestName }}" ]; then
#  ${CXX} -fstack-protector -pthread -stdlib=libc++ -std=c++20 -D_REENTRANT ${CXXFLAGS} ${FUZZ_TEST_CXXFLAGS} -DBOTAN_IS_BEING_BUILT -I build/include/public -I build/include/internal -isystem build/include/external ${build_dir}/libbotan-3.a -c {{ .FileName }} -o {{ .FuzzTestName }}
#  chmod +x {{ .FuzzTestName }}
#fi
#cifuzz:build-template:end

if [ "$FUZZ_TEST" == "fuzz_EC_PrivateKey_EC_PrivateKey_1" ]; then
  echo "running command"
  ${CXX} -fstack-protector -pthread -stdlib=libc++ -std=c++20 -D_REENTRANT ${CXXFLAGS} ${FUZZ_TEST_CXXFLAGS} -I build/include/public -I build/include/internal -isystem build/include/external -c fuzz_EC_PrivateKey_EC_PrivateKey_1.cpp -o fuzz_EC_PrivateKey_EC_PrivateKey_1
  echo "chmod"
  chmod +x fuzz_EC_PrivateKey_EC_PrivateKey_1
fi
