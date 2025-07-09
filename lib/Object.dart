
class Object{
  String nome,oggetto,counter;
  int id;
  Object(this.id,this.nome,this.oggetto,this.counter);

  @override
  String toString() {
    // TODO: implement toString
    return "$oggetto $nome";
  }


}