package main

import "vendor:glfw"

SCR_WIDTH :: 800
SCR_HEIGHT :: 600

AppState :: struct {
	camera:     Camera,
	deltaTime:  f32,
	lastFrame:  f32,
	firstMouse: bool,
	lastX:      f32,
	lastY:      f32,
}

app_update :: proc(window: glfw.WindowHandle, state: ^AppState) {
	currentFrame := f32(glfw.GetTime())
	state.deltaTime = currentFrame - state.lastFrame
	state.lastFrame = currentFrame

	processInput(window, state)
}
