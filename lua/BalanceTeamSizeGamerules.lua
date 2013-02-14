// ================ Balance Team Sizes =================
//
// lua\BalanceTeamSizeGamerules.lua
//
//    Idea by: Savant
//    Code by: Rio (rio@myrio.de)
//
// =====================================================

Script.Load("lua/NS2Gamerules.lua")

if (Server) then
    function NS2Gamerules:GetCanJoinTeamNumber(teamNumber)
        local team1Players = self.team1:GetNumPlayers()
        local team2Players = self.team2:GetNumPlayers()
        
        if (kBalanceTeamSizeTeamAdvantage == 1) then
            if (teamNumber == 2) then
                // If there are no players in the opposite team, allow the player to join
                if (team1Players == 0) then
                    return true
                end
    
                return team2Players + kBalanceTeamSizeMarineTeamSizeAdvantage + 1 <= team1Players
            end 
        else
            if (teamNumber == 1) then
                // If there are no players in the opposite team, allow the player to join
                if (team2Players == 0) then
                    return true
                end
                
                return team1Players + kBalanceTeamSizeAlienTeamSizeAdvantage + 1 <= team2Players
            end             
        end
        
        return true
    end
    
    local ns2GamerulesOnUpdate = NS2Gamerules.OnUpdate
    function NS2Gamerules:OnUpdate(timePassed)
        ns2GamerulesOnUpdate(self, timePassed)
        
        if (self:GetMapLoaded()) then            
            self:UpdateAutoTeamBalance(timePassed)
        end    
    end
    
    function NS2Gamerules:UpdateAutoTeamBalance(dt)    
        local wasDisabled = false
        
        // Check if auto-team balance should be enabled or disabled.
        local autoTeamBalance = kBalanceTeamSizeAutoTeamBalance
        if autoTeamBalance then
        
            local enabledOnUnbalanceAmount = autoTeamBalance.enabled_on_unbalance_amount or 2
            // Prevent the unbalance amount from being 0 or less.
            enabledOnUnbalanceAmount = enabledOnUnbalanceAmount > 0 and enabledOnUnbalanceAmount or 2
            local enabledAfterSeconds = autoTeamBalance.enabled_after_seconds or 10
            
            local team1Players = self.team1:GetNumPlayers()
            if (kBalanceTeamSizeTeamAdvantage == 1) then team1Players = team1Players - kBalanceTeamSizeMarineTeamSizeAdvantage end
            
            local team2Players = self.team2:GetNumPlayers()
            if (kBalanceTeamSizeTeamAdvantage == 2) then team2Players = team2Players - kBalanceTeamSizeAlienTeamSizeAdvantage end
            
            local unbalancedAmount = math.abs(team1Players - team2Players)
            if unbalancedAmount >= enabledOnUnbalanceAmount then
            
                if not self.autoTeamBalanceEnabled then
                
                    self.teamsUnbalancedTime = self.teamsUnbalancedTime or 0
                    self.teamsUnbalancedTime = self.teamsUnbalancedTime + dt
                    
                    if self.teamsUnbalancedTime >= enabledAfterSeconds then
                    
                        self.autoTeamBalanceEnabled = true
                        if team1Players > team2Players then
                            self.team1:SetAutoTeamBalanceEnabled(true, unbalancedAmount)
                        else
                            self.team2:SetAutoTeamBalanceEnabled(true, unbalancedAmount)
                        end
                        
                        SendTeamMessage(self.team1, kTeamMessageTypes.TeamsUnbalanced)
                        SendTeamMessage(self.team2, kTeamMessageTypes.TeamsUnbalanced)
                        //Print("Auto-team balance enabled")
                        
                        TEST_EVENT("Auto-team balance enabled")
                        
                    end
                    
                end
                
            // The autobalance system itself has turned itself off.
            elseif self.autoTeamBalanceEnabled then
                wasDisabled = true
            end
            
        // The autobalance system was turned off by the admin.
        elseif self.autoTeamBalanceEnabled then
            wasDisabled = true
        end
        
        if wasDisabled then
        
            self.team1:SetAutoTeamBalanceEnabled(false)
            self.team2:SetAutoTeamBalanceEnabled(false)
            self.teamsUnbalancedTime = 0
            self.autoTeamBalanceEnabled = false
            SendTeamMessage(self.team1, kTeamMessageTypes.TeamsBalanced)
            SendTeamMessage(self.team2, kTeamMessageTypes.TeamsBalanced)
            //Print("Auto-team balance disabled")
            
            TEST_EVENT("Auto-team balance disabled")
            
        end        
    end
end