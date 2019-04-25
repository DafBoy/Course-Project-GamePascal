UNIT LoadTextures;

Interface  
  Uses GraphABC; 
   type     
    Sprite=Array of picture;                                                    //Переменная Спрайта (Массив картинок)
    
    Const N = 256;
    
  var                                                                          //Наши спрайты
    walkSprite,walkSpriteEnemyF,walkSpriteEnemyM:Sprite;
    jumpSprite:Sprite;
    idleSprite:Sprite;
    deadSprite:Sprite;
    
procedure DogOrCat(var name:string);    
procedure PlayingSprite(var current:sprite;slide,x,y:real;LR:boolean);
procedure PlayingDeadSprite; 

Implementation 


  
  procedure DogOrCat(var name:string);                                           //создаемт спрайты в зависимости от выбранного персонажа
  begin
    for var i:=0 to 9 do begin
      walkSprite[i]:=picture.Create('Data\Players\'+name+'\Walk ('+(i+1)+').png');
      jumpSprite[i]:=picture.Create('Data\Players\'+name+'\Jump ('+(i+1)+').png');
      idleSprite[i]:=picture.Create('Data\Players\'+name+'\Idle ('+(i+1)+').png');
      deadSprite[i]:=picture.Create('Data\Players\'+name+'\Dead ('+(i+1)+').png');
    end;  
  end;
  
  procedure PlayingSprite(var current:sprite;slide,x,y:real;LR:boolean);       //ПРОЦЕДУРА ОТРИСОВКИ ВСЕХ СПРАЙТОВ
  var i:integer;
  begin
    i:=round(slide) mod length(current);
    if LR then  current[i].Draw(round(x)-18,round(y),70,70)
    else  current[i].Draw(round(x)+45,round(y),-70,70);
  end;
  
  
  procedure PlayingDeadSprite;                                                  //Процедура проигрыша смерти
  var gOver:picture;
  begin
    gOver:= new Picture('Data\GameFiles\Level 1\Tiles\Game over1.png');
    for var i:=0 to 9 do begin  
      Window.Clear(clBlack);SetFontSize(100);gOver.Draw(0,0);deadSprite[i].Draw(500,300,300,300);Sleep(300);Redraw;
    end;
    sleep(1000);
  end;
  
  
begin
  SetLength(walkSprite,10);
  SetLength(jumpSprite,10);
  SetLength(idleSprite,10);
  SetLength(deadSprite,10);
  SetLength(walkSpriteEnemyF,10); 
  SetLength(walkSpriteEnemyM,10);   
  for var i:=0 to 9 do begin                                                    //Создаем спрайты для врагов

    walkSpriteEnemyF[i]:=picture.Create('Data\GameFiles\Enemy\female\Walk ('+(i+1)+').png');  
    walkSpriteEnemyM[i]:=picture.Create('Data\GameFiles\Enemy\male\Walk ('+(i+1)+').png');    
  end;  
  
  

end.    