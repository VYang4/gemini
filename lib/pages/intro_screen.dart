import 'package:flutter/material.dart';
import 'package:gemini/pages/account_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/disclaimer_screen.dart';
import 'package:gemini/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  String? avatarUrl; // Variable to store avatar URL

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      setState(() {
        avatarUrl = response['avatar_url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/images/Medicode.png', height: 50),
            const SizedBox(width: 20),
          ],
        ),
        actions: <Widget>[
          user == null
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountPage()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      avatarUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20),
                child: Image.asset('lib/images/heart.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 28.0, 20.0),
                child: Text(
                  'Understand your report',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0), // Horizontal padding
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns text to the left
                  children: [
                    Text(
                      '✔ Upload images of your radiologist\'s reports for instant rephrasing.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '✔ Simplify medical reports into clear, understandable language.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '✔ Get actionable insights and recommended questions for your doctor.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Space before the button
              Center(
                // Center the button horizontally
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DisclaimerPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12), // Adjust padding as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: mint,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      30), // To ensure some space at the bottom of the screen
            ],
          ),
        ),
      ),
    );
  }
}
