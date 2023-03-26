import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nihaljumailamrathaju/additem/cakedetailspage.dart';
  List<String> listplace = [
  'Malappuram',
  'Manjeri',
  'Perinthalmanna',
  'Areacode',
  'Nilambur',
  'Anakkayam'
  ];
  List<String> listitems = <String>[
  'Cake',
  'Pudding',
  'Snack',
  'Ice Cream ',
  'Sweets',
  'Pizza'
];
class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => FilterpageState();
}

class FilterpageState extends State<Filterpage> {

  String dropdownValue = listitems.first;
  String dropdownvalueplace = listplace.first;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar:
    AppBar(backgroundColor:  const Color(0xff7f4ca5),
    title: const Text("Filter"),
    ) ,
    body: Form(child:
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             DropdownButton<String>(
                      hint: const Text('Select An Item'),
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.blue,
                      ),
                      elevation: 16,
                      style: const TextStyle(color: Colors.blue),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: listitems.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                       DropdownButton<String>(
                      hint: const Text('Select An Item'),
                      value: dropdownvalueplace,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.blue,
                      ),
                      elevation: 16,
                      style: const TextStyle(color: Colors.blue),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownvalueplace = value!;
                        });
                      },
                      items: listplace.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
          ElevatedButton(onPressed: () {
        
             buildview();
     
          }, child:const Text('Sumbit')),
       
        ],
        
        
      ),
    )),
    )
    );
  }
   Widget buildview(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Filter-Location').doc(dropdownvalueplace)
            .collection(dropdownValue).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
                return const Center(
                  child: Text(
                    '                  OOPS! \n NO PRODUCTS TO SHOW.',
                    style: TextStyle(
                      color: Color(0xff7f4ca5),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              } else {
                final snap = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Card(
                        color: Colors.pink[200],
                        margin: const EdgeInsets.all(20),
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(0),
                          child: Row(children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snap[index]['URl']),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 14,
                              child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(snap[index]['Item Name'],
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children:  <Widget>[
                                        /*Text(
                                    'Barcode : ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),*/
                                  // Text(
                                  //   snap[index]['place'],
                                  //   style:const  TextStyle(fontSize: 15.0),
                                  // ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          snap[index]['Price of Item'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            Cakedetailspage(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              product:
                                                                  snap[index],
                                                            )));
                                              },
                                              child: const Text(
                                                "Details",
                                                style: TextStyle(
                                                  color: Color(0xff7f4ca5),
                                                  fontSize: 16,
                                                ),
                                              )), 
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                  itemCount: snap.length,
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );
            }
      },
    );
  }
}