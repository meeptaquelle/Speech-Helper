// import 'package:flutter/material.dart';
// import 'package:ippl_miftah/screen/add_notes.dart';
// import 'package:sqflite/sqflite.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({Key? key}) : super(key: key);

//   void getData() {

//   }

//   final List<Map> myProducts =
//       List.generate(100000, (index) => {"id": index, "name": "Product $index"});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kindacode.com'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         // implement GridView.builder
//         child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 200,
//                 childAspectRatio: 3 / 2,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20),
//             itemCount: myProducts.length,
//             itemBuilder: (BuildContext ctx, index) {
//               return Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(15)),
//                 child: Text(myProducts[index]["name"], 
//                 overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const AddNotes()));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
