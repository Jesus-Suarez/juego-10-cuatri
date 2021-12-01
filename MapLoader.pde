//Modulo MapLoader
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 24 de noviembre de 2021
//fecha de ultima modificación: 27 de noviembre de 2021
//comentario:
class MapLoader{
  String file[];
  int map[][];
  int r;
  int c;
  
  MapLoader(){
    file=loadStrings("worldmap.dat");
    r=int(split(file[0],'='))[1];
    c=int(split(file[1],'='))[1];
    map=new int[r][c];
    for(int i=0;i<r;i++)
      for(int j=0;j<c;j++)
        map[i][j]=(file[i+2].charAt(j))-'0';
  }
  
  int[][] getMap(){
    return map;
  }
  
  int getRows(){
    return r;
  }
  
  int getCols(){
    return c;
  }
  
  void printMap(){
    for(int i=0;i<r;i++){
      for(int j=0;j<c;j++)
        print(map[i][j]);
      println();  
    }  
  }
}
