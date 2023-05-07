local x, y = 280, 280
local radius = 20
local speed = 120 -- velocidade da bola em pixels por segundo
local dx, dy = 0, 0 -- direção da bola
local money = false
local socialLife = false
local fun = false
local inMoney = false
local inSocialLife = false
local inFun = false
local moneyStatus = 100
local socialLifeStatus = 100
local funStatus = 100
local invest = false --verifica se o usuario quer investir
local spend = false --verifica se o usuario quer gastar
local moneyAreaEntered = false -- variável que indica se o círculo entrou na área do dinheiro e se a função investMoney() já foi chamada para essa área
--variaveis in servem para verificar se o player esta no local
--variaveis so com o nome servem para verificar se elas precisam ser atualizadas
--variaveis status armazenam o valor da barra
local casino = false -- variaveis para jogar no cassino
local inCasino = false
local casinoStatus = 100
local betTrue = false
local betFalse = false
local casinoAreaEntered = false

--essa função verifica a posição do player
function verifyPosition()
  if x > 0 and x < 200 and y > 0 and y < 100 then
    money = true
    inMoney = true
    if not moneyAreaEntered then
      moneyAreaEntered = true
      investMoney()
    end
  elseif x > 600 and x < 800 and y > 0 and y < 100 then
    socialLife = true
    inSocialLife = true
  elseif x > 0 and x < 200 and y > 500 and y < 600 then
    fun = true
    inFun = true
  elseif x > 600 and x < 800 and y > 500 and y < 600 then
    casino = true
    inCasino = true
    if not casinoAreaEntered then
      casinoAreaEntered = true
      playGame()
    end
  else 
    inMoney = false
    inSocialLife = false
    inFun = false
    inCasino = false
    moneyAreaEntered = false
    casinoAreaEntered = false
  end
end

function investMoney()
  if inMoney == true then
    local message = "Você deseja gastar ou fazer um depósito?"
    local buttons = {"Gastar", "Depositar"}
    local pressed = love.window.showMessageBox("Bem vindo ao banco!", message, buttons)
    if buttons[pressed] == "Depositar" then
      invest = true
    else
      spend = true  
    end
  end
end


--essa função verifica se uma das variáveis de status da barra precisa ser atualizada(só quando o player sai da área)
function updateStatus()
  if inMoney == false and money == true and invest == true then
    moneyStatus = moneyStatus + 10
    money = false
    invest = false
  elseif inMoney == false and money == true and spend == true then
    moneyStatus = moneyStatus - 10
    money = false
    spend = false
  end
  if inCasino == false and casino == true and betTrue == true then
    moneyStatus = moneyStatus + 10
    funStatus = funStatus + 10
    casino = false
    betTrue = false
  elseif inCasino == false and casino == true and betFalse == true then
    moneyStatus = moneyStatus - 10
    funStatus = funStatus + 10
    casino = false
    betFalse = false
  end
  if inSocialLife == false and socialLife == true then
    socialLifeStatus = socialLifeStatus - 10
    socialLife = false
  end
  if inFun == false and fun == true then
    funStatus = funStatus - 10
    fun = false
  end
end

--logica do cassino
function playGame()
  if inCasino == true then
    local message = "Você deseja jogar um jogo?"
    local buttons = {"Sim"}
    local pressed = love.window.showMessageBox("Bem vindo ao Cassino!", message, buttons)
    if buttons[pressed] == "Sim" then
      local message = "Aperte sair para sair do cassino"
      local buttons = {"Sair"}
      local number = math.random(1, 2)
      if 1 == number then
        love.window.showMessageBox("Parabéns, você ganhou!", message, buttons)
        betTrue = true
      else
        love.window.showMessageBox("Você perdeu!", message, buttons)
        betFalse = true
      end
    end
  end
end

function love.update(dt)
  verifyPosition()
  updateStatus()
  -- atualiza a posição da bola
  x = x + dx * speed * dt
  y = y + dy * speed * dt
  
  -- verifica se a bola atingiu as bordas da janela
  if x < radius then
    x = radius
  elseif x > love.graphics.getWidth() - radius then
    x = love.graphics.getWidth() - radius
  end
  if y < radius then
    y = radius
  elseif y > love.graphics.getHeight() - radius then
    y = love.graphics.getHeight() - radius
  end
end

function love.mousepressed(mx, my, button)
  -- calcula a direção da bola em relação ao clique do mouse
  local angle = math.atan2(my - y, mx - x)
  dx = math.cos(angle)
  dy = math.sin(angle)
end

function love.draw()
  -- barras 
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", 300, 0, moneyStatus, 10)
  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", 300, 20, socialLifeStatus, 10)
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", 300, 40, funStatus, 10)

  -- áreas que o usuario pode entrar
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, 200, 100)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 600, 0, 200, 100)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 500, 200, 100)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 600, 500, 200, 100)
  
  -- usuário
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", x, y, radius)
end
