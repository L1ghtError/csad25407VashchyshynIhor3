
cmake_minimum_required(VERSION 3.10)
project(project)


set(CMAKE_CXX_STANDARD 11)

# Fix MSVC runtime library mismatch for all targets and Google Test
if(MSVC)
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
	foreach(flag_var
		CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
		CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE)
		string(REPLACE "/MT" "/MD" ${flag_var} "${${flag_var}}")
		string(REPLACE "/MTd" "/MDd" ${flag_var} "${${flag_var}}")
	endforeach()
endif()

add_executable(project main.cpp)

# GoogleTest
include(FetchContent)
FetchContent_Declare(
	googletest
	URL https://github.com/google/googletest/archive/refs/heads/main.zip
)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(unit_tests tests/unit_tests.cpp math_operations.cpp)
target_link_libraries(unit_tests gtest_main)

include(GoogleTest)
gtest_discover_tests(unit_tests)
