package main

import "core:fmt"
import gl "vendor:OpenGL"
import stbi "vendor:stb/image"

load_texture :: proc(filepath: cstring, use_rgba: bool = false) -> u32 {
	texture_id: u32
	gl.GenTextures(1, &texture_id)
	gl.BindTexture(gl.TEXTURE_2D, texture_id)

	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

	width, height, nrChannels: i32
	stbi.set_flip_vertically_on_load(1)
	data := stbi.load(filepath, &width, &height, &nrChannels, 0)

	if data != nil {
		format: u32 = use_rgba ? gl.RGBA : gl.RGB
		gl.TexImage2D(
			gl.TEXTURE_2D,
			0,
			i32(format),
			width,
			height,
			0,
			format,
			gl.UNSIGNED_BYTE,
			data,
		)
		gl.GenerateMipmap(gl.TEXTURE_2D)
		stbi.image_free(data)
	} else {
		fmt.println("Failed to load texture:", filepath)
	}

	return texture_id
}
