#pragma once

struct list_elem_t
{
    list_elem_t* next;
    void* data;
};

struct list_t
{
    list_elem_t* head;

    /*
     * 0 - equal
     * 1 - first is greater
     * -1 - first is less
     */
    void (*match)(const void* key1, const void* key2);
    void (*destroy)(void* data);
};

void init_list()