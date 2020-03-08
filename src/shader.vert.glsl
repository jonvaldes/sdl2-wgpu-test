#version 450

layout(location = 0) out vec3 v_Color;

layout(set = 0, binding = 0) uniform Globals {
    vec2 u_FontSize;
    vec2 u_WindowSize;
};
    
struct Instance {
    vec2 position;
    vec2 dimensions;
    vec4 color; // Beware memory alignment of vec3!
};


layout(set = 0, binding = 1) buffer InstanceData {
	Instance [] u_instances;
};

void main() {

	int instanceId = gl_VertexIndex / 6; // Each instance will use 6 vertices, for 2 triangles
	Instance instance = u_instances[instanceId];

	// This is a bit of black magic, but it's generating the 0/1 pattern for each vertex, based on the vertex
	// ID. The way I figured it out is by looking at the zeroes and ones that need to be generated, and try to
	// find a simple formula to generate them. Also, keep rotating the vertices until you find one
	// configuration that's easy to generate

	/* Triangle configuration that I used:
	        
	       2|            4-----3
			|\             \  |
			| \             \ |
			|  \             \|
		   0-----1            |5
	*/

	float x = float(gl_VertexIndex % 2);
    float y = float( (gl_VertexIndex + 1) / 3 % 2);
	vec2 vertexPosition = vec2(x,y);

    vec2 gridPosition = instance.position + instance.dimensions * vertexPosition;
    gl_Position = vec4((gridPosition * u_FontSize) / (u_WindowSize * 2.0) - vec2(1.0, 1.0), 0.0, 1.0);

    v_Color = instance.color.rgb; 	// Right now we're discarding the alpha channel. We could pass it to the
    								// fragment shader instead
}
