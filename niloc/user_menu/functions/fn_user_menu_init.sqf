#include "..\script_component.hpp"
/*
 * Author: Pixelated_Grunt
 * Initiation of user interaction menu
 *
 * Arguments:
 * Nil
 *
 * Return Value:
 * Nil
 *
 * Example:
 * [] call NILOC_fnc_user_menu_init
 *
 * Public: No
**/


if !hasInterface exitWith {};

if (!isNil(QGVARMAIN(enable)) && {!QGVARMAIN(enable)}) exitWith {INFO("NiLOC is set to be disabled.")};

private _useMissionFramework = false;
private _accessItem = RETDEF(NILOC_accessItem, "ACE_SpraypaintRed");

// Check if XDF mission framework is enabled
if !isNil("XDF_MF_accessItems") then {
    if (QUOTE(PREFIX) in XDF_MF_accessItems) then {
        _accessItem = XDF_MF_accessItems get QUOTE(PREFIX);
        _useMissionFramework = true
    }
};

missionNamespace setVariable[QGVAR(useMissionFramework), _useMissionFramework];

if !_useMissionFramework then {
    [player, 1, ["ACE_SelfActions"], [
        QUOTE(ROOT_PREFIX),
        "D F",
        "a3\ui_f\data\igui\cfg\simpletasks\letters\x_ca.paa",
        {},
        { true }
    ] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToObject
};

[player, 1, ["ACE_SelfActions", QUOTE(ROOT_PREFIX)], [
    QUOTE(PREFIX),
    "NiLOC",
    "a3\ui_f_oldman\data\igui\cfg\holdactions\holdaction_sleep2_ca.paa",
    { call FUNCMAIN(guiOpenGUI) },
    { [_this#0, _this#2] call FUNCMAIN(checkAccessItem) },
    { [] call FUNCMAIN(addChildActions) },
    _accessItem
] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToObject