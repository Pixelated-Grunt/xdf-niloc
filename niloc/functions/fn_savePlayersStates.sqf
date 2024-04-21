#include "script_macros.hpp"
/*
 * Author: Pixelated_Grunt
 * Save data of all players
 *
 * Arguments:
 * 0: Save a single player instead of all <OBJECT> {default: objNull}
 *
 * Return Valuej:
 * Return number of player record saved <NUMBER>
 *
 * Example:
 * [] call XDF_fnc_savePlayersStates
 *
 * Public: No
**/


params [["_playerObj", objNull, [objNull]]];

private ["_allPlayers", "_count"];

_count = 0;
_allPlayers = ALL_PLAYERS;

if (!isNull _playerObj) then {
    _allPlayers = [_playerObj];
};

{
    private _playerHash = ["player", _x] call FUNCMAIN(prepUnitData);
    private _putOk = 0;

    _putOk = ["players", [_playerHash get "playerUID", toArray(_playerHash)]] call FUNCMAIN(putSection);
    if (_putOk > 0) then {
        _count = _count + 1;
    }
} forEach _allPlayers;

_count
