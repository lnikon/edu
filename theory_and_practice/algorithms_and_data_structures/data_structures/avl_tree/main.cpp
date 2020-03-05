#include "avl_tree.hpp"

#include <cstdlib>
#include <ctime>
#include <iostream>

int main()
{
    srand(time(NULL));

    AVLTree tree;
    const int size = 10;
    for (int i = 0; i < size; ++i)
    {
        tree.insert(i * rand() % 10);
        // tree.insert(i);
    }

    tree.preorderIterative();
    std::cout << "\n\n";
    tree.inorderIterative();
    
    return 0;
}
