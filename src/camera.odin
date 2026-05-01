package main

import "core:math/linalg/glsl"

Camera :: struct {
	position: glsl.vec3,
	front:    glsl.vec3,
	up:       glsl.vec3,
	yaw:      f32,
	pitch:    f32,
	fov:      f32,
}

camera_init :: proc(pos: glsl.vec3) -> Camera {
	return Camera{
		position = pos,
		front    = {0.0, 0.0, -1.0},
		up       = {0.0, 1.0, 0.0},
		yaw      = -90.0,
		pitch    = 0.0,
		fov      = 45.0,
	}
}
