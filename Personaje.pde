//Modulo Personaje 
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 11 de octubre de 2021
//fecha de ultima modificación: 27 de noviembre de 2021
//comentario:
class Personaje{
  int atk;  //puntos de ataque
  int def;  //puntos de defensa
  int hp;   //puntos de vida actuales
  int hpm;  //puntos de vida máximo (nivel)
  int hpp;  //puntos de vida máximo (puntos)
  int wpn;  //arma
  int shl;  //escudo
  int dir;  //hacia donde mira
  int exp;  //experiencia acumulada
  int lvl;  //nivel del personaje
  int px;   //posición x en el mapa
  int py;   //posición y en el mapa
  int cx;   //posición x en combate
  int cy;   //posición y en combate
  int terr; //indica el terreno que pisa el personaje
  int cash; //cuanto dinero tiene el personaje
  boolean alive;
  boolean defactive;
  int explimit;
  int tonicd;
  CoolDownTimer cdtturn;
  SpriteSet ssdown;
  SpriteSet ssleft;
  SpriteSet ssup;
  AnimationStructure as;
  //inventario
  int potn;
  int fpot;
  int tonic;
  int mx;
  int my;
  
  Personaje(int a,int d,int h,int c,int x,int y){
    mx=ml.getCols()-5;
    my=ml.getRows()-5;
    atk=a;
    def=d;
    hpm=h;
    hp=hpp=cf.hp*hpm;
    exp=0;
    explimit=cf.explup;
    lvl=cf.lvlini;
    dir=DOWN;
    px=x;
    py=y;
    cx=600;
    cy=350;
    terr=CLPST;
    cash=c;
    potn=0;
    fpot=0;
    tonic=0;
    alive=LIVE;
    tonicd=0;
    defactive=false;
    cdtturn=new CoolDownTimer(cf.cdtplayr);
    ssdown=new SpriteSet("sprite/personaje/worldmove/down/","down",".png",2,10,true,0);
    ssleft=new SpriteSet("sprite/personaje/worldmove/left/","left",".png",2,10,true,0);
    ssup=new SpriteSet("sprite/personaje/worldmove/up/","up",".png",2,10,true,0);
    as=new AnimationStructure();
    as.addSpriteSet(new SpriteSet("sprite/personaje/tonico/tonic1/","tonicX",".png",2,6,true,0));
    as.addSpriteSet(new SpriteSet("sprite/personaje/tonico/tonic2/","tonicX",".png",2,6,true,0));
    as.addSpriteSet(new SpriteSet("sprite/personaje/tonico/tonic3/","tonicX",".png",2,6,true,0));
    as.addSpriteSet(new SpriteSet("sprite/personaje/tonico/tonic4/","tonicX",".png",2,6,true,0));
  }
  
  void display(){
    int xr,yr;
    xr=(px<=4)?px:(px<=mx)?5:px%10;
    yr=(py<=4)?py:(py<=my)?5:py%10;
    if(gmode){
      switch(dir){
        case DOWN:  ssdown.display(cf.hs+xr*cf.ss,cf.hs+yr*cf.ss,cf.ss,cf.ss); break;
        case UP:    ssup.display(cf.hs+xr*cf.ss,cf.hs+yr*cf.ss,cf.ss,cf.ss); break;
        case LEFT:  ssleft.display(cf.hs+xr*cf.ss,cf.hs+yr*cf.ss,cf.ss,cf.ss); break;
        case RIGHT: ssleft.flipDisplay(cf.hs+xr*cf.ss,cf.hs+yr*cf.ss,cf.ss,cf.ss); break;
      }  
    }
    else{
      setFillStroke(COLPERS);
      circle(cf.hs+xr*cf.ss,cf.hs+yr*cf.ss,cf.ss);
    }
  }
  
  /**
   * Esté método se usa en la batalla para dibujar al jugador
   * y sus atributos como el nivel, su vida, su tiempo de elección, etc.. 
  **/
  void battleDisplay(){
    if(gmode){
      ssleft.display(cx,cy,cf.ss,cf.ss);
      if(tonicd>0){
        as.setActiveSpriteSet(tonicd-1);
        as.display(cx,cy,cf.ss,cf.ss);
      }
    }
    else{
      setFillStroke(COLPERS);
      circle(cx,cy,cf.ss);
      if(tonicd>0){
        noFill();
        stroke(COLMKGRN);
        strokeWeight(3*tonicd);
        circle(cx,cy,cf.ss);
        strokeWeight(1);
      }
    }
    
    fill(0, 408, 612);
    text("Lvl: "+lvl, cx-cf.ss +50, cy-85);
    drawLifeBar(cx-cf.ss,cy+45);
    cdtturn.drawTimeBar(cx-cf.ss,cy+75); 
  }
  
  void move(int d){
    dir=d;
    switch(dir){
      case UP:    py--;
                  break;
      case DOWN:  py++;
                  break;
      case LEFT:  px--;
                  break;
      case RIGHT: px++;
                  break;         
    }
  }
  
  void setTerrain(int t){
    terr=t;
  }
  
  void drawLifeBar(int x,int y){
    rectMode(CORNER);
    setFillStroke(0);
    rect(x,y,160,28);
    setFillStroke(COLBLOOD);
    rect(x+2,y+2,int((hp*1.0/hpp)*156),24);
    rectMode(CENTER);
  }
  
  void drawTradeData(){
    image(imgcash,280,470);
    image(imgpotn,360,470);
    image(imgfpot,440,470);
    image(imgtonic,520,470);
    fill(255);
    text("$"+cash,280,510);
    text(potn,360,510);
    text(fpot,440,510);
    text(tonic,520,510);
    textAlign(CENTER,CENTER);
  }
  
  int getItemInv(int i){
    return (i==ITPTN?potn:(i==ITFPT?fpot:tonic));
  }
  
  void updateInv(int i,boolean tm){
    switch(i){
      case ITPTN: potn+=tm?1:-1;break;
      case ITFPT: fpot+=tm?1:-1;break;
      case ITTNC: tonic+=tm?1:-1;break;
    }
  }
  
  void activateCombat(){
    cdtturn.activate();
  }
  
  boolean hasItems(){
    return potn>0 || fpot>0 || tonic>0;
  }
  
  void consumeItem(int i){
    switch(i){
      case ITPTN: potn--;
                  healPers();
                  break;
      case ITFPT: fpot--;
                  fullHealPers();
                  break;
      case ITTNC: tonic--;
                  activateTonic();
                  break;            
    }
    sfxdrink.trigger();
  }
  
  void healPers(){
    hp=(hp+cf.heal<hpp)?hp+cf.heal:hpp;
  }
  
  void fullHealPers(){
    hp=hpp;
  }
  
  void activateTonic(){
    tonicd=cf.tonicd;
    as.setActiveSpriteSet(tonicd);
  }
  
  /**
   * Guardamos la bitácora cuando el enemigo hace daño al jugador
  **/
  void herida(int d){
    String message = "El enemigo hizo un daño de :"+d+" a nuestro personaje";
    bitacora.agregaDatosLn(message);
    hp-=hp-d>0?d:hp;
    alive=hp>0;
  }
  
  boolean isAlive(){
    return alive;
  }
  
  int getAtkDamage(){
    return (atk+(tonicd>0?cf.tonicb:0))*cf.patkf;
  }
  
  int getDefDamage(){
    return (def+(tonicd>0?cf.tonicb:0)+(defactive?1:0))*cf.pdeff;
  }
  
  void coolTonic(){
    if(tonicd>0){
      tonicd--;
      as.prevSpriteSet();
    }  
  }
  
  void toggleDefense(){
    defactive=!defactive;
  }
  
   /**
    * Aquí se aumenta un atributo del jugador cuando este sube de nivel y se 
    * guarda en la bitácora
   **/
  void addAttr(int a){
    switch(a){
      case ATATK: 
        atk++; 
        bitacora.agregaDatosLn("El jugador decidio aumentar su ataque");
      break;
      case ATDEF: 
        def++; 
        bitacora.agregaDatosLn("El jugador decidio aumentar su defensa");
      break;
      case ATHPM: 
        hpm++; 
        hp=hpp+=cf.hp;
        bitacora.agregaDatosLn("El jugador decidio aumentar su vida");
      break;
    }
    exp-=explimit;
    explimit+=cf.expinc;
    
    lvl++;
  }
}
