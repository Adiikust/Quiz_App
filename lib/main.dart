import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quiz/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splashDuration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        width: Get.width * 0.32,
        height: Get.width * 0.32,
        'assets/app_icon.png',
      ),
    ));
  }

  void _splashDuration() => Timer(
      const Duration(seconds: 3),
      () => Get.offAll(() => FirebaseAuth.instance.currentUser?.uid != null
          ? const HomeScreen()
          : const OnBoardingScreen()));
}

/// On Boarding Screen
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IntroductionScreen(
          pages: onBoardingData,
          showSkipButton: true,
          skip: Text('Skip',
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor)),
          onSkip: () => Get.offAll(() => const LoginScreen()),
          skipOrBackFlex: 0,
          dotsDecorator: DotsDecorator(
            color: Colors.black.withOpacity(0.2),
            activeSize: const Size(23, 10),
            activeColor: Theme.of(context).primaryColor,
            activeShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          ),
          next: Text('Next',
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor)),
          nextFlex: 0,
          done: Text('Done',
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor)),
          onDone: () => Get.offAll(() => const LoginScreen()),
          globalBackgroundColor: Colors.white,
          isProgressTap: false,
        ),
      ),
    );
  }

  static List<PageViewModel> onBoardingData = [
    PageViewModel(
      title: 'Welcome to Quiz!',
      body: 'Your personalized study companion.',
      image: Image.asset(
        'assets/onb-1.png',
        height: Get.height * 0.35,
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    ),
    PageViewModel(
      title: 'Choose Your Subjects',
      body:
          'Select your favorite subjects to customize your learning experience.',
      image: Image.asset(
        'assets/onb-2.jpeg',
        height: Get.height * 0.40,
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    ),
    PageViewModel(
      title: 'Track Your Progress',
      body: 'Monitor your progress and achieve academic',
      image: Image.asset(
        'assets/onb-3.jpg',
        height: Get.height * 0.35,
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    ),
  ];
}

/// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscurePass = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.width * 0.04,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.06),
                        Image.asset('assets/app_icon.png',
                            height: Get.height * 0.20),
                        SizedBox(height: Get.height * 0.08),
                        customTextFormField(
                          context,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          validate: (value) {
                            if (!GetUtils.isEmail(value!)) {
                              return 'Please provide a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        customTextFormField(
                          context,
                          controller: _passwordController,
                          hintText: 'Enter password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                              onPressed: () => _obscurePassword(),
                              icon: Icon(
                                _isObscurePass == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )),
                          obscureText: _isObscurePass,
                          validate: (value) {
                            if (!GetUtils.isLengthGreaterOrEqual(value, 6)) {
                              return 'Password must be 6 characters or greater';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            highlightColor: Colors.white,
                            onTap: () => Get.to(() => const ForgotScreen()),
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.07),
                        customButton(context,
                            buttonText: 'Login',
                            onPressed: () => () async {
                                  if (_loginFormKey.currentState?.validate() ??
                                      false) {
                                    FocusScope.of(context).unfocus();
                                    OverlayLoader.instance.show(context);
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim())
                                        .then((userCredential) {
                                      if (userCredential.user?.uid != null) {
                                        OverlayLoader.instance.hide();
                                        Get.offAll(() => const HomeScreen());
                                      }
                                    }).catchError((e) {
                                      OverlayLoader.instance.hide();
                                      if (e is FirebaseException) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(e.code.toString()),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ));
                                      }
                                    });
                                  }
                                }),
                        const Spacer(),
                        SizedBox(height: Get.height * 0.02),
                        Wrap(
                          children: [
                            const Text('Are you a newbie? ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                            InkWell(
                              onTap: () => Get.to(() => const SignUpScreen()),
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _obscurePassword() {
    _isObscurePass = !_isObscurePass;
    setState(() {});
  }
}

/// Forgot Screen
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _forgotFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.width * 0.04,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _forgotFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.06),
                        Image.asset('assets/app_icon.png',
                            height: Get.height * 0.20),
                        SizedBox(height: Get.height * 0.08),
                        customTextFormField(
                          context,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          validate: (value) {
                            if (!GetUtils.isEmail(value!)) {
                              return 'Please provide a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.04),
                        customButton(
                          context,
                          buttonText: 'Forgot Password',
                          onPressed: () => () async {
                            if (_forgotFormKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              OverlayLoader.instance.show(context);
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: _emailController.text.trim())
                                  .then((_) async {
                                OverlayLoader.instance.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please check your email.')));
                                await Get.off(() => const LoginScreen());
                              }).catchError((e) {
                                OverlayLoader.instance.hide();
                                if (e is FirebaseException) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.code.toString()),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ));
                                }
                              });
                            }
                          },
                        ),
                        const Spacer(),
                        SizedBox(height: Get.height * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// SignUp Screen
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformPasswordController = TextEditingController();

  bool _isObscurePass = true;
  bool _isObscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.width * 0.04,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.04),
                        Image.asset('assets/app_icon.png',
                            height: Get.height * 0.20),
                        SizedBox(height: Get.height * 0.04),
                        customTextFormField(
                          context,
                          controller: _nameController,
                          hintText: 'Enter your full name',
                          prefixIcon: Icons.person_outline,
                          validate: (value) {
                            if (GetUtils.isLengthLessThan(value, 3)) {
                              return 'Please provide a valid name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        customTextFormField(
                          context,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          validate: (value) {
                            if (!GetUtils.isEmail(value!)) {
                              return 'Please provide a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        customTextFormField(
                          context,
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          hintText: 'Enter your Address',
                          prefixIcon: Icons.location_on_outlined,
                          validate: (value) {
                            if (GetUtils.isLengthLessThan(value, 3)) {
                              return 'Please provide a valid address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        customTextFormField(
                          context,
                          controller: _passwordController,
                          hintText: 'Enter password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                              onPressed: () => _obscurePassword(),
                              icon: Icon(
                                _isObscurePass == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )),
                          obscureText: _isObscurePass,
                          validate: (value) {
                            if (!GetUtils.isLengthGreaterOrEqual(value, 6)) {
                              return 'Password must be 6 characters or greater';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        customTextFormField(
                          context,
                          controller: _conformPasswordController,
                          hintText: 'Enter confirm password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                              onPressed: () => _obscureConfirmPassword(),
                              icon: Icon(
                                _isObscureConfirmPass == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )),
                          obscureText: _isObscureConfirmPass,
                          validate: (value) {
                            if (!GetUtils.isLengthGreaterOrEqual(value, 6)) {
                              return 'Password must be 6 characters or greater';
                            }
                            if (value != _passwordController.text.trim()) {
                              return 'Oop\'s passwords not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Get.height * 0.04),
                        customButton(
                          context,
                          buttonText: 'Sign Up',
                          onPressed: () => () async => await _signUp(context),
                        ),
                        const Spacer(),
                        SizedBox(height: Get.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                            InkWell(
                              onTap: () => Get.off(() => const LoginScreen()),
                              child: Text('Login',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _obscurePassword() {
    _isObscurePass = !_isObscurePass;
    setState(() {});
  }

  void _obscureConfirmPassword() {
    _isObscureConfirmPass = !_isObscureConfirmPass;
    setState(() {});
  }

  Future<void> _signUp(BuildContext context) async {
    if (_signUpFormKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      OverlayLoader.instance.show(context);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((userCredential) async {
        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid ?? '')
              .set({
            'userId': userCredential.user?.uid ?? '',
            'fullName': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'address': _addressController.text.trim(),
            'createdAt': DateTime.now(),
          }).then((_) {
            OverlayLoader.instance.hide();
            Get.offAll(() => const HomeScreen());
          });
        }
      }).catchError((e) {
        OverlayLoader.instance.hide();
        if (e is FirebaseException) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.code.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
      });
    }
  }
}

/// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const SubjectScreen(),
    const HistoryScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return UserAccountsDrawerHeader(
                      accountName: Text(
                        snapshot.data?.data()?['fullName'] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      accountEmail: Text(snapshot.data?.data()?['email'] ?? ''),
                      decoration: const BoxDecoration(color: Colors.blue),
                    );
                  }),
              ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                    Navigator.pop(context);
                  }),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text('Profile'),
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                    Navigator.pop(context);
                  }),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.history_outlined),
                  title: const Text('History'),
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                    Navigator.pop(context);
                  }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                          TextButton(
                            onPressed: () async {
                              OverlayLoader.instance.show(context);
                              Navigator.of(context).pop();
                              await FirebaseAuth.instance.signOut().then((_) {
                                OverlayLoader.instance.hide();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false);
                              });
                            },
                            child: Text('Logout',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: const Text('Quiz'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.subject_outlined),
              label: 'Subjects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Home Subject Screen
class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData &&
            (snapshot.data?.docs.isNotEmpty ?? false)) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: snapshot.data?.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final List questions = snapshot.data!.docs[index]['questions'];
              return GestureDetector(
                onTap: () async {
                  Get.to(() => QuizScreen(
                      quizName: snapshot.data?.docs[index]['name'] ?? '',
                      questions: snapshot.data?.docs[index]['questions']));

                  ///TODO:Create Subject Category and Questions
                  // Uuid uuid = const Uuid();
                  // final docId = uuid.v4();
                  // await FirebaseFirestore.instance
                  //     .collection('quizzes')
                  //     .doc(docId)
                  //     .set({
                  //   'docId': docId,
                  //   'name': 'Computer',
                  //   'questions': [
                  //     {
                  //       'question':
                  //           'What is the basic unit of information storage in a computer?',
                  //       'options': [
                  //         {'choice': 'Byte'},
                  //         {'choice': 'Bit'},
                  //         {'choice': 'Kilobyte'},
                  //         {'choice': 'Megabyte'},
                  //       ],
                  //       'correctAns': 'Byte'
                  //     },
                  //     {
                  //       'question':
                  //           'Which programming language is commonly used for building web applications?',
                  //       'options': [
                  //         {'choice': 'Java'},
                  //         {'choice': 'Python'},
                  //         {'choice': 'JavaScript'},
                  //         {'choice': 'c++'},
                  //       ],
                  //       'correctAns': 'JavaScript'
                  //     },
                  //     {
                  //       'question':
                  //           'Which data structure follows the Last In, First Out (LIFO) principle?',
                  //       'options': [
                  //         {'choice': 'Queue'},
                  //         {'choice': 'Stack'},
                  //         {'choice': 'Linked List'},
                  //         {'choice': 'Tree'},
                  //       ],
                  //       'correctAns': 'Stack'
                  //     },
                  //     {
                  //       'question':
                  //           'What is the process of finding errors and fixing them in a program called?',
                  //       'options': [
                  //         {'choice': 'Debugging'},
                  //         {'choice': 'Compiling'},
                  //         {'choice': 'Executing'},
                  //         {'choice': 'Parsing'},
                  //       ],
                  //       'correctAns': 'Debugging'
                  //     },
                  //     {
                  //       'question':
                  //           'What does CSS stand for in web development?',
                  //       'options': [
                  //         {'choice': 'Creative Style Sheets'},
                  //         {'choice': 'Cascading Style Sheets'},
                  //         {'choice': 'Computer Style Sheets'},
                  //         {'choice': 'Content Style Sheets'},
                  //       ],
                  //       'correctAns': 'Cascading Style Sheets'
                  //     },
                  //     {
                  //       'question':
                  //           'Which of the following is NOT a type of database model?',
                  //       'options': [
                  //         {'choice': 'Relational'},
                  //         {'choice': 'Hierarchical'},
                  //         {'choice': 'Linear'},
                  //         {'choice': 'NoSQL'},
                  //       ],
                  //       'correctAns': 'Linear'
                  //     },
                  //     {
                  //       'question':
                  //           'What is the process of converting source code into machine code called?',
                  //       'options': [
                  //         {'choice': 'Compiling'},
                  //         {'choice': 'Debugging'},
                  //         {'choice': 'Executing'},
                  //         {'choice': 'Interpreting'},
                  //       ],
                  //       'correctAns': 'Compiling'
                  //     },
                  //     {
                  //       'question':
                  //           'Which data structure allows you to store a collection of elements with each element consisting of a key and a value?',
                  //       'options': [
                  //         {'choice': 'Array'},
                  //         {'choice': 'Queue'},
                  //         {'choice': 'Stack'},
                  //         {'choice': 'Dictionary'},
                  //       ],
                  //       'correctAns': 'Dictionary'
                  //     },
                  //     {
                  //       'question':
                  //           'Which programming paradigm emphasizes the use of functions and avoids changing state and mutable data?',
                  //       'options': [
                  //         {'choice': 'Imperative'},
                  //         {'choice': 'Object-Oriented'},
                  //         {'choice': 'Functional'},
                  //         {'choice': 'Procedural'},
                  //       ],
                  //       'correctAns': 'Functional'
                  //     },
                  //     {
                  //       'question':
                  //           'Which protocol is commonly used for secure communication over a computer network?',
                  //       'options': [
                  //         {'choice': '  FTP'},
                  //         {'choice': 'HTTP'},
                  //         {'choice': 'TCP'},
                  //         {'choice': 'HTTPS'},
                  //       ],
                  //       'correctAns': 'HTTPS'
                  //     },
                  //   ],
                  //   'createdAt': DateTime.now(),
                  // });

                  ///TODO:add more Question
                  // DocumentSnapshot snapshot = await FirebaseFirestore.instance
                  //     .collection('quizzes')
                  //     .doc('d58a6046-07f1-4130-a5ca-f5a9e603c21a')
                  //     .get();
                  // Map<String, dynamic> data =
                  //     snapshot.data() as Map<String, dynamic>;
                  // List<Map<String, dynamic>> newQuestions = [
                  //   {
                  //     'question':
                  //         'What is the formula to calculate the area of a circle?',
                  //     'options': [
                  //       {'choice': 'πr^2'},
                  //       {'choice': '2πr'},
                  //       {'choice': '2πr^2'},
                  //       {'choice': 'π^2r'},
                  //     ],
                  //     'correctAns': 'πr^2'
                  //   },
                  // ];
                  // List<dynamic> currentQuestions =
                  //     data['questions'] as List<dynamic>;
                  // currentQuestions.addAll(newQuestions);
                  // await FirebaseFirestore.instance
                  //     .collection('quizzes')
                  //     .doc('d58a6046-07f1-4130-a5ca-f5a9e603c21a')
                  //     .update({'questions': currentQuestions});
                },
                child: Card(
                  child: Center(
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            snapshot.data?.docs[index]['name'] ?? '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Positioned(
                            child: Container(
                          height: 30,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Questions:"),
                              Text(questions.length.toString()),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No data found'));
      },
    );
  }
}

/// Home History Screen
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('result').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData &&
            (snapshot.data?.docs.isNotEmpty ?? false)) {
          String? userId = FirebaseAuth.instance.currentUser?.uid;
          List<QueryDocumentSnapshot> userData = snapshot.data?.docs
                  .where((doc) => doc['docId'] == userId)
                  .toList() ??
              [];

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: userData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userData[index]['subject'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'view',
                                  child: const Text('View'),
                                  onTap: () => Get.to(ResultScreen(
                                    id: userData[index]['id'] ?? "",
                                  )),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: const Text('Delete'),
                                  onTap: () async {
                                    try {
                                      OverlayLoader.instance.show(context);
                                      await FirebaseFirestore.instance
                                          .collection('result')
                                          .doc(userData[index]['id'] ?? "")
                                          .delete();
                                      OverlayLoader.instance.hide();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Successfully delete'),
                                      ));
                                    } catch (e) {
                                      OverlayLoader.instance.hide();
                                      print('Error : $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Please try again later.'),
                                      ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Question",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            Text(userData[index]['totalQuestions'].toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Correct Answer",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.green,
                              ),
                            ),
                            Text(userData[index]['correntAns'].toString()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Incorrect Answer",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                            Text(userData[index]['wrongAns'].toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No data found'));
      },
    );
  }
}

/// Home profile Screen
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("My Profile Information"),
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Personal Info'),
              Tab(text: 'Account Info'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPersonalInfoTab(),
            _buildAccountInfoTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        nameController.text = snapshot.data?.data()?['fullName'] ?? '';
        addressController.text = snapshot.data?.data()?['address'] ?? '';
        return ListView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            ListTile(
              title: const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: TextFormField(
                enabled: false,
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Address',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: TextFormField(
                enabled: false,
                controller: addressController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                Get.to(UpdateProfileScreen());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountInfoTab() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        emailController.text = snapshot.data?.data()?['email'] ?? '';
        return ListView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: TextFormField(
                controller: emailController,
                readOnly: true,
                enabled: false,
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                Get.to(UpdateProfileScreen());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Update profile Screen
class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            nameController.text = snapshot.data?.data()?['fullName'] ?? '';
            emailController.text = snapshot.data?.data()?['email'] ?? '';
            addressController.text = snapshot.data?.data()?['address'] ?? '';
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: TextFormField(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Email',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: TextFormField(
                      controller: emailController,
                      readOnly: true,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Address',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: TextFormField(
                      controller: addressController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          OverlayLoader.instance.show(context);
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              'fullName': nameController.text,
                              'address': addressController.text
                            });
                            OverlayLoader.instance.hide();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Profile successfully updated'),
                            ));
                          } catch (e) {
                            OverlayLoader.instance.hide();
                            print('Error updating personal info: $e');
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Failed to update. Please try again later.'),
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text(
                            "Update Profile",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

/// Quiz Screen
class QuizScreen extends StatefulWidget {
  final String quizName;
  const QuizScreen(
      {super.key, required this.questions, required this.quizName});

  final List questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int selectedIndex = -1;
  int currentQuestion = 0;
  int correctAns = 0;
  int wrongAns = 0;
  bool isAlreadyDone = false;

  String id = "";
  @override
  void initState() {
    super.initState();
    // isAlreadyExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: isAlreadyDone
            ? customButton(context, buttonText: 'Go to Result', onPressed: () {
                Get.off(() => const ResultScreen());
              })
            : SafeArea(
                child: widget.questions.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              'Question\t\t${currentQuestion + 1}/${widget.questions.length} ',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent),
                            ),
                            const SizedBox(height: 15),
                            const Divider(),
                            const SizedBox(height: 15),
                            Flexible(
                              child: ListView.builder(
                                  itemCount: widget.questions.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Visibility(
                                      visible: index == currentQuestion,
                                      child: Container(
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 15),
                                              Text(
                                                widget.questions[
                                                        currentQuestion]
                                                    ['question'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(height: 25),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: widget
                                                    .questions[currentQuestion]
                                                        ['options']
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      selectedIndex = index;
                                                      final correctAnswer = widget
                                                                          .questions[
                                                                      currentQuestion]
                                                                  [
                                                                  'options'][index]
                                                              ['choice'] ==
                                                          widget.questions[
                                                                  currentQuestion]
                                                              ['correctAns'];
                                                      if (correctAnswer) {
                                                        correctAns += 1;
                                                      } else {
                                                        wrongAns += 1;
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: Container(
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: selectedIndex ==
                                                                      index
                                                                  ? Colors.black
                                                                  : Colors.grey
                                                                      .withOpacity(
                                                                          0.4)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            widget.questions[
                                                                        currentQuestion]
                                                                    ['options'][
                                                                index]['choice'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (selectedIndex != -1) {
                                                    selectedIndex = -1;
                                                    if (currentQuestion <
                                                        (widget.questions
                                                                .length -
                                                            1)) {
                                                      currentQuestion += 1;
                                                      setState(() {});
                                                    } else {
                                                      try {
                                                        setState(() {
                                                          id = DateTime.now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'result')
                                                            .doc(id)
                                                            .set({
                                                          'id': id,
                                                          'docId': FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid,
                                                          'totalQuestions':
                                                              widget.questions
                                                                  .length,
                                                          'correntAns':
                                                              correctAns,
                                                          'wrongAns': wrongAns,
                                                          'subject':
                                                              widget.quizName,
                                                          'questionAnswered':
                                                              currentQuestion +
                                                                  1,
                                                          'createdAt':
                                                              DateTime.now()
                                                        }).then((_) async {
                                                          await Get.off(() =>
                                                              ResultScreen(
                                                                  id: id));
                                                        });
                                                      } catch (e) {
                                                        OverlayLoader
                                                            .instance.hide;
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                      color: selectedIndex != -1
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: const Center(
                                                    child: Text(
                                                      "Next",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              GestureDetector(
                                                // onTap: () => Get.to(
                                                //     const ResultScreen()),
                                                child: const Center(
                                                    child: Text(
                                                  'Finish the Test',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.redAccent),
                                                )),
                                              ),
                                              const SizedBox(height: 30),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'No Questions Found!',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
              ));
  }

  ///   Method to check if the user's account already exists on firebase
  Future<void> isAlreadyExist() async {
    var userData = await FirebaseFirestore.instance
        .collection('result')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (userData.exists) {
      setState(() => isAlreadyDone = true);
    }
  }
}

/// Quiz Result Screen
class ResultScreen extends StatefulWidget {
  final String? id;
  const ResultScreen({super.key, this.id});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    OverlayLoader.instance.hide;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('result')
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('result')
                        .doc(widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Quiz Score",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 30),
                          Image.asset(
                              width: Get.width * 0.70, 'assets/star-1.png'),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Questions"),
                                      Text(
                                          '${snapshot.data?['totalQuestions']}'),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Correct Answers"),
                                      Text('${snapshot.data?['correntAns']}'),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Incorrect Answers"),
                                      Text('${snapshot.data?['wrongAns']}'),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 50,
                              width: Get.width * 0.70,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Center(
                                child: Text(
                                  "GOT IT",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      );
                    }),
              );
            }),
      ),
    );
  }
}

/// Widgets
Widget customTextFormField(
  BuildContext context, {
  TextInputType? keyboardType,
  String? hintText,
  TextEditingController? controller,
  bool obscureText = false,
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? Function(String)? onChanged,
  required String? Function(String? value)? validate,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText!,
        prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      validator: validate,
    ),
  );
}

Widget customButton(
  BuildContext context, {
  required String buttonText,
  required Function onPressed,
  Color? buttonColor,
  double buttonWidth = 0.7,
}) {
  return InkWell(
      highlightColor: Colors.white,
      onTap: onPressed(),
      child: Container(
        alignment: Alignment.center,
        height: Get.height * 0.07,
        width: Get.width * buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(buttonText,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ));
}

class OverlayLoaderWidget extends StatelessWidget {
  const OverlayLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 10,
                  )
                ]),
            child: Center(
                child: CupertinoActivityIndicator(
              radius: 14,
              color: Theme.of(context).primaryColor,
            )),
          ),
        ),
      ),
    );
  }
}

class OverlayLoader {
  static OverlayLoader? _instance;
  OverlayEntry? _overlayEntry;

  OverlayLoader._();

  static OverlayLoader get instance {
    _instance ??= OverlayLoader._();
    return _instance!;
  }

  void show(BuildContext context) {
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => const OverlayLoaderWidget());
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() => _overlayEntry?.remove();
}
