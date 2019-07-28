/**
*  fn_droneControl
*
*  Spawns a controlable drone for 1 minute
*
*  Domain: Server
**/
//params ["_player", "_targetPos"];


_player = _this select 0;
_uavSpawnPos = [_player, 1500, 1550, 0, 1] call BIS_fnc_findSafePos;
_dirToPlayer = _uavSpawnPos getDir _player;
_playerPos = getPos _player;

_player addweapon "B_UavTerminal";
_player connectTerminalToUAV objNull;
//_drone = [[_uavSpawnPos select 0, _uavSpawnPos select 1, (_playerPos select 2) + 500], _dirToPlayer + 35, "B_UAV_02_F", WEST] call BIS_fnc_spawnVehicle;
_drone = [[_uavSpawnPos select 0, _uavSpawnPos select 1, (_playerPos select 2) + 500], _dirToPlayer + 35, "B_T_VTOL_01_armed_F", WEST] call BIS_fnc_spawnVehicle;

_supportUav = _drone select 0;
bigBoy = _supportUav;
_uavGroup = _drone select 2;
{_x disableAI 'AUTOCOMBAT'} forEach (units _uavGroup);
(leader _uavGroup) setCaptive true;
_supportUav disableTIEquipment true;
mainZeus addCuratorEditableObjects [[_supportUav], true];

_bulwarkPos = position bulwarkBox;
_loiterWP = (_uavGroup) addWaypoint [[_bulwarkPos select 0, _bulwarkPos select 1, (_bulwarkPos select 2) + 500], 0];
_loiterWP setWaypointType "LOITER";
_loiterWP setWaypointLoiterType "CIRCLE_L";
_loiterWP setWaypointLoiterRadius 600;
_loiterWP setWaypointCombatMode "BLUE";
_uavGroup setCurrentWaypoint _loiterWP;

daMan = ((crew _supportUav) select 3);

sleep 1;
_bool = _player connectTerminalToUAV _supportUav;
_player remoteControl daMan ;
gunner _supportUav switchCamera "Internal";
_supportUav setVehicleLock "LOCKED";
_supportUav flyInHeight 250;
 [_supportUav] spawn {
 _supportUav = _this select 0;
 sleep 5;
 //waitUntil {((UAVControl daMan) select 1 == '' ) || !(alive player)};
 waitUntil { sleep 5;(cameraon != _supportUav ) || !(alive player) || ((lifeState player) == "INCAPACITATED") || !(alive _supportUav)}; 

 objnull remotecontrol (daMan ); 
 player switchCamera 'internal';
 _supportUav flyInHeight 5000;
 sleep 60;
 _supportUav setDamage 1;
 };
sleep 600;
if (alive _supportUav) then {
	objnull remotecontrol (daMan ); 
	player switchCamera 'internal';
	_supportUav flyInHeight 5000;
	sleep 60;
  _supportUav setDamage 1;
};
