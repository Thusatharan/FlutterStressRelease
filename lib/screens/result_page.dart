import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  String stress;
  List doctorsList;
  ResultPage({required this.stress, required this.doctorsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Analyze Completed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 90,
                ),
                Text(
                  stress,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 200,
                  child: doctorsList.isNotEmpty
                      ? ListView.builder(
                          itemCount: doctorsList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.medical_services),
                              title: Text(doctorsList[index]['name']),
                              subtitle: Text(doctorsList[index]['contactNo']),
                            );
                          },
                        )
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
