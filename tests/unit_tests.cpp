#include "../math_operations.h"
#include <cassert>
#include <iostream>

void test_add() {
    assert(add(2, 3) == 5);
    assert(add(-1, 1) == 0);
    assert(add(0, 0) == 0);
    assert(add(-5, -7) == -12);
    std::cout << "All add() tests passed!" << std::endl;
}

int main() {
    test_add();
    return 0;
}
