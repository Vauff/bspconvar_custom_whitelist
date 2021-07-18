#include <sourcemod>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "BSP ConVar Custom Whitelist",
	author = "Vauff",
	description = "Changes the file that CS:GO reads the BSP cvar whitelist from",
	version = "1.0.2",
	url = "https://github.com/Vauff/bspconvar_custom_whitelist"
};

Handle g_hIsWhiteListedCmd;
KeyValues g_kvWhitelist;

char g_sMapName[PLATFORM_MAX_PATH];

public void OnPluginStart()
{
	if (GetEngineVersion() != Engine_CSGO)
		SetFailState("This plugin only runs on CS:GO!");

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "gamedata/bspconvar_custom_whitelist.games.txt");

	if (!FileExists(path))
		SetFailState("Can't find bspconvar_custom_whitelist.games.txt gamedata");

	Handle gameData = LoadGameConfigFile("bspconvar_custom_whitelist.games");
	
	if (gameData == INVALID_HANDLE)
		SetFailState("Can't find bspconvar_custom_whitelist.games.txt gamedata");

	g_hIsWhiteListedCmd = DHookCreateFromConf(gameData, "IsWhiteListedCmd");
	CloseHandle(gameData);

	if (!g_hIsWhiteListedCmd)
		SetFailState("Failed to setup detour for IsWhiteListedCmd");

	if (!DHookEnableDetour(g_hIsWhiteListedCmd, false, Detour_IsWhiteListedCmd))
		SetFailState("Failed to detour IsWhiteListedCmd");
}

public void OnMapStart()
{
	if (g_kvWhitelist != null)
		CloseHandle(g_kvWhitelist);

	g_kvWhitelist = new KeyValues("convars");

	if (!g_kvWhitelist.ImportFromFile("bspconvar_custom_whitelist.txt"))
		SetFailState("Can't find bspconvar_custom_whitelist.txt, make sure you've made a copy of the default whitelist using this filename");
	
	GetCurrentMap(g_sMapName, sizeof(g_sMapName));
}

public MRESReturn Detour_IsWhiteListedCmd(DHookReturn hReturn, DHookParam hParams)
{
	char command[128];
	DHookGetParamString(hParams, 1, command, sizeof(command));
	
	if (g_kvWhitelist.GetNum(command) == 1)
		DHookSetReturn(hReturn, true);
	else if (IsMapWhitelistPresent(command))
		DHookSetReturn(hReturn, true);
	else
		DHookSetReturn(hReturn, false);

	return MRES_Supercede;
}

bool IsMapWhitelistPresent(const char[] convar)
{
	if (g_kvWhitelist.JumpToKey(g_sMapName))
	{
		if (g_kvWhitelist.GetNum(convar) == 1) 
		{
			g_kvWhitelist.Rewind();
			return true;
		}
	}

	g_kvWhitelist.Rewind();
	return false;
}