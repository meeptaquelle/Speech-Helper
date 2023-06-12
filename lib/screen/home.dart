import 'package:flutter/material.dart';
import 'package:ippl_miftah/screen/screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 73, 66, 228),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.settings))
        ],
        ),
        body: Column(
          children: [
            Container(
      margin: const EdgeInsets.only(top: 53),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 30,
          color: Colors.grey,
          margin: const EdgeInsets.only(left: 20),
        ),
        const Spacer(),
        Container(
          width: 100,
          height: 30,
          color: Colors.grey,
        ),
        const Spacer(),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen2()));
          },
          child: Container(
          width: 100,
          height: 30,
          color: Colors.grey,
          margin: EdgeInsets.only(right: 20),
          child: const Center(
            child: Text(
              "Kontol"
            ),
          ),
        ),
        )
      ],
    ),
    ),
          ],
        ),
    );
  }
}