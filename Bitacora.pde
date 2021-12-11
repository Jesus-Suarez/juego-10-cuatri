//Modulo Bitácora
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 24 de noviembre de 2021
//fecha de ultima modificación: 24 de noviembre de 2021
//comentario:
class Bitacora{
  PrintWriter output;
  
  Bitacora(){
    String s="data/testing/game ";
    s=s+agregaFecha();
    s=s+".log";
    output=createWriter(s);
  }
  
  String agregaFecha(){
    return ""+year()+"-"+month()+"-"+day() +" a las "+hour()  /*+" con "+minute() */;
  }

  /**
   * Aquí guardamos cada bitácora por tiempo específico Ejemplo:
   * [2021-12-09 21:57:00] – MENSAJE
  **/
  String agregarFechaHora(){
    return ""+agregaFecha()+" "+hour()+":"+minute()+":"+second();
  }

   /**
    * Guardamos la bitácora con el formato de fecha y el mensaje a guardar
   **/
  void agregaDatosLn(String s){
    s = "["+agregarFechaHora()+"] - "+s;
    output.println(s);
    output.flush();
  }
  
  void agregaDatos(String s){
    output.print(s);
    output.flush();
  }
  
  void cierraBitacora(){
    String s="FIN DEL JUEGO ";
    agregaDatosLn(s);
    output.flush();
    output.close();
  }
}
