import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final random = Random();
  final String passwordElements = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#\$%^&*?";
  String password = "";
  int passwordLength = 8;

  // generate password
  void generatePassword() {
    password = "";
    for (int i = 0; i < passwordLength; i++) {
      final index = random.nextInt(passwordElements.length);
      password += passwordElements[index];
    }
  }

  // generate password when the app starts
  @override
  void initState() {
    generatePassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Generator", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            // generated password
            ListTile(
              title: SelectableText(password),
              leading: Icon(Icons.password),
              trailing: IconButton(
                icon: Icon(Icons.copy), onPressed: () {
                  Clipboard.setData(ClipboardData(text: password));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password copied!")
                    )
                  );
                }
              ),
            ),

            // regenerate button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generatePassword();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(350, 45),
              ),
              child: Text("Regenerate", style: TextStyle(color: Colors.white),),
            ),

            SizedBox(height: 20,),
            
            // password length selector
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Length", style: TextStyle(color: Colors.white70, fontSize: 12),),
                      Text("$passwordLength", style: TextStyle(color: Colors.white, fontSize: 17),)
                    ],
                  ),
                  Expanded(
                    child: Slider(
                      value: passwordLength.toDouble(), 
                      onChanged: (value) {
                        setState(() {
                          passwordLength = value.toInt();
                          generatePassword();
                        });
                      },
                      divisions: 124,
                      min: 4,
                      max: 128,
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}