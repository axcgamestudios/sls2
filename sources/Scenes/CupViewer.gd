extends Control
var but = null
var ties = []
var gogoGame = false
func _ready() :
	gogoGame = false
	but =$AcceptDialog.get_ok()
	but.text = "  ok!  "
	var tc = load( "res://Scenes/Tie.tscn")
	for i in range( 0 , 4) :
		var t = tc.instance()
		ties.append( t)
		$ColorRect/TieGroup.add_child( t)
		t.rect_position.y = 180 + 200 * i
		t._setTie( "----" , "----" , 0 , 0 , false , false)
	for i in range( 0 , 4) :
		var t = tc.instance()
		ties.append( t)
		$ColorRect/TieGroup.add_child( t)
		t._setTie( "----" , "----" , 0 , 0 , false , false)
		t.rect_position.y = 180 + 200 * i
		t.rect_position.x = 1920 - 340
	for i in range( 0 , 2) :
		var t = tc.instance()
		ties.append( t)
		$ColorRect/TieGroup.add_child( t)
		t.rect_position.y = 280 + 400 * i
		t.rect_position.x = 350
		t._setTie( "----" , "----" , 0 , 0 , false , false)
	for i in range( 0 , 2) :
		var t = tc.instance()
		ties.append( t)
		$ColorRect/TieGroup.add_child( t)
		t.rect_position.y = 280 + 400 * i
		t.rect_position.x = 960 + 270
		t._setTie( "----" , "----" , 0 , 0 , false , false)
	var t = tc.instance()
	ties.append( t)
	$ColorRect/TieGroup.add_child( t)
	t.rect_position.y = 480
	t.rect_position.x = 560
	t._setTie( "----" , "----" , 0 , 0 , false , false)
	t = tc.instance()
	ties.append( t)
	$ColorRect/TieGroup.add_child( t)
	t.rect_position.y = 480
	t.rect_position.x = 1060
	t._setTie( "----" , "----" , 0 , 0 , false , false)
	t = tc.instance()
	ties.append( t)
	$ColorRect/TieGroup.add_child( t)
	t.rect_position.y = 700
	t.rect_position.x = 780
	t.rect_scale.x = 1.1
	t.rect_scale.y = 1.1
	t._setTie( "----" , "----" , 0 , 0 , false , false)
	_populateTies()
	$Transition._wipeOn()
	$ColorRect/PlayButton.grab_focus()
	initCupView()
func initCupView() :
	$ColorRect/Title.text = Global.tournament.tourneyName
func _populateTies() :
	var t = 0
	for i in range( 0 , 8) :
		var t1p = false
		var t2p = false
		var t1 = Global.tournament.balls[ t]
		var t2 = Global.tournament.balls[ t + 1]
		if t1 == Global.tTeam :
			t1p = true
		if t2 == Global.tTeam :
			t2p = true
		var s1 = Global.tournament.cround[ i].x
		var s2 = Global.tournament.cround[ i].y
		ties[ i]._setTie( Global.teams[ t1].teamname , Global.teams[ t2].teamname , s1 , s2 , t1p , t2p)
		t += 2
	if Global.tournament.roundp > 0 :
		t = 16
		for i in range( 8 , 12) :
			var t1p = false
			var t2p = false
			var t1 = Global.tournament.balls[ t]
			var t2 = Global.tournament.balls[ t + 1]
			if t1 == Global.tTeam :
				t1p = true
			if t2 == Global.tTeam :
				t2p = true
			var s1 = Global.tournament.cround[ i].x
			var s2 = Global.tournament.cround[ i].y
			ties[ i]._setTie( Global.teams[ t1].teamname , Global.teams[ t2].teamname , s1 , s2 , t1p , t2p)
			t += 2
	if Global.tournament.roundp > 1 :
		t = 24
		for i in range( 12 , 14) :
			var t1p = false
			var t2p = false
			var t1 = Global.tournament.balls[ t]
			var t2 = Global.tournament.balls[ t + 1]
			if t1 == Global.tTeam :
				t1p = true
			if t2 == Global.tTeam :
				t2p = true
			var s1 = Global.tournament.cround[ i].x
			var s2 = Global.tournament.cround[ i].y
			ties[ i]._setTie( Global.teams[ t1].teamname , Global.teams[ t2].teamname , s1 , s2 , t1p , t2p)
			t += 2
	if Global.tournament.roundp > 2 :
		t = 28
		var t1p = false
		var t2p = false
		var t1 = Global.tournament.balls[ t]
		var t2 = Global.tournament.balls[ t + 1]
		if t1 == Global.tTeam :
			t1p = true
		if t2 == Global.tTeam :
			t2p = true
		var s1 = Global.tournament.cround[ 14].x
		var s2 = Global.tournament.cround[ 14].y
		ties[ 14]._setTie( Global.teams[ t1].teamname , Global.teams[ t2].teamname , s1 , s2 , t1p , t2p)
func _updateTies() :
	pass
func _on_Button_pressed() :
	if not gogoGame :
		gogoGame = true
		var t = 0
		var teamAlive = false
		var s = 0
		var e = 8
		Global.final = false
		match Global.tournament.roundp :
			1 :
				s = 8
				e = 12
				t = 16
			2 :
				s = 12
				e = 14
				t = 24
			3 :
				s = 14
				e = 15
				t = 28
				Global.final = true
		for i in range( s , e) :
			var t1 = Global.tournament.balls[ t]
			var t2 = Global.tournament.balls[ t + 1]
			if t1 == Global.tTeam or t2 == Global.tTeam :
				teamAlive = true
				Global.tournament.playertie = i
				if t1 == Global.tTeam :
					Global.p1human = true
					Global.p2human = false
				else :
					Global.p2human = true
					Global.p1human = false
				Global.team1 = Global.teamfiles[ t1]
				Global.team2 = Global.teamfiles[ t2]
				Global.doShootout = true
				Global._loadTeams( false , false)
				Global.toLoad = 1
				Global.stadium = 3 - int( Global.t1.level)
				$Transition._wipeOff()
				yield ($Transition/Tween , "tween_completed")
				var cbreak = PokiSDK.commercialBreak()
				if not cbreak :
					var _foo = get_tree().change_scene( "res://Scenes/Game.tscn")
			t += 2
		if not teamAlive :
			Global.tournament._gamePlayed( Vector2.ZERO)
			_populateTies()
			if Global.tournament.roundp == 4 :
				$ColorRect/PlayButton.disabled = true
			yield ( get_tree().create_timer( 0.5) , "timeout")
			gogoGame = false
func _on_BackButton_pressed() :
	$Transition._wipeOff()
	yield ($Transition/Tween , "tween_completed")
	var _foo = get_tree().change_scene( "res://Scenes/Menu.tscn")
func _on_SaveButton_pressed() :
	Global.tournament._saveState()
	$AcceptDialog.visible = true
	but.grab_focus()
func _on_AcceptDialog_confirmed() :
	$ColorRect/PlayButton.grab_focus()
