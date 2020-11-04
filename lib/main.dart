import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tflite/tflite.dart';
import 'splashscreen.dart';

void main() => runApp(MaterialApp(
  home: Splach(),
));


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificador de Residuos'),
      ),
      body: SingleChildScrollView(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           mainAxisAlignment: MainAxisAlignment.center,
           children:<Widget>[
              Container(
              padding: EdgeInsets.all(10),
              height: 300,
              child: InkWell(
                child: _image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 150,
                        color: Colors.black45,
                      )
                    : Image.file(
                        _image,
                        fit: BoxFit.cover,
                      ),
                    onTap: () {
                  opImagem();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
             children: [
              _outputs != null
                ? Container(
                  child:Column(
                    children: [
                        Text("Qual lixeira devo jogar o Lixo?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          background: Paint()..color = Colors.white),
                          ),
                          InkWell(
                            child:  Image.asset(getUrl()),
                             onTap: () {
                               info();
                               }
                          ),
                      
                         Text(
                          "${_outputs[0]["label"]}",
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          background: Paint()..color = Colors.white,
                          ),
                        )
                    ],
                    
                  )  ,
                ) 
                : Container()
          ],
        ),
       )
   
           ], 
          
          ) 
          ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: opImagem,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }
   opImagem() {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Selecionar Imagem'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.camera,
                          size: 35,
                        ),
                        onPressed: () {
                          _getImage();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 35,
                        ),
                        onPressed: () {
                          _getGaleria();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Galeria')
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }
String getUrl(){
  if("${_outputs[0]["label"]}".compareTo("Papel")==0){
      return "assets/azul.png";  
  }else if("${_outputs[0]["label"]}".compareTo("Plástico")==0){
      return "assets/vermelho.png";
  }else if("${_outputs[0]["label"]}".compareTo("Vidro")==0){
      return "assets/verde.png";
  }else{
      return "assets/amarelo.png";
  } 
}

  Future _getGaleria() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  
  }
  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
     setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
    
  }


  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

   info() {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Informção'),
          content: Text(getInfo()) ,
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }

String getInfo(){
 if("${_outputs[0]["label"]}".compareTo("Papel")==0){
      return "Itens: jornais, revistas, impressos em geral; caixas de papelão e embalagens longa-vida.";  
  }else if("${_outputs[0]["label"]}".compareTo("Plástico")==0){
      return "Itens: garrafas, embalagens de produtos de limpeza; potes de cremes e xampus"+
      "tubos e canos; brinquedos; sacos, sacolas e saquinhos de leite" +
      "papéis plastificados, metalizados ou parafinados, como embalagens de biscoito.";
  }else if("${_outputs[0]["label"]}".compareTo("Vidro")==0){
      return "Itens: frascos, garrafas; vidros de conserva.";
  }else{
      return "Itens: latinhas de cerveja, refrigerante e sucos; esquadrias e molduras de quadros.";
  } 
}

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}