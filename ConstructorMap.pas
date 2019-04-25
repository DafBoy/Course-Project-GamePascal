Unit ConstructorMap;

Interface  
uses GraphABC,PAWN;

Procedure CreateMap(var mapName:string);  
  
type                                                                            //Типизированная переменная для сохранения 1 тайла карты
  map=record
    name:string[70];
    state:byte;
    x,y,toX,toY:real;
    w,h:integer;
    forDraw:integer;
  end; 

  begin_and_end_matrix=record
    first:integer;
    last:integer;
  end;
  
Implementation 
  
 const SIZE_MAP=1500;                                                             //Максимальное колличество тайлов на карте
 
 var
  tP_path: Array [1..3] of  begin_and_end_matrix;
  TilePicture:     Array of picture;                                       //Массив изображений тайлов для паннели выбора(обьектов с коллизией) 
  allTile: Array of map;
  Tiles:   Array [1..SIZE_MAP] of map;                                    //Массив готовых тайлов с коллизией  
  background:picture;
  FileMap:         file of map;                                                          //Файл карты
  nextLine,nextNT,chTile:   integer;                                                        //Переменные для итераций                                             
  exitConstructor,pause,xORy,toPointDo,doMap,addT:boolean;                                                           //Булевые переменные для выхода и проверки добовляем мы в данный момент обьет или нет
  offsetX:integer;
  toPoint:real;
 
    

    procedure PauseGame;
    var 
      f:text;
      textP: array of string;
      iterText:byte;
    begin
      iterText:=0;
      Assign(f,'Data\GameFiles\Redactor.txt');
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
        for var i:=0 to length(textP)-1 do       TextOut(20,50+(i*30),textP[i]);  
        Redraw;
      end;
    end;
    
  procedure ReadListName;                                                       //Процедура считываем с текстового файла имена пути изображений
  var
    fileListName:file of map;
    temp:map;
    l:integer;
  begin
    l:=0;
    Assign(fileListName,'LoadFile\PathPicture');
    Reset(fileListName);
    while not(EoF(fileListName)) do begin  read(fileListName,temp); l+=1; end;
    close(fileListName);
    Reset(fileListName);    
    SetLength(allTile,l);
    l:=0;
    while not(EoF(fileListName)) do begin read(fileListName,allTile[l]);l+=1; end; 
    close (fileListName);
  end;
  
  procedure DrawChoiseLine(var currentLine:begin_and_end_matrix);                    //Процедура отрисовки линии для выбора тайла(квадрата изображения)
  begin
      for var i:= currentLine.first to currentLine.last do  begin
        TilePicture[i].Draw(((i+1)-currentLine.first)*45,20,30,30);
        if chTile=i then    SetPenColor(clBlue)
        else SetPenColor(clGold);
        DrawRectangle((((i+1)-currentLine.first)*45)-6,15,(((i+1)-currentLine.first)*45)+36,56); 
      end;
      if (addT) and (Tiles[nextNT].state=2) then begin 
        if xORy then Line(round(Tiles[nextNT].x-offsetX),round(Tiles[nextNT].y),round(Tiles[nextNT].x+toPoint)-offsetX,round(Tiles[nextNT].y))
        else Line(round(Tiles[nextNT].x-offsetX),round(Tiles[nextNT].y),round(Tiles[nextNT].x)-offsetX,round(Tiles[nextNT].y+40+toPoint));
      end; 
      if (addT) and (Tiles[nextNT].state=4) then begin xORy:=true; Line(round(Tiles[nextNT].x-offsetX),round(Tiles[nextNT].y),round(Tiles[nextNT].x+toPoint)-offsetX,round(Tiles[nextNT].y)) end;  
  end;
 

 
  procedure keydown(key:integer);                                               //ПРОЦЕДУРА НАЖАТИЯ КЛАВИШИ
  begin
    case key of
      vk_escape:  exitConstructor:=True;
      vk_f1:if pause then pause:=false else pause:=True;
      vk_z:if  Tiles[nextNT].state=2 then if xORy then xORy:=False else xORy:=True ; 
      vk_r:if (nextLine=3) and not(Tiles[nextNT].state=3) then toPoint+=12.5;
      vk_f:if (nextLine=3) and not(Tiles[nextNT].state=3) then toPoint+=-12.5;
      vk_Left :offsetX-=50;
      vk_Right:offsetX+=50;
      VK_Back: if nextNT>=1 then nextNT-=1;
      vk_d: begin                                                               //Если не выбрали обьект для создания прокручивает полосу выбора иначе управляет выбранным обьектом
        if not(addT) then begin 
          chTile+=1;
          if chTile>tP_path[nextLine].last then chTile:=tP_path[nextLine].first;//если значение Больше длинны   сбрасывает на первую
        end 
        else Tiles[nextNT].x+=25;  
      end;
      vk_a: begin                                                               //Если не выбрали обьект для создания прокручивает полосу выбора иначе управляет выбранным обьектом
        if not(addT) then begin
          chTile-=1;
          if chTile<tP_path[nextLine].first then chTile:=tP_path[nextLine].last; //если значение Меньше длинны   сбрасывает на последнюю
        end
        else Tiles[nextNT].x-=25;  
      end;
      vk_w: begin                                                               //выбираем какую полоску выбора тайла рисовать с коллизией без
        if not(addT) then begin
          if nextLine<=2 then nextLine+=1
          else nextLine:=1;
          chTile:=tP_path[nextLine].first;
        end
        else Tiles[nextNT].y-=25;  
      end; 
      vk_s: begin                                                               //выбираем какую полоску выбора тайла рисовать с коллизией без
        if not(addT) then begin
          if nextLine>1 then nextLine-=1
          else nextLine:=3;
          chTile:=tP_path[nextLine].first;
        end
        else Tiles[nextNT].y+=25;  
      end;  
      vk_space: begin                                                           //Выбираем обьект и создаем его копию для последующиего размещения в файле карты, также подтверждаем создание обьекта
        if not(addT) then begin
            if nextNT<SIZE_MAP then nextNT+=1;
            Tiles[nextNT].name:= allTile[chTile].name;
            Tiles[nextNT].state:=allTile[chTile].state;
            Tiles[nextNT].w:=allTile[chTile].w; Tiles[nextNT].h:=allTile[chTile].h;

 
          Tiles[nextNT].forDraw:=chTile;

          if nextNT>1 then begin
            Tiles[nextNT].x:=Tiles[nextNT-1].x+Tiles[nextNT-1].w;
            Tiles[nextNT].y:=Tiles[nextNT-1].y;
          end;  
          addT:=True;
        end
        else begin
          if (Tiles[nextNT].state=2) then begin
            if xORy then begin Tiles[nextNT].toX:=Tiles[nextNT].x+toPoint-Tiles[nextNT].w; Tiles[nextNT].toY:=Tiles[nextNT].y; end
            else begin Tiles[nextNT].toX:=Tiles[nextNT].x; Tiles[nextNT].toY:=Tiles[nextNT].y+toPoint+Tiles[nextNT].h;  end;           
          end
          else if (Tiles[nextNT].state=3) then begin Tiles[nextNT].toX:=Tiles[nextNT].x; Tiles[nextNT].toY:=Tiles[nextNT].y-50;end
          else if (Tiles[nextNT].state=4) then begin Tiles[nextNT].toX:=Tiles[nextNT].x+toPoint-Tiles[nextNT].w; Tiles[nextNT].toY:=Tiles[nextNT].y; end
          else if (Tiles[nextNT].state=0) then begin Tiles[nextNT].toX:=Tiles[nextNT].x+30; Tiles[nextNT].toY:=Tiles[nextNT].y;end
          else  begin Tiles[nextNT].toX:=Tiles[nextNT].x;Tiles[nextNT].toX:=Tiles[nextNT].x; end;
          toPoint:=0;
          addT:=False;
        end;  
      end;
      vk_Enter: doMap:=false;
    end;
  end;    
    
    
 
  procedure starting_initialization;                                            //Процедура для установки всех параметров в начальное состояние
  begin
    exitConstructor:=False;
    SetFontSize(20);
    nextLine:=1;
    tP_path[1].first:=0; tP_path[1].last:=28;                                  // Указываем длинны 3 линий для разных видов обьектов при отрисовки
    tP_path[2].first:=29; tP_path[2].last:=52;
    tp_path[3].first:=53; tp_path[3].last:=57;
    doMap:=True;
    addT:=False;
    nextNT:=8;
    chTile:=0;
    Onkeydown+=keydown;                                                      
    ReadListName; 
    SetLength(TilePicture,length(allTile));
    SetPenWidth(4);                                                                   //устонавливаем размер в пикселям обводки  
    background:=picture.Create('Data\GameFiles\Level 1\background.png');              //ЗАдний фон
    for var i:=0  to 57 do     TilePicture[i]:= picture.Create(allTile[i].name);   //создаем изображения для выбора при создании    
  end;
  
  Procedure CreateMap(var mapName:string);                                                          //основной цикл(процедура) создания карты
  begin
     starting_initialization;                                                   // стандартная иницилизация, и создания двери и участка для старта игрока
     for var i:=1 to 5 do begin Tiles[i].name:='Data\GameFiles\Level 1\Tiles\TileA2.png';Tiles[i].x:=50*i;Tiles[i].y:=700;Tiles[i].state:=1;Tiles[i].w:=50;Tiles[i].h:=50;Tiles[i].toX:=50*i;Tiles[i].toY:=720;Tiles[i].forDraw:=1; end;
     Tiles[6].name:='Data\GameFiles\Level 1\Tiles\TileA1.png';Tiles[6].x:=0;Tiles[6].y:=700;Tiles[6].state:=1;Tiles[6].w:=50;Tiles[6].h:=50;Tiles[6].toX:=0;Tiles[6].toY:=720;Tiles[6].forDraw:=0;
     Tiles[7].name:='Data\GameFiles\Level 1\Tiles\TileArrowSign2.png';Tiles[7].x:=250;Tiles[7].y:=650;Tiles[7].state:=5;Tiles[7].w:=50;Tiles[7].h:=50;Tiles[6].toX:=0;Tiles[7].toY:=700;Tiles[7].forDraw:=43;
     Tiles[8].name:='Data\GameFiles\Level 1\Tiles\TileDoor1.png';Tiles[8].x:=0;Tiles[8].y:=550;Tiles[8].state:=5;Tiles[8].w:=200;Tiles[8].h:=150;Tiles[8].toX:=50;Tiles[8].toY:=650;Tiles[8].forDraw:=51;   
     
     while doMap and not(exitConstructor) do begin             //Основной цикл редактора карты
      background.Draw(-600-offsetX,0);
      background.Draw(5800-offsetX,0);      
      for var i:=1 to nextNT do begin                                                 //Отрисовка готовых тайлов                 
       if Tiles[i].state <> 4 then TilePicture[Tiles[i].forDraw].Draw(round(Tiles[i].x-offsetX),round(Tiles[i].y),Tiles[i].w,Tiles[i].h)
       else TilePicture[Tiles[i].forDraw].Draw(round(Tiles[i].x-offsetX),round(Tiles[i].y+35),Tiles[i].w,Tiles[i].h);
      end;
      DrawChoiseLine(tP_path[nextLine]);
      Redraw;
      sleep(10);
      if pause then PauseGame;
    end;
    if not(exitConstructor) then begin                                          //Если выход не через ESC то открываем файл и перезаписываем его
      Assign(FileMap,mapName);
      Rewrite(FileMap);
      for var i:=1 to nextNT do begin
        Write(FileMap,Tiles[i]);
      end;
      close(FileMap);
    end; 
    
  end;

begin
  
  

end.                                                                            //Конец MAIN функции