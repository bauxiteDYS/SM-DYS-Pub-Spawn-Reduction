#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <sdktools>

#define DEBUG false

public Plugin myinfo = {
	name = "Dys Pub Spawn reduction",
	description = "Reduces spawn time for pubs when there are over 12 players",
	author = "bauxite",
	version = "0.1.0",
	url = "",
};

public void OnPluginStart()
{	
	Handle gd = LoadGameConfigFile("dystopia/spawntime");
	if (gd == INVALID_HANDLE)
	{
		SetFailState("Failed to load GameData");
	}
	DynamicDetour dd = DynamicDetour.FromConf(gd, "Fn_AddSpawnTime");
	if (!dd)
	{
		SetFailState("Failed to create dynamic detour");
	}
	if (!dd.Enable(Hook_Pre, HookPre_AddSpawnTime))
	{
		SetFailState("Failed to detour");
	}
	delete dd;
}

MRESReturn HookPre_AddSpawnTime(int pThis, DHookParam hParams)
{
	float spawnTime = hParams.Get(1);
	int players = GetTeamClientCount(2) + GetTeamClientCount(3);
	
	if(players < 13 || spawnTime == 15.0 || spawnTime == 5.0 || spawnTime < 3.0)
	{
		return MRES_Ignored;
	}
	
	#if DEBUG
	PrintToChatAll("add spawn - %f", spawnTime);
	#endif

	float newSpawnTime = spawnTime - ((spawnTime * 0.5) * (players / 32.0));
	hParams.Set(1, newSpawnTime);
	
	#if DEBUG
	PrintToChatAll("players - %d, new spawn - %f", players, newSpawnTime);
	#endif
	
	return MRES_ChangedHandled;
}
