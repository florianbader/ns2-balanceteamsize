// ================ Balance Team Sizes =================
//
// lua\BalanceTeamSizeConfig.lua
//
//    Idea by: Savant
//    Code by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/ConfigFileUtility.lua")

local configFileName = "BalanceTeamSizeConfig.json"

local defaultConfig = {
    team_advantage = 1,
    marine_team_size_advantage = 1,
    alien_team_size_advantage = 0,
}    

WriteDefaultConfigFile(configFileName, defaultConfig)

local config = LoadConfigFile(configFileName) or defaultConfig

kBalanceTeamSizeTeamAdvantage = config.team_advantage or defaultConfig.team_advantage
kBalanceTeamSizeMarineTeamSizeAdvantage = config.marine_team_size_advantage or defaultConfig.marine_team_size_advantage
kBalanceTeamSizeAlienTeamSizeAdvantage = config.alien_team_size_advantage or defaultConfig.alien_team_size_advantage

kBalanceTeamSizeAutoTeamBalance = Server.GetConfigSetting("auto_team_balance")
Server.SetConfigSetting("auto_team_balance", { enabled_on_unbalance_amount = 999 })