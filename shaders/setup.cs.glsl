#version 420
#extension GL_ARB_compute_shader : require
#extension GL_ARB_shader_image_load_store : require

/*
	Copyright 2020 Aeva Palecek

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

「interfaces」


const vec3 Vertices[6] = {
	vec3(-1.0, -1.0, 1.0),
	vec3( 1.0, -1.0, 1.0),
	vec3( 1.0,  1.0, 1.0),
	vec3(-1.0, -1.0, 1.0),
	vec3( 1.0,  1.0, 1.0),
	vec3(-1.0,  1.0, 1.0)
};


vec3 RotateX(const vec3 V, const float A)
{
	const float R = radians(A);
	const float S = sin(R);
	const float C = cos(R);
	return vec3(V.x, dot(V, vec3(0.0, C, -S)), dot(V, vec3(0.0, S, C)));
}


vec3 RotateY(const vec3 V, const float A)
{
	const float R = radians(A);
	const float S = sin(R);
	const float C = cos(R);
	return vec3(dot(V, vec3(C, 0.0, S)), V.y, dot(V, vec3(-S, 0.0, C)));
}


vec3 GetFace(const int Side, const int Half, const int Index)
{
	const int Offset = Half * 3 + Index;
	const vec3 Vertex = Vertices[Offset];
	if (Side == 0)
	{
		return RotateX(Vertex, 90.0);
	}
	else if (Side == 1)
	{
		return RotateX(Vertex, -90.0);
	}
	else if (Side == 2)
	{
		return RotateY(Vertex, 90.0);
	}
	else if (Side == 3)
	{
		return RotateY(Vertex, -90.0);
	}
	else if (Side == 4)
	{
		return RotateY(Vertex, 180.0);
	}
	else
	{
		return Vertex;
	}
}


layout(local_size_x = 6, local_size_y = 2, local_size_z = 1) in;
void main()
{
	const int Side = int(gl_GlobalInvocationID.x);
	const int Half = int(gl_GlobalInvocationID.y);

	const vec4 A = vec4(GetFace(Side, Half, 0), 1.0);
	const vec4 B = vec4(GetFace(Side, Half, 1), 1.0);
	const vec4 C = vec4(GetFace(Side, Half, 2), 1.0);

	const int Write = Side * 2 + Half;

	imageStore(Sphere0, ivec2(Write, 0),  A);
	imageStore(Sphere0, ivec2(Write, 1),  B);
	imageStore(Sphere0, ivec2(Write, 2),  C);
}
