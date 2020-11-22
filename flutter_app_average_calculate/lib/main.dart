import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> ders;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ders = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Not Hesapla"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) formKey.currentState.save();
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait)
            return UygulamaGovdesi();
          else
            return UygulamaGovdesiLandScape();
        },
      ),
    );
  }

  Widget UygulamaGovdesi() {
    Color c = generateRandomColor();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //color: Colors.pink,
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Ders Adı",
                        labelText: "Ders Adı",
                        hintStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2),
                        ),
                      ),
                      validator: (entry) {
                        if (entry.length == 0)
                          return "Ders Adı Boş Olamaz";
                        else
                          return null;
                      },
                      onSaved: (req) {
                        setState(() {
                          ders.add(Ders(req, dersHarfDegeri, dersKredi));
                          ortalama = 0;
                          ortalamaHesapla();
                        });
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            autofocus: false,
                            items: dersKrediItems(),
                            value: dersKredi,
                            onChanged: (entry) {
                              setState(() {
                                dersKredi = entry;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: Notlar(),
                            autofocus: false,
                            value: dersHarfDegeri,
                            onChanged: (entry) {
                              setState(() {
                                dersHarfDegeri = entry;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Ortalama: ",
                                style: TextStyle(color: Colors.purple),
                              ),
                              TextSpan(
                                text: ders.length != 0 ? "$ortalama" : "0.0",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.purple,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: ders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget UygulamaGovdesiLandScape() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 300,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "Ders Adı",
                      labelText: "Ders Adı",
                      hintStyle: TextStyle(color: Colors.purple),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                    ),
                    validator: (entry) {
                      if (entry.length == 0)
                        return "Ders Adı Boş Olamaz";
                      else
                        return null;
                    },
                    onSaved: (req) {
                      setState(
                        () {
                          ders.add(Ders(req, dersHarfDegeri, dersKredi));
                          ortalama = 0;
                          ortalamaHesapla();
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            autofocus: false,
                            items: dersKrediItems(),
                            value: dersKredi,
                            onChanged: (entry) {
                              setState(() {
                                dersKredi = entry;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: Notlar(),
                            autofocus: false,
                            value: dersHarfDegeri,
                            onChanged: (entry) {
                              setState(() {
                                dersHarfDegeri = entry;
                              });
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Ortalama: ",
                            style: TextStyle(color: Colors.purple),
                          ),
                          TextSpan(
                            text: ders.length != 0 ? ortalama.toString() : "0.0",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: ders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKrediItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
      krediler.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text("$i kredi"),
        ),
      );
    }

    return krediler;
  }

  List<DropdownMenuItem<double>> Notlar() {
    List<DropdownMenuItem<double>> notlar = [];

    notlar.add(
      DropdownMenuItem(
        child: Text("AA"),
        value: 4,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("BA"),
        value: 3.5,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("BB"),
        value: 3,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("CB"),
        value: 2.5,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("CC"),
        value: 2,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("DC"),
        value: 1.5,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("DD"),
        value: 1,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("FD"),
        value: 0.5,
      ),
    );
    notlar.add(
      DropdownMenuItem(
        child: Text("FF"),
        value: 0,
      ),
    );

    return notlar;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    Color c = generateRandomColor();
    counter++;
    return Dismissible(
      key: Key(
        counter.toString(),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          ders.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Card(
        color: c,
        child: ListTile(
          leading: Icon(Icons.school, color: Colors.white),
          title: Text(ders[index].ad),
          subtitle: Text(ders[index].harfDegeri.toString()),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var d in ders) {
      toplamNot += d.harfDegeri * d.kredi;
      toplamKredi += d.kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color generateRandomColor() {
    return Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
