@echo off
REM Create build directory
if not exist build mkdir build
cd build
REM Configure project
cmake ..
REM Build project
cmake --build .
REM Run tests
ctest --output-on-failure