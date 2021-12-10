//Modulo PantPausa
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 17 de septiembre de 2021
//fecha de ultima modificación: 22 de noviembre de 2021
//comentario:

class PantPausa{
  Boton btnexit;
  Boton btncont;
  
  PantPausa(){
    btnexit=new Boton(200,600,200,100,23);
    btncont=new Boton(600,600,200,100,5);
    btnexit.activate();
    btncont.activate();
  }
  
  void display(){
    fill(255);
    text(lf.showString(15),400,100);
    btnexit.display();
    btncont.display();
  }
  
  void mouseProcess(int x,int y,int b){
    if(btnexit.isClicked(x,y) && b==LEFT){
      gc.musicManager(MSCOFF,false);
      gc.setPantAct(PNINT);
      bitacora.agregaDatosLn("El jugador salio del juego");
    }
    if(btncont.isClicked(x,y) && b==LEFT){
      gc.pnmap.toggleBlur();
      gc.setPantAct(PNMAP); 
    }  
  }
}
