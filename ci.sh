#!/bin/bash
# Create build directory
mkdir -p build
cd build
# Configure project
cmake ..
# Build project
cmake --build .
# Run tests
ctest --output-on-failure