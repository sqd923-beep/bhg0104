local DataStoreService = game:GetService("DataStoreService")
local MoneyStore = DataStoreService:GetDataStore("MoneyData")

-- 플레이어 입장
game.Players.PlayerAdded:Connect(function(player)
    -- leaderstats 생성
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local money = Instance.new("IntValue")
    money.Name = "Money"
    money.Parent = leaderstats

    -- 저장된 돈 불러오기
    local success, data = pcall(function()
        return MoneyStore:GetAsync(player.UserId)
    end)

    if success and data then
        money.Value = data
    else
        money.Value = 0
    end

    -- 1초마다 돈 증가
    task.spawn(function()
        while player.Parent do
            task.wait(1)
            money.Value += 1000
        end
    end)
end)

-- 플레이어 퇴장 시 저장
game.Players.PlayerRemoving:Connect(function(player)
    local money = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money")
    if money then
        pcall(function()
            MoneyStore:SetAsync(player.UserId, money.Value)
        end)
    end
end)

-- 서버 종료 시 저장 (중요)
game:BindToClose(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        local money = player.leaderstats:FindFirstChild("Money")
        if money then
            pcall(function()
                MoneyStore:SetAsync(player.UserId, money.Value)
            end)
        end
    end
end)
