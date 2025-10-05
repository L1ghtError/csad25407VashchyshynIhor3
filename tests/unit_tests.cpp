#include <gtest/gtest.h>
#include "../math_operations.h"

TEST(MathOperationsTest, AddPositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(MathOperationsTest, AddNegativeNumbers) {
    EXPECT_EQ(add(-1, 1), 0);
    EXPECT_EQ(add(-5, -7), -12);
}

TEST(MathOperationsTest, AddZero) {
    EXPECT_EQ(add(0, 0), 0);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
