extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera: Camera2D = $Camera2D

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		if $Camera2D._is_pinching or $Camera2D._touches.size() > 1:
			return

		var world_pos = get_global_mouse_position()
		var cell = tile_map_layer.local_to_map(world_pos)
		_on_cell_tapped(cell)

func _on_cell_tapped(cell: Vector2i) -> void:
	print("Tapped cell: ", cell)
