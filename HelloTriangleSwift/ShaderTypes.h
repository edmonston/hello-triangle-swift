//
//  ShaderTypes.h
//  HelloTriangleSwift
//
//  Created by Peter Edmonston on 10/7/18.
//  Copyright © 2018 com.peteredmonston. All rights reserved.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
typedef enum VertexInputIndex
{
    VertexInputIndexVertices     = 0,
    VertexInputIndexViewportSize = 1,
} VertexInputIndex;

//  This structure defines the layout of each vertex in the array of vertices set as an input to our
//    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
//    we can be sure that the layout of the vertex array in our C code matches the layout that
//    our .metal vertex shader expects
typedef struct
{
    // Positions in pixel space
    // (e.g. a value of 100 indicates 100 pixels from the center)
    vector_float2 position;

    // Floating-point RGBA colors
    vector_float4 color;
} Vertex;

#endif
