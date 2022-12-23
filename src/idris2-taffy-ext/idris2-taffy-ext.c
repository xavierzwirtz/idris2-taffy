#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <idris2-taffy-ext.h>

void* Idris2_Taffy_Ext_Layout_get_child(Idris2_Taffy_Ext_Layout layout, int child) {
    return layout.children[child];
};

void* idris2_taffy_ext_create_layout(const float* f)
{
    Idris2_Taffy_Ext_Layout* layout = malloc(sizeof(struct Idris2_Taffy_Ext_Layout));

    layout->x = *f;
    f++;
    layout->y = *f;
    f++;
    layout->width = *f;
    f++;
    layout->height = *f;
    f++;
    layout->childCount = *f;
    f++;

    layout->children = malloc(sizeof(void *) * layout->childCount);
    for (int i = 0; i < layout->childCount; i++) {
        layout->children[i] = idris2_taffy_ext_create_layout(f);
    }

    return layout;
}

Idris2_Taffy_Ext_Layout idris2_taffy_ext_compute_layout(void *taffy,
                                                        void *node,
                                                        struct TaffyStyleDimension width,
                                                        struct TaffyStyleDimension height)
{
    Idris2_Taffy_Ext_Layout* layout =
        (Idris2_Taffy_Ext_Layout*) taffy_node_compute_layout(taffy,
                                                             node,
                                                             width,
                                                             height,
                                                             idris2_taffy_ext_create_layout);
    return *layout;
}
