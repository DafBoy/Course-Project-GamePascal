UNIT PAWN;

Interface  
  Uses GraphABC,LoadTextures;
  var q,qm,qp:integer;  
type


  moveObj=class; 
  PlayerObj=class;     
  ArrayObj= array of MoveObj;                                            //Массив обьектов с которыми возможно столкновение (для передачи в процедурах функция)


 
    moveObj=class                                                               // клас  обьекта(Обьект с возможностбю перемещения)
    public  
      name:string;                                                              //имя предмета                                               /
      x,y:real;                                                                 //Кординаты предмета x,y   
      height,width:integer;                                                     //Размер 
      state:byte;                                                     // имеет ли колизию
      image:picture;      
      movementX,movementY:real;                                                   // Скорость по осям X Y
      fromX,fromY,toX,toY:real;                                                   // точки для движущихся обьектов
      onGround:boolean;                                                            // на земле ли обьект
    
    Function WhatTileNow(var tileObj:ArrayObj):byte;
    begin
      WhatTileNow:=255;
      for var i:=0 to length(tileObj)-1 do begin
        if(self.x+self.width>(tileObj[i].x)) and (self.x<tileObj[i].x+(tileObj[i].width)) and (self.y+self.height>tileObj[i].y) and (self.y<tileObj[i].y+tileObj[i].height) then  WhatTileNow:=i
       
      end;
      
  end;
    




      constructor(name:string;state:byte;x,y,w,h:integer);               // Конструктор обьекта
      begin
        self.name:=name;
        self.state:=state;
        self.x:=x;
        self.y:=y;
        self.height:=h;
        self.width:=w;
        image:= picture.Create(name);
      end;
      
      constructor(name:string;state:byte;x,y,w,h:integer;toX,toY:real);                                 // Конструктор обьекта
      begin
        self.name:=name;
        self.x:=x;
        self.y:=y;
        self.height:=h;
        self.width:=w;
        self.fromX:=x; self.toX:=toX;
        self.fromY:=y; self.toY:=toY;
        self.image:=picture.Create(name);
        self.state:=state;
        if self.x<>self.toX then self.movementX:=5
        else  self.movementX:=0;
        if self.y>self.toY then self.movementY:=-5
        else if self.y<self.toY then self.movementY:=5
        else self.movementY:=0; 
      end; 
      


   
      


      procedure MoveObj(time:real);                                             //Процедура для двигающихся обьектов их движение идет от начальной точки до точки "toX_Y" и при достижение сменяеться с начальной
      var speed,plx,tempX,tempY:real;
      begin
        if self.state=2 then speed:=5 else if (self.state=0) or(self.state=9)  then speed:=0.5   else speed:=2;
        if self.x<>self.toX then begin
          if (self.x+10>=toX) and (self.x<toX+10)   then begin 
           if self.movementX>0 then self.movementX:=-speed else self.movementX:=speed;
           tempX:=toX; 
           toX:=fromX; 
           fromX:=tempX;
          end
          else begin 
            self.x+=self.movementX*time;
          end; 
        end;
        if self.y<>self.toY then begin        
         if (self.y+10>=toY) and (self.y<toY+10)   then begin 
           if self.movementY>0 then self.movementY:=-speed else self.movementY:=speed;
           tempY:=toY; 
           toY:=fromY; 
           fromY:=tempY; 
          end
          else begin 
            self.y+=self.movementY*time;
          end;
        end;
      end;  
      
     procedure Draw;                                                           //Процедура отрисовки обдьекта
     begin
      image.Draw(round(x),round(y),self.width,self.height);
     end;

    Procedure Col(dir:integer;var tileObj:ArrayObj;wts:char;time:real);                          //НАЧАЛО ПРОЦЕДУРЫ СТОЛКНОВЕНИЯ И СМЕЩЕНИЯ ПЕРСОНАЖА                 
    begin
   for var i:=0 to length(tileObj)-1 do begin
        
      if (tileObj[i].state<5)and(self.x+self.width>tileObj[i].x) and (self.x<tileObj[i].x+tileObj[i].width) and (self.y+self.height>tileObj[i].y)and (self.y<tileObj[i].y+tileObj[i].height-(tileObj[i].height)) then begin  //проверяем стороны
          if(dir=1)and(self.movementX>0) then self.x:=tileObj[i].x-self.width;                                           //если по X то все время откатываем растояние чтобы не давать двигаться персонажу в сторону препятствия
          if(dir=1)and(self.movementX<0) then self.x:=tileObj[i].x+tileObj[i].width;                                  // тоеж в обратную сторону
          if(dir=0)and(self.movementY>0) then begin
            self.y:=tileObj[i].y-self.height;                                         //для Y  если скорость падения (притяжения )больше 0 тормозим игрока отнимаем
            self.movementY:=0;
            onGround:=true;
          end;
          if(dir=0)and(self.movementY<0)then begin                                           //по Y если обьект сверху
           self.y:=tileObj[i].y+(tileObj[i].height);
           self.movementY:=0;
          end;
      end;
    end;  
    end;
   


      procedure Update(var masObj:ArrayObj;time:real;var wts:char);                       //ПРоцедура обновления персонажа столкновение гравитация передвижение
      begin
        self.onGround:=false;
        self.movementY+=2*time;
        self.x+=self.movementX*time;
        col(1,masObj,wts,time);
        self.y+=self.movementY*time;
        col(0,masObj,wts,time);
      end;
  
  

     
  end;                               // Конструктор обьекта

    PlayerObj=class(moveObj)                                                    //класс типа персонажа
    protected

    public
     pointM:integer;
     life:=3;
     constructor(name:string;x,y,w,h:integer);                                  //Конструктор для класса персонаж
     begin
      self.pointM:=0; 
      self.name:=name;
      self.x:=x;
      self.y:=y;
      self.height:=h;
      self.width:=w;
      image:=picture.Create('Data\Players\cat\Idle (9).png');
      self.state:=7;
     end;
 


    Procedure ColForTake(var tileObj:ArrayObj;wts:char;time:real);                          //Коллизия для бонусных обьектов и итерации бонусных очков           
    begin
      for var i:=0 to length(tileObj)-1 do begin
        if tileObj[i]<>nil then 
          if(self.x+self.width>tileObj[i].x) and (self.x<tileObj[i].x+tileObj[i].width) and (self.y+self.height>tileObj[i].y)and (self.y<tileObj[i].y+tileObj[i].height-(tileObj[i].height/2)) and (TileObj[i].onGround) then begin
            tileObj[i]:=nil ;
            pointM+=1;
        end;    
      
      end;
    end;   
end;    
Implementation  

begin

end.