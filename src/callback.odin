package main

import "core:math"
import "core:math/linalg/glsl"
import gl "vendor:OpenGL"
import "vendor:glfw"

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width: i32, height: i32) {
	gl.Viewport(0, 0, width, height)
}

processInput :: proc "c" (window: glfw.WindowHandle) {
	if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
		glfw.SetWindowShouldClose(window, true)
	}

	cameraSpeed := f32(deltaTime * 2.5)
	if glfw.GetKey(window, glfw.KEY_W) == glfw.PRESS {
		cameraPos += cameraSpeed * cameraFront
	}
	if glfw.GetKey(window, glfw.KEY_S) == glfw.PRESS {
		cameraPos -= cameraSpeed * cameraFront
	}
	if glfw.GetKey(window, glfw.KEY_A) == glfw.PRESS {
		cameraPos -= glsl.normalize(glsl.cross(cameraFront, cameraUp)) * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_D) == glfw.PRESS {
		cameraPos += glsl.normalize(glsl.cross(cameraFront, cameraUp)) * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_SPACE) == glfw.PRESS {
		cameraPos += cameraUp * cameraSpeed
	}
	if glfw.GetKey(window, glfw.KEY_LEFT_SHIFT) == glfw.PRESS {
		cameraPos -= cameraUp * cameraSpeed
	}
}

mouse_callback :: proc "c" (window: glfw.WindowHandle, xposIn: f64, yposIn: f64) {
	xpos := f32(xposIn)
	ypos := f32(yposIn)

	if firstMouse {
		lastX = xpos
		lastY = ypos
		firstMouse = false
	}

	xoffset := xpos - lastX
	yoffset := lastY - ypos
	lastX = xpos
	lastY = ypos

	sensitivity: f32 = 0.1
	xoffset *= sensitivity
	yoffset *= sensitivity

	yaw += xoffset
	pitch += yoffset

	if pitch > 89 {
		pitch = 89
	}
	if pitch < -89 {
		pitch = -89
	}

	front := glsl.vec3 {
		math.cos(glsl.radians(yaw)) * math.cos(glsl.radians(pitch)),
		math.sin(glsl.radians(pitch)),
		math.sin(glsl.radians(yaw)) * glsl.cos(glsl.radians(pitch)),
	}
	cameraFront = glsl.normalize(front)
}

scroll_callback := proc "c" (window: glfw.WindowHandle, xoffset: f64, yoffset: f64) {
	fov -= f32(yoffset)
	if fov < 1 {
		fov = 1
	}
	if fov > 45 {
		fov = 45
	}
}
