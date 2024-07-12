extends Line2D
@export var pos_string: String
@export var my_packed_array: Array[Vector2]

func _ready() -> void:
	var p_arrays: Array = await read_json_to_packed_array()
	var p_cliped_arrays: Array = await clip_my_packed_array()
	for i in p_cliped_arrays:
		add_line(i)


func add_line(p_points:PackedVector2Array):
	var p_line = Line2D.new()
	p_line.points = p_points
	add_child(p_line)


func clip_my_packed_array():
	var cliped_arrays: Array[Array] = [[]]
	var array_index: int = 0
	for i in my_packed_array.size():
		if i > 0 :
			var distance = my_packed_array[i].distance_squared_to(my_packed_array[i-1])
			if distance < 128.0:
				pass
			else:
				cliped_arrays.append([])
				array_index += 1
		cliped_arrays[array_index].append(my_packed_array[i])
	return cliped_arrays


func read_json_to_packed_array():
	my_packed_array = []
	var p_file = FileAccess.open("res://points.json",FileAccess.READ)
	if p_file == null:
		return
	var p_txt = p_file.get_as_text()
	var p_array = JSON.parse_string(p_txt)
	#(p_array as Array).erase(p_array[0])
	for i in p_array:
		for j in i:
			my_packed_array.append(Vector2(j[0], j[1]))
	return my_packed_array
