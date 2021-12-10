//Modulo PantLvlUp
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 17 de septiembre de 2021
//fecha de ultima modificación: 28 de noviembre de 2021
//comentario:

class PantLvlUp{
  ClickItem citatk;
  ClickItem citdef;
  ClickItem cithpm;
  PImage imglvlup;
  
  PantLvlUp(){
    citatk=new ClickItem(250,270,cf.sp*2,cf.sp*2,ITATK);
    citdef=new ClickItem(400,270,cf.sp*2,cf.sp*2,ITDEF);
    cithpm=new ClickItem(550,270,cf.sp*2,cf.sp*2,ITHPP);
    citatk.toggleActive();
    citdef.toggleActive();
    cithpm.toggleActive();
    imglvlup=loadImage("sprite/backgr/creation.jpg");
  }
  
  void display(){
    music();
    background(imglvlup);
    fill(255);
    text(lf.showString(13),400,100);
    citatk.display();
    citdef.display();
    cithpm.display();
    textAlign(CENTER,CENTER);
    text(pers.atk,250,335);
    text(pers.def,400,335);
    text(pers.hpm,550,335);
  }
  
  void mouseProcess(int x,int y, int b){
    if(citatk.isClicked(x,y) && b==LEFT){
      addAttr(ATATK);
    }  
    if(citdef.isClicked(x,y) && b==LEFT){
      addAttr(ATDEF);
    }
    if(cithpm.isClicked(x,y) && b==LEFT){
      addAttr(ATHPM); 
    }  
  }
  
  void addAttr(int a){
    bitacora.agregaDatosLn("El jugador ha subido de nivel");
    pers.addAttr(a);
    sfxheal.trigger();
    gameresult=pers.lvl==cf.lvlfin;
    gc.musicManager(MSCOFF,gameresult);
    gc.setPantAct(!gameresult?PNMAP:PNFIN);
  }
}
