//Modulo PantCarga
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 17 de septiembre de 2021
//fecha de ultima modificación: 28 de noviembre de 2021
//comentario:

class PantCarga{ 
  boolean loading;
  CoolDownTimer cdt;
  SpriteSet logo_loading;
  String message;
  PImage logo_gif;
  
  PantCarga(){
    loading = true;
    message = lf.showString(12);
    cdt=new CoolDownTimer(120);
    logo_loading = new SpriteSet("loading/logo_sprites/","frame-",".gif",49,2,true,0);
  }
  
  void display(){
    background(0);
    fill(255);
    imageMode(CENTER);
    logo_loading.display(400,350,cf.sp,cf.sp);
    textAlign(CENTER,CENTER);
    text(lf.showString(6),400,400);
    text(message,400,500);
    if(!loading && !cdt.isActive()){
      cdt.activate();
    }
    if(cdt.isActive()){
      cdt.coolingDown();
    }
    if(cdt.isOff()){
      gc.setPantAct(PNINT);
    }
  }
}
