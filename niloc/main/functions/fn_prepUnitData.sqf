#include "script_macros.hpp"
/*
 * Author: Pixelated_Grunt
 * Internal function to get data from a live unit
 *
 * Arguments:
 * 0: Type of unit i.e. player or AI unit <STRING> {default: "unit"}
 * 1: Unit to get data from <OBJECT>
 * 2: Optional player UID <STRING>
 * 3: Optional player's name <STRING>
 *
 * Return Value:
 * HashMap that contains unit data <HASHMAP>
 *
 * Example:
 * _unitHash = [player] call XDF_fnc_prepUnitData
 *
 * Public: No
**/


params [
    ["_type", "unit", [""]],
    ["_unit", objNull, [objNull]],
    ["_uid", "", [""]],
    ["_name", "", [""]]
];
private ["_statsToSave", "_unitHash"];

_statsToSave = [_type] call FUNCMAIN(returnStats);
_unitHash = createHashMap;

{
    private _stat = _x;

    switch (_stat) do {
        // Base stats
        case "location": { _unitHash set [_stat, (getPosASL _unit)] };
        case "loadout": { _unitHash set [_stat, (getUnitLoadout _unit)] };
        case "damage": {
            if HASACE3 then {
                _unitHash set [_stat, [_unit] call ace_medical_fnc_serializeState];
            } else {
                _unitHash set [_stat, damage _unit];
            };
        };
        case "vehicle": {
            private _vehicle = objectParent _unit;

            if (!isNull _vehicle) then {
                _unitHash set [_stat, [str _vehicle, getPosASL _vehicle]];
            };
        };
        // Player only stats
        case "playerName": {
            private "_playerName";

            _playerName = if (_name != "") then [{_name}, {getUserInfo(getPlayerID _unit) # 3}];
            _unitHash set [_stat, _playerName];
        };
        case "playerUid": {
            private "_playerUid";

            _playerUid = if (_uid != "") then [{_uid}, {getPlayerUID _unit}];
            _unitHash set [_stat, _playerUid];
        };
        case "rations": {
            private _hunger = _unit getVariable ["acex_field_rations_hunger", 0];
            private _thirst = _unit getVariable ["acex_field_rations_thirst", 0];

            _unitHash set [_stat, [_hunger, _thirst]];
        };
        case "captive": { _unitHash set [_stat, captive _unit] };
        // AI only stats
        case "objStr": { _unitHash set [_stat, str _unit] };
        case "formation": { _unitHash set [_stat, (formation _unit)] };
        case "behaviour": { _unitHash set [_stat, (behaviour _unit)] };
        case "type": { _unitHash set [_stat, (typeOf _unit)] };
        case "face": { _unitHash set [_stat, (face _unit)] };
        default { ERROR_2("No key (%1) defined for unit (%2).", _stat, _unit) };
    };
} forEach _statsToSave;

_unitHash