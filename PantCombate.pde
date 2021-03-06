//Modulo PantCombate  
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 17 de septiembre de 2021
//fecha de ultima modificación: 28 de noviembre de 2021
//comentario:

class PantCombate{
  PImage pasto;
  PImage desrt;
  PImage woods;
  Boton btnback;
  Boton btnatk;
  Boton btndef;
  Boton btnitem;
  ClickItem citpotn;
  ClickItem citfptn;
  ClickItem cittonic;
  int fasebatalla;
  boolean battleactive;
  boolean actionactive;
  boolean combatactive;
  boolean playrlocked;
  boolean enemylocked;
  Enemigo enemy;
  CoolDownTimer cdt;
  CoolDownTimer cdte;
  CoolDownTimer cdtp;
  boolean turn;
  boolean result;
  boolean intro;
  boolean isAtaked = false;
  int action;
  int messageRandom = 35;
  PImage imagenSangre = loadImage("sprite/icon/blood.png");
    
  PantCombate(){
    pasto=loadImage("sprite/backgr/pasto_ok.jpg");
    desrt=loadImage("sprite/backgr/desierto_ok.jpg");
    woods=loadImage("sprite/backgr/bosque_ok.jpg");
    btnback=new Boton(400,700,200,100,23);
    btnatk=new Boton(150,550,150,80,30);
    btndef=new Boton(400,550,150,80,31);
    btnitem=new Boton(650,550,150,80,32);
    btnback.activate();
    citpotn=new ClickItem(600,625,cf.sp,cf.sp,ITPTN);
    citfptn=new ClickItem(650,625,cf.sp,cf.sp,ITFPT);
    cittonic=new ClickItem(700,625,cf.sp,cf.sp,ITTNC);
    battleactive=BATTLEOFF;
    actionactive=ACTOFF;
    combatactive=false;
    intro=false;
    cdt=new CoolDownTimer(180);
    cdte=new CoolDownTimer(120);
    cdtp=new CoolDownTimer(120);
  }
  
  
  
  void display(){
    music();
    startBattle();
    selectBackgr(pers.terr);
    fill(255);
    text(lf.showString(7),400,100);
    controlCombate();
    displayPlanoControl();
    displayPlanoBatalla();
    displayPlanoHUD();
    if(actionactive && turn){
      cdtp.coolingDown();
    }
    if(actionactive && cdtp.isOff()){
      cdtp.deactivate();
      endAction();
    }
    if(actionactive && !turn){
      cdte.coolingDown();
    }
    if(actionactive && cdte.isOff()){
      cdte.deactivate();
      enemyEndAction();
    }
    if(isAtaked){
      text(lf.showString(messageRandom),200,200);
      image(imagenSangre,235,350,60,60);    
    }    
  }
  
  void selectBackgr(int t){
    switch(t){
      case CLBSQ: 
        background(woods);
      break;
      case CLPST: 
        background(pasto);
      break;
      case CLTRR: 
        background(desrt);
      break;            
    }
  }
  
  void startBattle(){
    if(!battleactive){
      bitacora.agregaDatosLn("¡El jugador entro en combate!");
      btnatk.desactiveMarked();
      btndef.desactiveMarked();
      btnitem.desactiveMarked();
      fasebatalla=FBINTRO;
      battleactive=BATTLEON;
      createEnemies();
    }  
  }
  
  void displayPlanoBatalla(){
    pers.battleDisplay();
    displayEnemies();
  }
  
  void displayPlanoHUD(){}
  
  void displayPlanoControl(){
    btnback.display();
    btnatk.display();
    btndef.display();
    btnitem.display();
    citpotn.display();
    citfptn.display();
    cittonic.display();
  }
  
  void displayEnemies(){
    enemy.display();
  }
  
  void mouseProcess(int x,int y,int b){
    if(btnback.isClicked(x,y) && b==LEFT){
      resetBattle();
      battleactive=BATTLEOFF;
      gc.musicManager(MSCOFF,false);
      gc.setPantAct(PNMAP);
      //Agregamos una bitacora si el jugador no termina una batalla
      bitacora.agregaDatosLn("El jugador salio del combate sin terminar la batalla");
    }
    if(actionactive && btnatk.isClicked(x,y) && b==LEFT){
      btnatk.toggleMarked();
      combatAction(ACATK);
      iniciaAccion();
    }
    if(actionactive && btndef.isClicked(x,y) && b==LEFT){
      btndef.toggleMarked();
      combatAction(ACDEF);
      iniciaAccion();
    }
    if(actionactive && btnitem.isClicked(x,y) && b==LEFT && pers.hasItems()){
      btnitem.toggleMarked();
      if(pers.potn>0)
        citpotn.toggleActive();
      if(pers.fpot>0)  
        citfptn.toggleActive();
      if(pers.tonic>0)  
        cittonic.toggleActive();
      combatAction(ACITM);
    }
    if(actionactive && citpotn.isClicked(x,y) && b==LEFT){
      pers.consumeItem(ITPTN);
      iniciaAccion();
    }
    if(actionactive && citfptn.isClicked(x,y) && b==LEFT){
      pers.consumeItem(ITFPT);
      iniciaAccion();
    }
    if(actionactive && cittonic.isClicked(x,y) && b==LEFT){
      pers.consumeItem(ITTNC);
      iniciaAccion();
    }
  }
  
  void controlCombate(){
    switch(fasebatalla){
      case FBINTRO: controlEspera();
                    enemySnd();
                    break;
      case FBCOMBT: iniciaBatalla();
                    controlAcciones();
                    break;
      case FBEND:   controlEspera();
                    break;
      case FBEXIT:  resetBattle();
                    cambiaPantalla();              
    }
  }
  
  void combatAction(int a){
    int atkp;
    int defe;
    action=a;
    switch(action){
      case ACATK: atkp=pers.getAtkDamage()+td.tira2D6();
                  defe=enemy.getDefDamage();                  
                  if(atkp>defe){                    
                    isAtaked=true;
                    messageRandom = int(random(35, 38));
                    enemy.herida(atkp-defe);
                    sfxsword.trigger();
                    if(!enemy.isAlive()){
                      enemy.playSfx(ENFXDED);
                      resultVictory();                      
                    }
                  }
                  break;
      case ACDEF: pers.toggleDefense();
    }
    cdt.activate();
  }
  
  void createEnemies(){
    enemy=new Enemigo(pers.terr,dcbt);  
  }
  
  void toggleAction(){
    actionactive=!actionactive;
  }
  
  void iniciaAccion(){
    if(!cdtp.isActive()){
      cdtp.activate();
      setTurn(TURNP);
    }  
  }
  
  void controlEspera(){
    if(!cdt.isActive())
      cdt.activate();
    if(cdt.isActive())
      cdt.coolingDown();
    if(cdt.isOff()){
      cdt.deactivate();
      fasebatalla=nextFB();
    }  
  }
  
  void iniciaBatalla(){
    if(!combatactive){
      isAtaked = false;
      combatactive=true;
      turn=TURNP;
      pers.activateCombat();
      enemy.activateCombat();
      playrlocked=false;
      enemylocked=false;
    }
  }
  
  void controlAcciones(){
    if(pers.cdtturn.isActive()){
      pers.cdtturn.coolingDown();
    }  
    if(pers.cdtturn.isOff() && !enemylocked){
      enemy.cdtturn.togglePause();
      pers.cdtturn.deactivate();
      toggleEnemyLocked();
      btnatk.activate();
      btndef.activate();
      btnitem.activate();
      toggleAction();
    }
    if(enemy.cdtturn.isActive()){
      enemy.cdtturn.coolingDown();
    }  
    if(enemy.cdtturn.isOff() && !playrlocked){
      pers.cdtturn.togglePause();
      enemy.cdtturn.deactivate();
      togglePlayrLocked();
      toggleAction();
      iniciaEnemyAction();
    }
  }
  
  int nextFB(){
    return fasebatalla==FBINTRO?FBCOMBT:fasebatalla==FBCOMBT?FBEND:FBEXIT;
  }
  
  void cambiaPantalla(){
    gc.musicManager(MSCOFF,result);
    gc.setPantAct(result?(pers.exp>=pers.explimit?PNLVL:PNMAP):PNFIN);
  }
  
  void toggleEnemyLocked(){
    enemylocked=!enemylocked;
  }
  
  void togglePlayrLocked(){
    playrlocked=!playrlocked;
  }
  
  void iniciaEnemyAction(){
    if(!cdte.isActive()){
      cdte.activate();
      isAtaked=false;
      setTurn(TURNE);
      enemyAction();
    }
  }
  
  void enemyAction(){
    int atke=enemy.getAtkDamage()+td.tira2D6();
    int defp=pers.getDefDamage();
    if(atke>defp){
      pers.herida(atke-defp);
      enemy.playSfx(ENFXATK);
      if(!pers.isAlive()){
        resultDefeat();
        sfxdeath.trigger();
      }
    }
    else
      sfxshild.trigger();
    if(pers.defactive)
      pers.toggleDefense();
  }
  
  void endAction(){
    btnatk.deactive();
    btndef.deactive();
    btnitem.deactive();
    toggleMarks();
    pers.cdtturn.activate();
    toggleAction();
    enemy.cdtturn.togglePause();
    toggleEnemyLocked();
    if(pers.tonicd>0)
      pers.coolTonic();
  }
  
  void enemyEndAction(){
    enemy.cdtturn.activate();
    pers.cdtturn.togglePause();
    togglePlayrLocked();
    toggleAction();
  }
  
  void setTurn(boolean t){
    turn=t;
  }
  
  void toggleMarks(){
    switch(action){
      case ACATK: 
        btnatk.toggleMarked(); 
      break;
      case ACDEF: 
        btndef.toggleMarked();
      break;
      case ACITM: 
        btnitem.toggleMarked();
        if(citpotn.active) citpotn.toggleActive();
        if(citfptn.active) citfptn.toggleActive();
        if(cittonic.active) cittonic.toggleActive();
      break;
    }
  }
   
  void resetBattle(){
    pers.cdtturn.deactivate();
    enemy.cdtturn.deactivate();
    pers.tonicd=0;
    cdt.deactivate();
    cdtp.deactivate();
    cdte.deactivate();
    btnatk.deactive();
    btndef.deactive();
    btnitem.deactive();
    battleactive=BATTLEOFF;
    combatactive=false;
    playrlocked=false;
    enemylocked=false;
    actionactive=ACTOFF;
    fasebatalla=FBINTRO;
    setTurn(TURNP);
    intro=false;
  }
  
  void resultVictory(){
    bitacora.agregaDatosLn("El jugador ha ganado una batalla :D");
    fasebatalla=FBEND;
    getLoot();
    result=RSVCT;
    nextFB();
  }
  
  void resultDefeat(){
    bitacora.agregaDatosLn("El jugador perdio una batalla");
    fasebatalla=FBEND;
    result=RSDFT;
    nextFB();
  }
  
  void enemySnd(){
    if(!intro){
      enemy.playSfx(ENFXINT);
      intro=true;
    }  
  }
  
  /**
   * Esté método se usa cuando se gana una batalla ya que gana
   * experiencia y dinero, esto se guarda en la bitacora
  **/
  void getLoot(){
    pers.exp += enemy.exp;
    pers.cash += enemy.cash;
    bitacora.agregaDatosLn("El jugador ha recibido " + enemy.exp + " de experiencia y " + enemy.cash + " pesos");
    pers.updateInv(enemy.item,TMBUY);
  }
}
