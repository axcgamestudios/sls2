extends Control
var dgroups = []
var league
var groupsDone = false
var pgx = 0
var pgy = 0
var pgrp = 0
var but = null
var gogoGame = false
func _ready() :
	gogoGame = false
	but =$TextureRect/AcceptDialog.get_ok()
	but.text = "  ok!  "
	league = Global.tournament
	$TextureRect/PlayTie.grab_focus()
	dgroups =$TextureRect/Groups.get_children()
	$TextureRect/Label.text += str( league.year)
	initGroups()
	if league.cr > 2 :
		groupsDone = true
		league._knockoutStage()
		$TextureRect/PlayTie.text = "Knockout Stage..."
	match pgrp :
		2 , 3 :
			pgx = 853
		4 , 5 :
			pgy = 380
		6 , 7 :
			pgx = 853
			pgy = 380
	$TextureRect/Groups.rect_position.x = - pgx
	$TextureRect/Groups.rect_position.y = - pgy
	$Transition._wipeOn()
func initGroups() :
	for i in range( 0 , 8) :
		dgroups[ i]._initGroup( Global.tournament.groups[ i])
		if Global.tournament.groups[ i].playerteam > - 1 :
			pgrp = i
func _updateTable() :
	for i in range( 0 , 8) :
		dgroups[ i]._updateTable()
func _updateFixtures() :
	for i in range( 0 , 8) :
		dgroups[ i]._updateFixtures( Global.tournament.groups[ i])
func _on_PlayTie_pressed() :
	Global.isPenalties = false
	if Global.tType == 3 :
		Global.isT1Womens = true
		Global.isT2Womens = true
	if not gogoGame :
		gogoGame = true
		if not groupsDone :
			league._setupPlayerTie()
			if Global.tTeam == Global.tT1 :
				Global.p1human = true
				Global.p2human = false
			else :
				Global.p2human = true
				Global.p1human = false
			Global.team1 = Global.teamfiles[ Global.tT1]
			Global.team2 = Global.teamfiles[ Global.tT2]
			Global.doShootout = false
			Global._loadTeams( false , false)
			Global.toLoad = 1
			$Transition._wipeOff()
			Global.stadium = 3 - int( Global.t1.level)
			yield ($Transition/Tween , "tween_completed")
			var cbreak = PokiSDK.commercialBreak()
			if not cbreak :
				var _foo = get_tree().change_scene( "res://Scenes/Game.tscn")
		else :
			var _foo = get_tree().change_scene( "res://Scenes/CupViewer.tscn")
func _on_SaveButton_pressed() :
	league._saveState()
	$TextureRect/AcceptDialog.visible = true
func _on_BackButton_pressed() :
	$Transition._wipeOff()
	yield ($Transition/Tween , "tween_completed")
	var _foo = get_tree().change_scene( "res://Scenes/GlobalCupSelect.tscn")
