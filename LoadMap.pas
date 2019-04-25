UNIT LoadMap;

Interface  

uses PAWN;

Procedure OpenMap(var name:string);
type
  map=record
    name:string[70];
    state:byte;
    x,y,toX,toY:real;
    w,h:integer;
    forDraw:integer;   
  end;  
var
  bonusOBJ:ArrayObj;
  mapInteraction,mapLoadedMove,mapLoaded:ArrayObj;
  
Implementation  


var 
  nameMapChoise: string;
  FileMap:file of map;
  iterInteraction,iterBonus,iterMapMove,iterMap:integer;
  tempMap:map;
  

  procedure OpenMap(var name:string);                                           //Открываем карту по выбронному имени в основной пограмме
  begin
        nameMapChoise:=name;
        iterMap:=0;iterBonus:=0;iterMapMove:=0;iterInteraction:=0;
        Assign(FileMap,nameMapChoise);
        Reset(FileMap);
        
        while not (EoF(FileMap)) do                                             //Читаем файл и устанавливаем колличество двигающихся обьектов и статических для двух массивов
        begin
         read(FileMap,tempMap);
         if (tempMap.state=0) or (tempMap.state=4) then  iterBonus+=5;
         if ((tempMap.state<2) or(tempMap.state>4)) and (tempMap.state<>0) and (tempMap.state<>6) and (tempMap.state<>7)  then  iterMap+=1
         else if(tempMap.state=6) or (tempMap.state=7) then iterInteraction+=1
         else iterMapMove+=1;
        end;
        
        close(FileMap);
        SetLength(mapLoaded,iterMap);
        SetLength(mapLoadedMove,iterMapMove); 
        SetLength(mapInteraction,iterInteraction);         
        Reset(FileMap);
        iterMap:=0; iterMapMove:=0; iterInteraction:=0;   
        while not (EoF(FileMap)) do                                             //Создаем эти массивы смотря к какому типу относиться тайл по State
        begin
          Read(FileMap,tempMap);
          if (tempMap.state>=2) and (tempMap.state<=4) or (tempMap.state=0) and (tempMap.state<>6) and (tempMap.state<>7) then begin
            if (tempMap.state=2) or (tempMap.state=0) then mapLoadedMove[iterMapMove]:=new MoveObj(tempMap.name,tempMap.state,round(tempMap.x),round(tempMap.y),tempMap.w,tempMap.h,tempMap.toX,tempMap.toY);
            if (tempMap.state=3) then mapLoadedMove[iterMapMove]:=new MoveObj(tempMap.name,tempMap.state,round(tempMap.x),round(tempMap.y+25),tempMap.w,tempMap.h,tempMap.toX,tempMap.toY+20);  
            if (tempMap.state=4) then mapLoadedMove[iterMapMove]:=new MoveObj(tempMap.name,tempMap.state,round(tempMap.x),round(tempMap.y),tempMap.w,tempMap.h,tempMap.toX,tempMap.toY);  
            iterMapMove+=1;
          end 
          else if (tempMap.state=6) or (tempMap.state=7) then begin 
            mapInteraction[iterInteraction]:=new MoveObj(tempMap.name,tempMap.state,round(tempMap.x),round(tempMap.y),tempMap.w,tempMap.h);
            iterInteraction+=1;
          end  
          else begin
            mapLoaded[iterMap]:=new MoveObj(tempMap.name,tempMap.state,round(tempMap.x),round(tempMap.y),tempMap.w,tempMap.h);
            iterMap+=1;
          end;
        end;  
        setLength(bonusObj,iterBonus);                                          //Устанавливаем длинну динамического массива для бонусов
        close(FileMap);
  end;
    
begin


end.  