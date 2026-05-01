package main

import gl "vendor:OpenGL"
import "vendor:glfw"

main :: proc() {
	window := createWindow()
	defer glfw.Terminate()
	glfw.MakeContextCurrent(window)

	gl.load_up_to(3, 3, glfw.gl_set_proc_address)

	app_state := AppState {
		camera     = camera_init({0.0, 0.0, 3.0}),
		firstMouse = true,
		lastX      = f32(SCR_WIDTH) / 2.0,
		lastY      = f32(SCR_HEIGHT) / 2.0,
	}
	glfw.SetWindowUserPointer(window, &app_state)
	setupCallbacks(window)

	gl.Viewport(0, 0, SCR_WIDTH, SCR_HEIGHT)
	glfw.SetInputMode(window, glfw.CURSOR, glfw.CURSOR_DISABLED)
	gl.Enable(gl.DEPTH_TEST)

	renderer := renderer_init()
	defer renderer_destroy(&renderer)

	for !glfw.WindowShouldClose(window) {
		app_update(window, &app_state)
		renderer_draw(&renderer, &app_state)

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}

}
