program Game;

uses graphABC,PlayGame,ConstructorMap,LoadTextures;


var
  background,playIcon,editorIcon,settingsIcon,exitsIcon,cursorIcon : picture;       //Переменные отвечающие за Картинки
  xC,yC,clickMouse:integer;                                                        // Переменные кординат мышки
  resolutionX,resolutionY,menuIconX,menuIconY:integer;
  nextDo,gameDo: boolean;
  namePointer:byte;
  mapName:array [1..5] of string=('Maps\Map_1','Maps\Map_2','Maps\Map_3','Maps\Map_4','Maps\Map_5');
  ChPlayer:string;


 
procedure MouseDown(x, y, mb: integer);                                         //Процедура при нажатии на кнопку мыши ставит переменной clickMouse 1 Что значит что она нажата
begin
  clickMouse:=1;
end;

procedure MouseUp(x, y, mb: integer);                                           //Процедура в момент отпускания   кнопки мыши ставит переменной clickMouse 0 
begin
  clickMouse:=0;
end;


procedure MouseMove(x, y, mb: integer);                                         //Процедура считывающая движения мышки
begin 
  System.Windows.Forms.Cursor.Hide;                                             //Скрываем Windows курсор
  xC:=x-10;                                                                     //Присваевам значения для нашего курсора
  yC:=y-10;
end;

procedure SettingsGame;                                                         //Процедура настроек не окончена
var
  resolutionIcon,backIcon,resolution1980Icon :picture;
  backToMenu,settingR:boolean;
begin
  backToMenu:=True;
  settingR:=false;
  background := picture.Create('Data\MainWindow\MainBG.png');
  backIcon := picture.Create('Data\MainWindow\back.png');

  while backToMenu do
  begin
  
    background.Draw(0,0);
    backIcon.Draw(resolutionX-150,resolutionY-150);
    
    
    cursorIcon.Draw(xC,yC);   
    if (xC >resolutionX-150) and (xC<resolutionX-30) and (yC >resolutionY-150) and (yC < resolutionY-52) then begin
        background := picture.Create('Data\MainWindow\MainBG.png');
        backIcon := picture.Create('Data\MainWindow\backCh.png');
        if  clickMouse=1 then backToMenu:=false;  
    end    
    else  backIcon := picture.Create('Data\MainWindow\back.png');  
    
    
    
  Redraw;
  end;
end;  

Function ChoisePlayer:boolean;                                                  //В этой процедуре игрок выбирает игрока Кота или Собаку
var
  backToMenu:boolean;
  Djet,Toy,Dp,Tp,backIcon :picture;
begin
  backToMenu:=True;
  backIcon := picture.Create('Data\MainWindow\back.png');
  Dp:=picture.Create('Data\Players\dog\Run (7).png');
  Tp:=picture.Create('Data\Players\cat\Run (7).png');
  
  Djet:= picture.Create('Data\MainWindow\Djet.png');
  Toy:=picture.Create('Data\MainWindow\Toy.png');
  
  while backToMenu do
  begin  
    background.Draw(0,0);  
    backIcon.Draw(menuIconX+650,menuIconY+500);
   
    Dp.Draw(menuIconX-450,menuIconY-50);
    Djet.Draw(menuIconX-360,menuIconY+400);
    Tp.Draw(menuIconX+200,menuIconY-50);
    Toy.Draw(menuIconX+350,menuIconY+400);
    if (xC >menuIconX-360) and (xC<menuIconX) and (yC >menuIconY+400) and (yC < menuIconY+533) then begin 

      Djet.Load('Data\MainWindow\DjetCh.png');
      if clickMouse=1 then begin backToMenu:=false; ChoisePlayer:=True;  ChPlayer:='dog'; end
    end 
    else   Djet.Load('Data\MainWindow\Djet.png');

    if (xC >menuIconX+350) and (xC<menuIconX+630) and (yC >menuIconY+400) and (yC < menuIconY+502) then begin 
      Toy.Load('Data\MainWindow\ToyCh.png');
      if clickMouse=1 then begin backToMenu:=false; ChoisePlayer:=True;  ChPlayer:='cat'; end;  
    end 
    else   Toy.Load('Data\MainWindow\Toy.png');
    
    if (xC >menuIconX+650) and (xC<menuIconX+802) and (yC >menuIconY+500) and (yC < menuIconY+620) then begin
      background := picture.Create('Data\MainWindow\MainBG.png');
      backIcon.Load('Data\MainWindow\backCh.png');
      if  clickMouse=1 then begin backToMenu:=false; ChoisePlayer:=False; end;  
    end    
    else  backIcon.Load('Data\MainWindow\back.png');
    cursorIcon.Draw(xC,yC);    
    ReDraw;
 
  end;  
end;

Function ChoiseMap:boolean;                                                     //Функция выбора карты
var
  M1,M2,M3,M4,M5,backIcon :picture;
  backToMenu,settingR:boolean;

begin
  backToMenu:=True;
  settingR:=false;
  backIcon := picture.Create('Data\MainWindow\back.png');
  M1:=picture.Create('Data\MainWindow\PictureMapList\M1.png');
  M2:=picture.Create('Data\MainWindow\PictureMapList\M2.png');
  M3:=picture.Create('Data\MainWindow\PictureMapList\M3.png');
  M4:=picture.Create('Data\MainWindow\PictureMapList\M4.png');
  M5:=picture.Create('Data\MainWindow\PictureMapList\M5.png');  
  sleep(100);
  while backToMenu do
  begin
  
    background.Draw(0,0);
    M1.Draw(menuIconX-40,menuIconY);
    M2.Draw(menuIconX,menuIconY+118);
    M3.Draw(menuIconX+40,menuIconY+227);
    M4.Draw(menuIconX,menuIconY+339);
    M5.Draw(menuIconX-40,menuIconY+461);    
    backIcon.Draw(menuIconX+650,menuIconY+500);
    cursorIcon.Draw(xC,yC);  
    

    if (xC >menuIconX-40) and (xC<menuIconX+370) and (yC >menuIconY) and (yC < menuIconY+108) then begin   //Карта 1
        M1.Load('Data\MainWindow\PictureMapList\M1Ch.png');
        if  clickMouse=1 then begin namePointer:=1 ; backToMenu:=false; ChoiseMap:=True; end; 
    end    
    else  M1.Load('Data\MainWindow\PictureMapList\M1.png');  
  
    if (xC >menuIconX) and (xC<menuIconX+327) and (yC >menuIconY+118) and (yC < menuIconY+217) then begin  //Карта 2
        M2.Load('Data\MainWindow\PictureMapList\M2Ch.png');
        if  clickMouse=1 then begin  namePointer:=2; backToMenu:=false; ChoiseMap:=True; end;  
    end    
    else  M2.Load('Data\MainWindow\PictureMapList\M2.png');  
  
    if (xC >menuIconX+40) and (xC<menuIconX+295) and (yC >menuIconY+227) and (yC < menuIconY+339) then begin   //Карта 3
        M3.Load('Data\MainWindow\PictureMapList\M3Ch.png');
        if  clickMouse=1 then begin  namePointer:=3; backToMenu:=false; ChoiseMap:=True; end;   
    end    
    else  M3.Load('Data\MainWindow\PictureMapList\M3.png');  
    
    if (xC >menuIconX) and (xC<menuIconX+304) and (yC >menuIconY+349) and (yC < menuIconY+471) then begin   //Карта 4
        M4.Load('Data\MainWindow\PictureMapList\M4Ch.png');
        if  clickMouse=1 then begin  namePointer:=4; backToMenu:=false; ChoiseMap:=True;  end;  
    end    
    else  M4.Load('Data\MainWindow\PictureMapList\M4.png');  
    
    if (xC >menuIconX-40) and (xC<menuIconX+462) and (yC >menuIconY+481) and (yC < menuIconY+635) then begin   //Карта 5
        M5.Load('Data\MainWindow\PictureMapList\M5Ch.png');
        if  clickMouse=1 then begin  namePointer:=5; backToMenu:=false; ChoiseMap:=True;  end;   
    end    
    else  M5.Load('Data\MainWindow\PictureMapList\M5.png');  
        
    
    if (xC >menuIconX+650) and (xC<menuIconX+802) and (yC >menuIconY+500) and (yC < menuIconY+620) then begin
        background := picture.Create('Data\MainWindow\MainBG.png');
        backIcon.Load('Data\MainWindow\backCh.png');
        if  clickMouse=1 then begin backToMenu:=false; ChoiseMap:=False; end;  
    end    
    else  backIcon.Load('Data\MainWindow\back.png');  
    
    
    
  Redraw;
  end;
end;  




begin                                                                           //Основная функция
  nextDo:=False;
  gameDo:= false;
  resolutionX := 1366;                                                          // Устанавливаем разрешение экрана X
  resolutionY := 768;                                                           // Устанавливаем разрешение экрана Y
  menuIconX := Round(resolutionX*(36/100));                                     //Расчитываем кординаты иконок меню по X
  menuIconY := Round(resolutionY*(10/100));                                     //Расчитываем кординаты иконок меню по Y
  Window.Caption:='My Game';                                                    // Переименновываем окно
  Window.Left:=0;
  Window.Top:=0;
  Window.IsFixedSize:=True;
  SetWindowSize(resolutionX,resolutionY);                                       //Устанавливаем разрешение экрана
  Lockdrawing;
  namePointer:=0;                                                            
                                                                                //Связываем событие отжатия клавиши с нашими процедурами
  OnMouseDown:=MouseDown;                                                       //Связываем событие нажатие мышки с нашими процедурами
  OnMouseMove := MouseMove;                                                     //Связываем событие движения мыши с нашей процедурой
  OnMouseUp := MouseUp;
  background := picture.Create('Data\MainWindow\MainBG.png');
  
  
  playIcon := picture.Create('Data\MainWindow\play.png');
  editorIcon:=picture.Create('Data\MainWindow\editor.png');
  settingsIcon := picture.Create('Data\MainWindow\settings.png');
  exitsIcon := picture.Create('Data\MainWindow\exit.png');
  cursorIcon := picture.Create('Data\MainWindow\cursor.png');  

  repeat
    background.Draw(0,0);
    playIcon.Draw(menuIconX,menuIconY);
    editorIcon.Draw(menuIconX-40,menuIconY+124);
    settingsIcon.Draw(menuIconX-50,menuIconY+236);  
    exitsIcon.Draw(menuIconX-10,menuIconY+360);
    cursorIcon.Draw(xC,yC);
    

    

    
    
    if (xC >menuIconX) and (xC<menuIconX+334) and (yC >menuIconY) and (yC < menuIconY +114) then begin          //Иконка "играть"
      playIcon := picture.Create('Data\MainWindow\playCh.png');
      if clickMouse=1 then begin
        nextDo:=ChoiseMap;
        if nextDo then  nextDo:=ChoisePlayer;
        if nextDo then DogOrCat(ChPlayer);
        if nextDo then begin 
          Start_Initialization;
          while (nextDo) and (namePointer<=5)  do begin
            nextDo:=Play(mapName[namePointer]); 
            namePointer+=1; 
          end;
       end;
      end;  
    end  
    else playIcon := picture.Create('Data\MainWindow\play.png');
    
    if (xC >menuIconX-40) and (xC<menuIconX+392) and (yC >menuIconY+124) and (yC < menuIconY +225) then begin       //Иконка "Редактор"
      editorIcon := picture.Create('Data\MainWindow\editorCh.png');
      if clickMouse=1 then begin 
        nextDo:=ChoiseMap;
        if nextDo then CreateMap(mapName[namePointer]) ;
      end;  
    end 
    
    else editorIcon := picture.Create('Data\MainWindow\editor.png');

    if (xC >menuIconX-50) and (xC<menuIconX+412) and (yC >menuIconY+236) and (yC < menuIconY +350) then begin       //Иконка "Настройки"
      settingsIcon := picture.Create('Data\MainWindow\settingsCh.png');
      if clickMouse=1 then SettingsGame;
    end 
    
    else  settingsIcon := picture.Create('Data\MainWindow\settings.png');
    
    if (xC >menuIconX-10) and (xC<menuIconX+356) and (yC >menuIconY+360) and (yC < menuIconY +465) then begin        //Иконка "Выхода"
      exitsIcon := picture.Create('Data\MainWindow\exitCh.png');
      if clickMouse =1 then gameDo:=true;
    end
    else exitsIcon := picture.Create('Data\MainWindow\exit.png');
    Redraw;
    
    
  until gameDo;
  window.Close;
  
end.