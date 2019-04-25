UNIT PlayGame;

Interface                                                                    
  uses GraphAbc,PAWN,LoadTextures,LoadMap;                                                              //Используемые модули
  
  const speed=12;                                                               //скорость персонажа по X
  
  var                                                                             //Переменные нужные для работы
   player:playerObj;
   lengthBonus,f,offsetX, offsetY,i,startX,startY:integer;
   zTime,time,dt:real;
   playANDpause,pointMushroom,test,background:picture;  
   exitGame,pause,dead,passed,twoJump,lORr:boolean;
   wts:char;
   whatTile:byte;
                                                                                //Предоопределение процедур и функций
Function Play(var mapName:string):boolean;                                      
procedure Start_Initialization;
procedure PauseGame; 
   
Implementation 

    procedure PauseGame;                                                        //Процедура паузы игры(так же руководство игры прогружает текстовый файл и выводит его на экран для пользователя) 
    var 
      f:text;
      textP: array of string;
      iterText:byte;
    begin
      iterText:=0;
      playANDpause.Load('Data\GameFiles\Level 1\Tiles\pause.png');
      Assign(f,'Data\GameFiles\Game.txt');
      Reset(f);
        while not (EoF(f)) do
        begin
        readln(f);
        iterText+=1;
        end;
        Reset(f);
        SetLength(textP,iterText);
        iterText:=0;
        while not (EoF(f)) do
        begin
        readln(f,textP[iterText]);
        iterText+=1;
        end;  
        close(f);
      while pause do begin  
        background.Draw(-600-offsetX,0);
        playANDpause.Draw(220,5,50,50);
        time:=milliseconds-dt;
        dt:=milliseconds;
        time/=60; 
        for var i:=0 to length(textP)-1 do       TextOut(20,50+(i*30),textP[i]);  
        Redraw;
      end;
      playANDpause.Load('Data\GameFiles\Level 1\Tiles\play.png'); 
    end;


    procedure Bonus(state:byte;x,y,w:integer);                                  //Процедура считает сколько нужно создать обьектов класса MoveObj для бонусных грибов(считает зарание длинну с прогрузкой карты) 
    var countBonusPoint,rX:integer;
    begin
      countBonusPoint:=random(3)+2;
        for var i:=lengthBonus+1 to lengthBonus+1+countBonusPoint do begin
          rX:=(random(w)+x);
          bonusObj[i]:=new moveObj('Data\GameFiles\Level 1\Tiles\TileMushroom1.png',10,rX,y+5,20,20);
          if state=4 then  bonusObj[i].movementY:=-20 else bonusObj[i].movementY:=0;
          if rX>(x+(w/2)) then  bonusObj[i].movementX:=((x+w div 2) mod 2)+1
          else  bonusObj[i].movementX:=-((x+w div 2) mod 2)-1;
      end;  
      lengthBonus+=countBonusPoint+1;
    end;
    
    procedure ForDead;                                                          //Процедура отнимает 1 жизнь у игрока и в случаи если они закончились устонавливает булевую переменную в значение Праввды (тоесть персонаж мертв)
    begin
      player.movementX:=0;
      player.movementY:=0;    
      if player.life<=1 then  begin dead:=True;  end
      else begin player.life-=1; player.x:=startX; player.y:=startY; end;

    end;
    
    procedure keydown(key:integer);                                       //ПРОЦЕДУРА НАЖАТИЯ КЛАВИШИ
    begin
      case key of
        vk_escape:  exitGame:=True;
        vk_f1: begin
          if pause then pause:=false else pause:=True;
        end;  
        vk_e:begin
          whatTile:=player.WhatTileNow(mapInteraction);
          if whatTile<>255 then begin
            if mapInteraction[whatTile].state=6 then begin
              startX:=round(mapInteraction[whatTile].x);startY:=round(mapInteraction[whatTile].y);
              mapInteraction[whatTile].state:=8;mapInteraction[whatTile].image:=new Picture('Data\GameFiles\Level 1\Tiles\TileSwitch2.png');
            end
            else if mapInteraction[whatTile].state=7 then passed:=True;
          end;  
        end;  
        vk_d:begin 
          player.movementX:=speed; 
          wts:='w';
          lORr:=true;
        end;
        vk_a:begin
          player.movementX:=-speed;
          wts:='w';
          lORr:=false;
        end;
        vk_space: begin  
            if  player.onGround then begin
              player.movementY:=-19;                                            //если пробела скорость по Y -10 для прыжка
              player.onGround:=false;
            end;                                                                        //КОНЕЦ ПРОЦЕДУРЫ НАЖАТИЯ КЛАВИШ 
        end;   
     end;
    end;
    
    
    Procedure keyup(key:integer);                                               //ПРОЦЕДУРА ОТЖАТИЯ КЛАВИШИ
    begin
      case key of
        vk_d:begin player.movementX:=0; wts:='s'; end;
        vk_a:begin player.movementX:=0; wts:='s' end;
      end;
    end;     
    
    procedure Start_Initialization;                                             //Процедура инициализации начальных параметров
    begin 
      Onkeydown+=keydown;                                                      //связываем процедуры Паскаля с нашими процедурами нажатия и
      Onkeyup+=keyup;     
      startX:=100; startY:=600; //Начальные кординаты персонажа
      dead:=False;   
      wts:='s';
      background:=picture.Create('Data\GameFiles\Level 1\background.png'); 
      player:=new PlayerObj('player',startX,startY-500,30,70);  
      pointMushroom:=picture.Create('Data\GameFiles\Level 1\Tiles\TileMushroom1.png');    
    end;   
    
  Procedure Animation;                                                           //ПРОЦЕДУРА анимеции персонажа 
  var 
    plMidX,plMidY:real;
  begin
      zTime+=time;

   

      for var q:=1 to lengthBonus do begin
       if bonusObj[q]<>nil then begin
          bonusOBJ[q].Update(mapLoaded,time,wts);
          bonusOBJ[q].image.Draw(round(bonusOBJ[q].x-offsetX),round(bonusOBJ[q].y),bonusOBJ[q].width,bonusOBJ[q].height);
          if bonusOBJ[q].onGround= true then bonusOBJ[q].movementX:=0;
        end;  
      end;
      player.Update(mapLoaded,time,wts);
      plMidX:=(player.x+((player.x+player.width)-player.x)/2);
      plMidY:=player.y+((player.y+player.height)-player.y)/2;
      
      for var z:=0 to length(mapLoadedMove)-1 do begin                          //Часть просчета столкновений движущихся обьектов с персонажом(и проверкой к чему относиться этот обьект)
      if ((mapLoadedMove[z].x-offsetX)>( player.x-offsetX-800)) and ((mapLoadedMove[z].x-offsetX)<( player.x-offsetX+800)) then begin
        if (mapLoadedMove[z].state<>5) then mapLoadedMove[z].MoveObj(time);  
        if (mapLoadedMove[z].state<> 4) then   mapLoadedMove[z].image.Draw(round(mapLoadedMove[z].x)-offsetX,round(mapLoadedMove[z].y),mapLoadedMove[z].width,mapLoadedMove[z].height)
        else begin var t:boolean;
          mapLoadedMove[z].Update(MapLoaded,time,wts);
          if mapLoadedMove[z].movementX>0 then t:=true else t:=false;         
          if mapLoadedMove[z].name='Data\GameFiles\Enemy\female\Walk (1).png' then playingSprite(walkSpriteEnemyF,zTime,mapLoadedMove[z].x-offsetX,mapLoadedMove[z].y-20,t)
          else playingSprite(walkSpriteEnemyM,zTime,mapLoadedMove[z].x-offsetX,mapLoadedMove[z].y-20,t);
        end;         
        if(mapLoadedMove[z].x+mapLoadedMove[z].width>player.x) and (mapLoadedMove[z].x<player.x+player.width) and (mapLoadedMove[z].y+mapLoadedMove[z].height-20>player.y) and (mapLoadedMove[z].y<player.y+player.height)and (mapLoadedMove[z].state<>5) then begin       
          if (plMidX<mapLoadedMove[z].x) and (plMidY>mapLoadedMove[z].y) and (plMidY<(mapLoadedMove[z].y+mapLoadedMove[z].height)) then begin
            if (mapLoadedMove[z].state=3) or (mapLoadedMove[z].state=4) then begin ForDead; Break; end;
            player.x:=mapLoadedMove[z].x-player.width;
          end  
          else if (plMidX>mapLoadedMove[z].x+mapLoadedMove[z].width) and (plMidY>mapLoadedMove[z].y) and (plMidY<(mapLoadedMove[z].y+mapLoadedMove[z].height)) then begin
          if (mapLoadedMove[z].state=3) or (mapLoadedMove[z].state=4) then begin ForDead; Break; end;
            player.x:=mapLoadedMove[z].x+mapLoadedMove[z].width;
          end          
          else if player.y<mapLoadedMove[z].y then begin 
            if not(player.onGround)then begin player.movementY:=0;player.onGround:=True;end;
            if (plMidY<mapLoadedMove[z].y)   then begin
               player.y:=mapLoadedMove[z].y-player.height;
               if mapLoadedMove[z].state=0 then begin Bonus(mapLoadedMove[z].state,round(mapLoadedMove[z].x),round(mapLoadedMove[z].y),mapLoadedMove[z].width);mapLoadedMove[z].state:=9 end;
               if (mapLoadedMove[z].state=4) then begin
                  Bonus(mapLoadedMove[z].state,round(mapLoadedMove[z].x),round(mapLoadedMove[z].y),mapLoadedMove[z].width);
                  mapLoadedMove[z].state:=5;mapLoadedMove[z].width:=50;mapLoadedMove[z].height:=50;
                  mapLoadedMove[z].image.Load('Data\GameFiles\Level 1\Tiles\TileStone.png');          
                  break 
               end;
               if (mapLoadedMove[z].state=3) then  begin ForDead;break; end;           
               player.movementY:=mapLoadedMove[z].movementY;
               if wts<>'w' then  player.movementX:=mapLoadedMove[z].movementX;
               player.onGround:=True;   
            end;
          end
          else if (plMidY> mapLoadedMove[z].y+mapLoadedMove[z].height-25) and (plMidX>mapLoadedMove[z].x) and(plMidX<mapLoadedMove[z].x+mapLoadedMove[z].width) and (mapLoadedMove[z].state<>0) then begin player.y:=mapLoadedMove[z].y+30; player.movementY:=1; player.onGround:=False; end;    //?????????
        end;  
      end;
      end;
      for var z:=0 to length(mapLoaded)-1 do begin        
        if ((mapLoaded[z].x-offsetX)>( player.x-offsetX-800)) and ((mapLoaded[z].x-offsetX)<( player.x-offsetX+800)) then mapLoaded[z].image.Draw(round(mapLoaded[z].x-offsetX),round(mapLoaded[z].y),mapLoaded[z].width,mapLoaded[z].height);
      end;     
      for var z:=0 to length(mapInteraction)-1 do mapInteraction[z].image.Draw(round(mapInteraction[z].x-offsetX),round(mapInteraction[z].y),mapInteraction[z].width,mapInteraction[z].height);
      if not(player.onGround) then playingSprite(jumpSprite,zTime,player.x-offsetX,player.y,lORr)                                       //Анимация созданных спрайтов
      else begin
        if (wts = 'w')  then playingSprite(walkSprite,zTime,player.x-offsetX,player.y,lORr);
        if not (wts ='w') and (player.onGround) then wts:='s';
        if wts = 's' then playingSprite(idleSprite,zTime,player.x-offsetX,player.y,lORr); 
        if wts = 'g' then test.Draw(round(player.x-offsetX),round(player.y+10),30,25);
      end; 
  end;
  
  
  
  
  Function Play(var mapName:string):boolean;                                                               //ПРОЦЕДУРА ПРОИГРИША УРОВНЯ 
  var f1,frameP,lifeP:picture;
  begin
    passed:=False;  pause:=False; exitGame:=False;
    startX:=100; startY:=600; //Начальные кординаты персонажа
    OpenMap(mapName);
    player.x:=startX;player.y:=startY;
    lengthBonus:=-1;                
    time:=milliseconds-dt;
    dt:=milliseconds;
    time/=60; 
    lifeP:=new Picture('Data\GameFiles\Level 1\Tiles\life.png');
    frameP:=new Picture('Data\GameFiles\Level 1\Tiles\frame.png');
    f1:=new Picture('Data\GameFiles\Level 1\Tiles\f1.png');
    playANDpause:=new Picture('Data\GameFiles\Level 1\Tiles\play.png');
    while (not(dead )) and (not (passed)) and not(exitGame)do
    begin

     if player.onGround then twoJump:=true;    
      time:=milliseconds-dt;
      dt:=milliseconds;
      time/=60;    
      offsetX:=round(player.x-window.Width/2);
      background.Draw(-600-offsetX,0);
      background.Draw(5800-offsetX,0);
      for var i:=1 to player.life do lifeP.Draw((40*i)-5,55,40,40); 
      if player.pointM<4 then pointMushroom.Draw(20,1,35,35) else for var i:=1 to 4 do pointMushroom.Draw(20+(5*i),2,30,30);
      SetFontSize(20);
      TextOut(75,2,player.pointM); 
      frameP.Draw(0,0,200,100);  
      f1.Draw(220,60,200,30);
      playANDpause.Draw(220,5,50,50);
      Animation;
      


     player.ColForTake(bonusOBJ,wts,time);
     if player.y>1400 then ForDead;
     Redraw;   
     sleep(5);
   
   if pause then PauseGame;
   end;
    if dead then PlayingDeadSprite;
    if passed then Play:=True
    else Play:=False;
  end;
  
begin                                                                        //MAIN Функция

end.                                                                            //Конец MAIN функции