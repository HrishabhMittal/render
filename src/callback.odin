package main

import "core:math"
import "core:math/linalg/glsl"
import gl "vendor:OpenGL"
import "vendor:glfw"

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width: i32, height: i32) {
	gl.Viewport(0, 0, width, height)
}

processInput :: proc(window: glfw.WindowHandle, state: ^AppState) {
	if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
		glfw.SetWindowShouldClose(window, true)
	}

	cameraSpeed := f32(state.deltaTime * 2.5)

	if glfw.GetKey(window, glfw.KEY_W) == glfw.PRESS {
		state.camera.position += cameraSpeed * state.camera.front
	}
	if glfw.GetKey(window, glfw.KEY_S) == glfw.PRESS {
		state.camera.position -= cameraSpeed * state.camera.front
	}
	if glfw.GetKey(window, glfw.KEY_A) == glfw.PRESS {
		state.camera.position -=
			glsl.normalize(glsl.cross(state.camera.front, state.camera.up)) * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_D) == glfw.PRESS {
		state.camera.position +=
			glsl.normalize(glsl.cross(state.camera.front, state.camera.up)) * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_SPACE) == glfw.PRESS {
		state.camera.position += state.camera.up * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_LEFT_SHIFT) == glfw.PRESS {
		state.camera.position -= state.camera.up * cameraSpeed
	}
}

mouse_callback :: proc "c" (window: glfw.WindowHandle, xposIn: f64, yposIn: f64) {
	state := cast(^AppState)glfw.GetWindowUserPointer(window)
	if state == nil do return

	xpos := f32(xposIn)
	ypos := f32(yposIn)

	if state.firstMouse {
		state.lastX = xpos
		state.lastY = ypos
		state.firstMouse = false
	}

	xoffset := xpos - state.lastX
	yoffset := state.lastY - ypos
	state.lastX = xpos
	state.lastY = ypos

	sensitivity: f32 = 0.1
	xoffset *= sensitivity
	yoffset *= sensitivity

	state.camera.yaw += xoffset
	state.camera.pitch += yoffset

	if state.camera.pitch > 89.0 {
		state.camera.pitch = 89.0
	}
	if state.camera.pitch < -89.0 {
		state.camera.pitch = -89.0
	}

	front: glsl.vec3
	front.x = math.cos(glsl.radians(state.camera.yaw)) * math.cos(glsl.radians(state.camera.pitch))
	front.y = math.sin(glsl.radians(state.camera.pitch))
	front.z = math.sin(glsl.radians(state.camera.yaw)) * math.cos(glsl.radians(state.camera.pitch))
	state.camera.front = glsl.normalize(front)
}

scroll_callback :: proc "c" (window: glfw.WindowHandle, xoffset: f64, yoffset: f64) {
	state := cast(^AppState)glfw.GetWindowUserPointer(window)
	if state == nil do return

	state.camera.fov -= f32(yoffset)
	if state.camera.fov < 1.0 {
		state.camera.fov = 1.0
	}
	if state.camera.fov > 45.0 {
		state.camera.fov = 45.0
	}
}
