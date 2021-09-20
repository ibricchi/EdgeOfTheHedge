extends Area2D


var direction : Vector2 setget set_direction
var parent : Node 

enum type {
	home = 0,
	food = 1,
	enemy = 2,
}

var marktype = type.home

func _process(delta):
	if marktype == type.home:
		$Polygon2D.modulate = Color(1,0,0)
	if marktype == type.food:
		$Polygon2D.modulate = Color(0,0,1)
	if marktype == type.enemy:
		$Polygon2D.modulate = Color(0,1,0)


func _ready():
	$Timer.start(20)

func set_direction(dir):
	direction = dir

func _on_marker_body_entered(body):
	if body.is_in_group("ant") :
		if body.marker_follow_timer < 0 :
			if body.ant_priority == 3:
				body.desired_direction = - direction
				body.marker_follow_timer = 0.5
			if  body.ant_priority == 1 and marktype == type.food:
				body.desired_direction = direction
				body.marker_follow_timer = 0.5
			if body.ant_priority == 2 and marktype == type.enemy:
				body.desired_direction = direction
				body.marker_follow_timer = 0.5


func set_marker_type(type):
	marktype = type
	$Timer.start(30)

func _on_Timer_timeout():
	destroy_marker()
	
	
func destroy_marker():
	if parent != null:
		parent.markers_set.erase(self) # remove from ant that set it 
	get_parent().markers.erase(self)# remove from game
	get_parent().remove_child(self)
	queue_free()
