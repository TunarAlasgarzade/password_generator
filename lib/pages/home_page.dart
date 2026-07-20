import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pw_generator/themes/theme_provider.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Password Generator", style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }, 
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode == false 
                ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.white,
              )
          )
        ],
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: const Size(350, 45),
              ),
              child: Text("Regenerate", style: TextStyle(color: Colors.white),),
            ),

            SizedBox(height: 20,),
            
            // password length selector
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
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