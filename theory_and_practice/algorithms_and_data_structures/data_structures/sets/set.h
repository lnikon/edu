#pragma once

struct Set
{

};

void set_init(Set* set, int (*match)(const void* key1, const void* key2), void (*destroy)(void* data));
void set_destroy(Set* set);
int set_insert(Set* set, const void* data);
int set_remove(Set* set, void** data);
int set_union(Set* setu, const Set* set1, const Set* set2);