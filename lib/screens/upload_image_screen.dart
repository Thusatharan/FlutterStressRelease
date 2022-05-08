import 'dart:convert';
import 'dart:io';

import 'package:expression_detection/screens/result_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? selectedImage;
  var permanentImage;
  late FormData formData;

  bool isLoading = false;

  bool _showQuiz = false;
  Answers answer = Answers.answer1;
  Answers answer2 = Answers.answer1;
  Answers answer3 = Answers.answer1;
  Answers answer4 = Answers.answer1;
  Answers answer5 = Answers.answer1;
  Answers answer6 = Answers.answer1;
  Answers answer7 = Answers.answer1;
  Answers answer8 = Answers.answer1;
  Answers answer9 = Answers.answer1;
  Answers answer10 = Answers.answer1;
  int sum = 0;
  Future pickImage(ImageSource source) async {
    try {
      final selectedImage = await ImagePicker().pickImage(source: source);
      if (selectedImage == null) return;

      final imageTemporary = File(selectedImage.path);
      final imagePermenant = await saveImagePermanently(selectedImage.path);
      setState(() {
        this.selectedImage = imageTemporary;
        permanentImage = imagePermenant;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  int getSum(Answers selectedAnswer) {
    if (selectedAnswer == Answers.answer1) {
      sum += 1;
    }
    if (selectedAnswer == Answers.answer2) {
      sum += 2;
    }
    if (selectedAnswer == Answers.answer3) {
      sum += 3;
    }
    if (selectedAnswer == Answers.answer4) {
      sum += 4;
    }
    if (selectedAnswer == Answers.answer5) {
      sum += 5;
    }
    return sum;
  }

  postFormApi(var image, int sum) async {
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://10.0.2.2:5000/uploader"));
    //add text fields
    request.fields["value"] = sum.toString();
    // print(selectedImage);
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file", image.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await http.Response.fromStream(response);
    var decodedResponse = json.decode(responseData.body);
    List doctors = decodedResponse['doctors'];
    var stressLevel = decodedResponse['stress-level'];
    // var responseString = String.fromCharCodes(responseData);
    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultPage(
                stress: stressLevel,
                doctorsList: doctors,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/purplebg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: const Text(
        //     '',
        //     style: TextStyle(color: Colors.purple),
        //   ),
        //   elevation: 0,
        // ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 300,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: selectedImage != null
                      ? Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/noimageavailable.jpg",
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.camera_alt,
                          size: 50, color: Theme.of(context).primaryColor),
                    ),
                    // selectedImage != null
                    //     ? IconButton(
                    //         onPressed: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => AlertDialog(
                    //           // title: Text('Your Current Location'),
                    //           content: Container(
                    //             height: 250,
                    //             child: Column(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.center,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: const [
                    //                 Icon(
                    //                   Icons.check_circle,
                    //                   color: Colors.green,
                    //                   size: 90,
                    //                 ),
                    //                 Text(
                    //                   'Image Uploaded',
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: 22,
                    //                       fontWeight:
                    //                           FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () =>
                    //                   Navigator.pop(context),
                    //               child: Text('OK'),
                    //             )
                    //           ],
                    //         ));

                    //           //enable quiz
                    //           setState(() {
                    //             _showQuiz = true;
                    //           });
                    //         },
                    //         icon: Icon(Icons.upload,
                    //             size: 50,
                    //             color: Theme.of(context).primaryColor),
                    //       )
                    //     : const IconButton(
                    //         onPressed: null,
                    //         icon: Icon(Icons.upload,
                    //             size: 50, color: Colors.grey),
                    //       ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                // Divider(
                //   height: 10,
                //   thickness: 5,
                // ),
                Visibility(
                  visible: selectedImage != null,
                  child: Container(
                    color: Colors.white70,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Answer the quiz',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you been upset because of something that happened unexpectedly?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt that you were unable to control the important things in your life?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer2,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer2 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer2,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer2 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer2,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer2 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer2,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer2 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer2,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer2 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt nervous and stressed',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer3,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer3 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer3,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer3 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer3,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer3 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer3,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer3 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer3,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer3 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt confident about your ability to handle your personal problems? ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer4,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer4 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer4,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer4 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer4,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer4 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer4,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer4 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer4,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer4 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt that things were going your way?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer5,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer5 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer5,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer5 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer5,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer5 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer5,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer5 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer5,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer5 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' In the last month, how often have you found that you could not cope with all the things that you had to do?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer6,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer6 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer6,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer6 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer6,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer6 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer6,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer6 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer6,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer6 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you been able to control irritations in your life?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer7,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer7 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer7,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer7 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer7,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer7 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer7,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer7 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer7,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer7 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt that you were on top of things?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer8,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer8 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer8,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer8 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer8,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer8 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer8,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer8 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer8,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer8 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' In the last month, how often have you been angered because of things that happened that were outside of your control? ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer9,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer9 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer9,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer9 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer9,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer9 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer9,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer9 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer9,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer9 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                ListTile(
                                  title: const Text('Never'),
                                  leading: Radio(
                                      value: Answers.answer1,
                                      groupValue: answer10,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer10 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Almost Never'),
                                  leading: Radio(
                                      value: Answers.answer2,
                                      groupValue: answer10,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer10 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Sometimes'),
                                  leading: Radio(
                                      value: Answers.answer3,
                                      groupValue: answer10,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer10 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Fairly Often'),
                                  leading: Radio(
                                      value: Answers.answer4,
                                      groupValue: answer10,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer10 = val;
                                          }
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: const Text('Very Often'),
                                  leading: Radio(
                                      value: Answers.answer5,
                                      groupValue: answer10,
                                      onChanged: (Answers? val) {
                                        setState(() {
                                          if (val != null) {
                                            answer10 = val;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(20),
                          width: 250,
                          child: isLoading
                              ? Container(
                                  color: Colors.grey,
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('Analyzing'),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => {
                                    getSum(answer),
                                    getSum(answer2),
                                    getSum(answer3),
                                    getSum(answer4),
                                    getSum(answer5),
                                    getSum(answer6),
                                    getSum(answer7),
                                    getSum(answer8),
                                    getSum(answer9),
                                    getSum(answer10),
                                    print(sum),
                                    postFormApi(permanentImage, sum),
                                    sum = 0,
                                  },
                                  child: Text('Submit'),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Answers { answer1, answer2, answer3, answer4, answer5 }
