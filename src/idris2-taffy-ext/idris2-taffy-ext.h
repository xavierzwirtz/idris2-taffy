#include <taffy.h>

typedef struct Idris2_Taffy_Ext_Layout {
    float x;
    float y;
    float width;
    float height;
    int childCount;
    void** children;
} Idris2_Taffy_Ext_Layout;

void* Idris2_Taffy_Ext_Layout_get_child(Idris2_Taffy_Ext_Layout layout,
                                        int child);
void* idris2_taffy_ext_create_layout(const float* f);
Idris2_Taffy_Ext_Layout idris2_taffy_ext_compute_layout(void *taffy,
                                                        void *node,
                                                        struct TaffyStyleDimension width,
                                                        struct TaffyStyleDimension height);
