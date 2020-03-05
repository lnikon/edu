#pragma once

#include <iostream>
#include <stack>

struct AVLNode
{
    int value{0};
    int height{0};
    AVLNode* left{nullptr};
    AVLNode* right{nullptr};


    AVLNode(int value)
    : value(value), height(0), left(nullptr), right(nullptr) {}
};

class AVLTree
{
    public:
    ~AVLTree() {}

    AVLNode* insert(int value)
    {
        if (root == nullptr)
        {
            root = new AVLNode(value);
        }

        AVLNode** node = &root;
        while (*node != nullptr)
        {
            if (value > (*node)->value)
            {
                node = &(*node)->right;
            }
            else if (value < (*node)->value)
            {
                node = &(*node)->left;
            }
            else
            {
                /* No duplicate keys */
                return *node;
            }
        }

        if (*node == nullptr)
        {
            *node = new AVLNode(value);
            return *node;
        }

        return nullptr;
    }

    AVLNode* search(int value)
    {
        if (root == nullptr) 
        {
            return nullptr;
        }
        
        AVLNode** node = &root;
        while (*node != nullptr)
        {
            if (value > (*node)->value)
            {
                node = &(*node)->right;
            }
            else if (value < (*node)->value)
            {
                node = &(*node)->left;
            }
            else
            {
                return *node;
            }
        }

        return nullptr;
    }

    void preorderIterative()
    {
        preorderIterativeHelper(root);
    }

    void inorderIterative()
    {
        inorderIterativeHelper(root);
    }

    void preorder()
    {
        preorderHelper(root);
    }

    void inorder()
    {
        inorderHelper(root);
    }

    void postorder()
    {
        postorderHelper(root);
    }

    private:
    AVLNode* root{nullptr};

    void leftLeftRotate() {}
    void leftRightRotate() {}
    void rightRightRotate() {}
    void rightLeftRotate() {}

    void height(const AVLNode* node) {}
    void balanceFactor(const AVLNode* node) {}

    void visit(AVLNode* node) 
    {
        std::cout << "At node @" << node << " value = " << node->value << std::endl;
    }

    void preorderIterativeHelper(AVLNode* node)
    {
        if (node == nullptr) return;

        std::stack<AVLNode*> stack;
        stack.push(node);
        while (!stack.empty())
        {
            AVLNode* node = stack.top();
            stack.pop();

            visit(node);

            if (node->right != nullptr) stack.push(node->right);
            if (node->left != nullptr) stack.push(node->left);
        }
    }

    void inorderIterativeHelper(AVLNode* node)
    {
        if (node == nullptr) return;

        std::stack<AVLNode*> stack;
        while (!stack.empty() || node != nullptr)
        {
            if (node != nullptr)
            {
                stack.push(node);
                node = node->left;
            }
            else
            {
                node = stack.top();
                stack.pop();
                visit(node);
                node = node->right;
            }
        }
    }

    void preorderHelper(AVLNode* node)
    {
        if (node == nullptr) return;

        visit(node);
        preorderHelper(node->left);
        preorderHelper(node->right);
    }

    void inorderHelper(AVLNode* node)
    {
        if (node == nullptr) return;

        inorderHelper(node->left);
        visit(node);
        inorderHelper(node->right);
    }

    void postorderHelper(AVLNode* node)
    {
        if (node == nullptr) return;

        postorderHelper(node->left);
        postorderHelper(node->right);
        visit(node);
    }

};

