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


layout(local_size_x = 16, local_size_y = 1, local_size_z = 1) in;
void main()
{
	const int InIndex = int(gl_GlobalInvocationID.x) / 4;

	vec3 Triangle[3] = {
		imageLoad(Sphere2, ivec2(InIndex, 0)).xyz,
		imageLoad(Sphere2, ivec2(InIndex, 1)).xyz,
		imageLoad(Sphere2, ivec2(InIndex, 2)).xyz
	};

	vec3 Subtriangle[3];

	const int OutOffset = int(gl_GlobalInvocationID.x) % 4;
	if (OutOffset == 0)
	{
		Subtriangle[0] = Triangle[0];
		Subtriangle[1] = mix(Triangle[0], Triangle[1], 0.5);
		Subtriangle[2] = mix(Triangle[0], Triangle[2], 0.5);
	}
	else if (OutOffset == 1)
	{
		Subtriangle[0] = Triangle[1];
		Subtriangle[1] = mix(Triangle[1], Triangle[0], 0.5);
		Subtriangle[2] = mix(Triangle[1], Triangle[2], 0.5);
	}
	else if (OutOffset == 2)
	{
		Subtriangle[0] = Triangle[2];
		Subtriangle[1] = mix(Triangle[2], Triangle[1], 0.5);
		Subtriangle[2] = mix(Triangle[2], Triangle[0], 0.5);
	}
	else
	{
		Subtriangle[0] = mix(Triangle[0], Triangle[1], 0.5);
		Subtriangle[1] = mix(Triangle[1], Triangle[2], 0.5);
		Subtriangle[2] = mix(Triangle[2], Triangle[0], 0.5);
	}

	const int OutIndex = InIndex * 4 + OutOffset;
	for (int i=0; i<3; ++i)
	{
		imageStore(Sphere3, ivec2(OutIndex , i), vec4(Subtriangle[i], 1.0));
	}
}
