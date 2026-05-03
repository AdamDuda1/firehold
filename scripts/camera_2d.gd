extends Camera2D

@export var zoom_min: float = 0.5
@export var zoom_max: float = 2.0
@export var map_rect: Rect2 = Rect2(-500, -500, 500, 500)

var _touches: Dictionary = {}
var _last_pan_pos: Vector2 = Vector2.ZERO
var _last_pinch_distance: float = 0.0
var _is_pinching: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = event.position
			if _touches.size() == 1:
				_last_pan_pos = event.position
		else:
			_touches.erase(event.index)
			_is_pinching = false
			_last_pinch_distance = 0.0
			if _touches.size() == 1:
				_last_pan_pos = _touches.values()[0]

	if event is InputEventScreenDrag:
		_touches[event.index] = event.position

		if _touches.size() == 1 and not _is_pinching:
			var delta = event.position - _last_pan_pos
			position -= delta / zoom
			_last_pan_pos = event.position
			_clamp_position()

		elif _touches.size() == 2:
			_is_pinching = true
			var positions = _touches.values()
			var pos_a = positions[0]
			var pos_b = positions[1]

			var current_distance = pos_a.distance_to(pos_b)

			if _last_pinch_distance != 0.0:
				var zoom_factor = current_distance / _last_pinch_distance
				zoom = clamp(
					zoom * zoom_factor,
					Vector2(zoom_min, zoom_min),
					Vector2(zoom_max, zoom_max)
				)
				_clamp_position()

			_last_pinch_distance = current_distance

func _clamp_position() -> void:
	var half_screen = get_viewport_rect().size / 2.0 / zoom
	position.x = clamp(position.x, map_rect.position.x + half_screen.x, map_rect.end.x - half_screen.x)
	position.y = clamp(position.y, map_rect.position.y + half_screen.y, map_rect.end.y - half_screen.y)
