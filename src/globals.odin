package main

import "core:math/linalg/glsl"

SCR_WIDTH :: 800
SCR_HEIGHT :: 600

cameraPos := glsl.vec3{0, 0, 3}
cameraFront := glsl.vec3{0, 0, -1}
cameraUp := glsl.vec3{0, 1, 0}

firstMouse := true
yaw: f32 = -90
pitch: f32 = 0
lastX: f32 = 800 / 2
lastY: f32 = 600 / 2
fov: f32 = 45

deltaTime: f32 = 0
lastFrame: f32 = 0
