import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'dart:ui' as ui;  
import 'dart:async'; 

void main() {
  runApp(BreasyApp());
}

class BreasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF5F9FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(animation: _animation),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * _animation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bolt,
                          size: 60,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Welcome to Breasy',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.blue[800]),
                                  prefixIcon: Icon(Icons.person, color: Colors.blue[700]),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.blue[800]),
                                  prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 800),
                                      pageBuilder: (_, __, ___) => DashboardPage(),
                                      transitionsBuilder: (_, animation, __, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 50.0;
    final baseHeight = size.height * 0.7;

    path.moveTo(0, baseHeight);

    for (double i = 0; i <= size.width; i++) {
      final y = baseHeight + sin((i / size.width * 2 * pi) + (animation.value * 2 * pi)) * waveHeight;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave
    final paint2 = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    final baseHeight2 = size.height * 0.75;

    path2.moveTo(0, baseHeight2);

    for (double i = 0; i <= size.width; i++) {
      final y = baseHeight2 + sin((i / size.width * 3 * pi) - (animation.value * 2 * pi)) * waveHeight * 0.7;
      path2.lineTo(i, y);
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(20),
          childAspectRatio: 1.0,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildDashboardCard(
              context, 
              Icons.battery_full, 
              'Battery', 
              BatteryPage(), 
              Colors.lightBlue
            ),
            _buildDashboardCard(
              context, 
              Icons.bluetooth, 
              'Bluetooth', 
              BluetoothPage(), 
              Colors.blueAccent
            ),
            _buildDashboardCard(
              context, 
              Icons.speed, 
              'Frequency', 
              FrequencyPage(), 
              Colors.blue[700]!
            ),
            _buildDashboardCard(
              context, 
              Icons.timer, 
              'Timer', 
              TimerPage(), 
              Colors.blue[400]!
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String label, Widget page, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutQuint,
                )),
                child: child,
              );
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                Color.lerp(color, Colors.blue[900], 0.3)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,  // Increased icon size
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                label,
                style: TextStyle(
                  fontSize: 22,  // Slightly larger text
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 40,
                height: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BatteryPage extends StatefulWidget {
  @override
  _BatteryPageState createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  int batteryLevel = 72;
  bool isCharging = false;
  double temperature = 32.4;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for charging effect
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Wave animation for liquid effect
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
    
    _waveAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Color getBatteryColor() {
    if (batteryLevel < 20) return Colors.redAccent;
    if (batteryLevel < 50) return Colors.amber;
    return Colors.lightGreenAccent[400]!;
  }

  void _toggleCharging() {
    setState(() {
      isCharging = !isCharging;
      if (isCharging) {
        // Simulate charging
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted && isCharging && batteryLevel < 100) {
            setState(() {
              batteryLevel += 1;
              temperature += 0.2;
            });
            _toggleCharging(); // Continue charging
          } else if (batteryLevel >= 100) {
            setState(() => isCharging = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final batteryColor = getBatteryColor();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Status'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Colors.blue[900]!.withOpacity(0.9),
              Colors.blue[800]!.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Futuristic battery visualization
              Stack(
                alignment: Alignment.center,
                children: [
                  // Battery outline with glow
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: screenWidth * 0.6,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: batteryColor.withOpacity(0.8),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: batteryColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  
                  // Battery tip with glow
                  Positioned(
                    right: screenWidth * 0.3 - 35,
                    child: Container(
                      width: 20,
                      height: 40,
                      decoration: BoxDecoration(
                        color: batteryColor,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: batteryColor.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Liquid battery level with wave effect
                  Positioned(
                    bottom: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: screenWidth * 0.6 - 20,
                        height: 180 * (batteryLevel / 100),
                        child: CustomPaint(
                          painter: LiquidPainter(
                            animation: _waveAnimation,
                            batteryLevel: batteryLevel,
                            color: batteryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Percentage text with pulse effect
                  Positioned(
                    top: 70,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isCharging ? _pulseAnimation.value : 1.0,
                          child: child,
                        );
                      },
                      child: Text(
                        '$batteryLevel%',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: batteryColor,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Charging indicator
                  if (isCharging)
                    Positioned(
                      top: 30,
                      child: Icon(
                        Icons.bolt,
                        color: Colors.yellowAccent,
                        size: 30,
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Battery stats
              Container(
                width: screenWidth * 0.8,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status:',
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isCharging ? 'Charging' : batteryLevel < 20 ? 'Low' : 'Normal',
                          style: TextStyle(
                            color: isCharging ? Colors.yellowAccent : 
                                  batteryLevel < 20 ? Colors.redAccent : Colors.greenAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Temperature:',
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${temperature.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            color: temperature > 40 ? Colors.orangeAccent : Colors.lightBlueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Health:',
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Excellent',
                          style: TextStyle(
                            color: Colors.lightGreenAccent[400],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              // Charge button with cool effect
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: screenWidth * 0.6,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCharging
                        ? [Colors.blue[800]!, Colors.blue[600]!]
                        : [batteryColor, batteryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: batteryColor.withOpacity(0.4),
                      blurRadius: isCharging ? 15 : 8,
                      spreadRadius: isCharging ? 2 : 1,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _toggleCharging,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isCharging)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                            ),
                          Text(
                            isCharging ? 'Charging...' : 'Start Charging',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Battery tips
              if (batteryLevel < 30)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    '⚠️ Low battery! Connect to power soon.',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiquidPainter extends CustomPainter {
  final Animation<double> animation;
  final int batteryLevel;
  final Color color;

  LiquidPainter({
    required this.animation,
    required this.batteryLevel,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final waveHeight = size.height * 0.05;
    final baseHeight = size.height;

    // Draw the liquid with wave effect
    final path = Path();
    path.moveTo(0, baseHeight);

    for (double i = 0; i <= size.width; i++) {
      final y = baseHeight - 
          sin((i / size.width * 2 * pi) + (animation.value * 2 * pi)) * waveHeight;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Add some bubbles
    final rng = Random(animation.value.round());
    final bubbleCount = 5 + (batteryLevel / 20).floor();

    for (int i = 0; i < bubbleCount; i++) {
      final bubbleX = rng.nextDouble() * size.width;
      final bubbleY = rng.nextDouble() * size.height * 0.8;
      final bubbleRadius = rng.nextDouble() * 4 + 2;

      canvas.drawCircle(
        Offset(bubbleX, bubbleY),
        bubbleRadius,
        Paint()
          ..color = Colors.white.withOpacity(rng.nextDouble() * 0.3 + 0.1)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> 
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;
  
  bool isScanning = false;
  bool isConnected = false;
  List<BluetoothDevice> devices = [];
  List<Particle> particles = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    
    // Scan rotation animation
    _scanController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    
    _scanAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    
    // Pulse animation for connection
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    
    _pulseAnimation = Tween(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
    
    _particleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    
    // Initialize particles
    _generateParticles();
  }

  void _generateParticles() {
    particles = List.generate(50, (index) {
      return Particle(
        x: random.nextDouble() * 2 - 1,
        y: random.nextDouble() * 2 - 1,
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.2 + 0.1,
        color: Colors.blue.withOpacity(random.nextDouble() * 0.5 + 0.1),
      );
    });
  }

  void _startScan() {
    setState(() {
      isScanning = true;
      devices.clear();
    });
    
    _scanController.repeat(reverse: true);
    
    // Simulate device discovery
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        devices = [
          BluetoothDevice("NeuroSync Headset", 0.8, Icons.headset),
          BluetoothDevice("Quantum Speaker", 0.6, Icons.speaker),
          BluetoothDevice("BioLink Band", 0.9, Icons.fitness_center),
        ];
      });
    });
    
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => isScanning = false);
      _scanController.stop();
    });
  }

  void _connectToDevice(BluetoothDevice device) {
    setState(() {
      isConnected = true;
      _pulseController.repeat(reverse: true);
    });
    
    // Simulate connection process
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        devices = [device]; // Show only connected device
      });
    });
  }

  void _disconnectDevice() {
    _pulseController.stop();
    setState(() {
      isConnected = false;
      devices.clear();
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quantum Link'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo[900]!, Colors.purple[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated background particles
          AnimatedBuilder(
            animation: _particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: particles,
                  animationValue: _particleAnimation.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D Bluetooth sphere with connection waves
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Connection waves
                    if (isConnected)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: _pulseAnimation.value * 200,
                            height: _pulseAnimation.value * 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blueAccent.withOpacity(1 - _pulseAnimation.value),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    
                    // Bluetooth sphere
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.8),
                            Colors.blue[800]!.withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _scanAnimation.value * 2 * pi,
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.bluetooth,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Connection status
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isConnected ? Colors.greenAccent[400] : Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isConnected ? 'CONNECTED' : 'DISCONNECTED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 40),
                
                // Device list or scan button
                if (devices.isEmpty && !isScanning)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: screenSize.width * 0.7,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.indigoAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _startScan,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'SCAN FOR DEVICES',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                
                if (isScanning)
                  Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Scanning for quantum devices...',
                        style: TextStyle(
                          color: Colors.blueGrey[200],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                
                if (devices.isNotEmpty && !isScanning)
                  Container(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.3,
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return AnimatedDeviceCard(
                          device: device,
                          isConnected: isConnected && devices.length == 1,
                          onConnect: () => _connectToDevice(device),
                          onDisconnect: _disconnectDevice,
                        );
                      },
                    ),
                  ),
                
                // Connection strength visualization
                if (isConnected)
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: [
                        Text(
                          'QUANTUM LINK STABLE',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 8,
                              height: 20 + random.nextDouble() * 15,
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.8 - (index * 0.15)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedDeviceCard extends StatelessWidget {
  final BluetoothDevice device;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const AnimatedDeviceCard({
    required this.device,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: Colors.black.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.8),
                  Colors.blue[900]!.withOpacity(0.9),
                ],
              ),
            ),
            child: Icon(device.icon, color: Colors.white),
          ),
          title: Text(
            device.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: LinearProgressIndicator(
            value: device.signalStrength,
            backgroundColor: Colors.blueGrey[800],
            valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
          ),
          trailing: isConnected
              ? ElevatedButton(
                  onPressed: onDisconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Disconnect'),
                )
              : ElevatedButton(
                  onPressed: onConnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Connect'),
                ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final offset = Offset(
        (particle.x * size.width / 2) + size.width / 2,
        (particle.y * size.height / 2) + size.height / 2,
      );
      
      final progress = (animationValue * particle.speed + particle.offset) % 1.0;
      final radius = particle.size * (0.5 + 0.5 * sin(progress * 2 * pi));
      
      canvas.drawCircle(
        offset,
        radius,
        Paint()..color = particle.color.withOpacity(0.7 * (1 - progress)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;
  final double offset;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  }) : offset = Random().nextDouble();
}

class BluetoothDevice {
  final String name;
  final double signalStrength;
  final IconData icon;

  BluetoothDevice(this.name, this.signalStrength, this.icon);
}

class FrequencyPage extends StatefulWidget {
  @override
  _FrequencyPageState createState() => _FrequencyPageState();
}

class _FrequencyPageState extends State<FrequencyPage> 
    with TickerProviderStateMixin {
  late AnimationController _vibrationController;
  late AnimationController _mucusController;
  late Animation<double> _vibrationAnimation;
  late Animation<double> _mucusAnimation;
  
  double frequency = 12.0; // Default vibration frequency (Hz)
  bool isTherapyActive = false;
  int therapyDuration = 0;
  Timer? _therapyTimer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    
    // Vibration pulse animation
    _vibrationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    
    _vibrationAnimation = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _vibrationController, curve: Curves.easeInOut),
    );
    
    // Mucus clearance animation
    _mucusController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    
    _mucusAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _mucusController, curve: Curves.easeOut),
    );
  }

  void _startTherapy() {
    if (isTherapyActive) return;
    
    setState(() {
      isTherapyActive = true;
      therapyDuration = 0;
    });
    
    _therapyTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => therapyDuration++);
    });
    
    // Simulate mucus clearance over time
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) _mucusController.forward();
    });
  }

  void _stopTherapy() {
    _therapyTimer?.cancel();
    setState(() => isTherapyActive = false);
    _mucusController.reset();
  }

  @override
  void dispose() {
    _vibrationController.dispose();
    _mucusController.dispose();
    _therapyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Airway Clearance Therapy'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.medical_services),
            onPressed: () => _showTherapyTips(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Column(
          children: [
            // **Animated Lungs with Mucus Visualization**
            Expanded(
              flex: 3,
              child: Center(
                child: AnimatedBuilder(
                  animation: _vibrationAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isTherapyActive ? _vibrationAnimation.value : 1.0,
                      child: CustomPaint(
                        painter: LungPainter(
                          vibrationIntensity: frequency / 20,
                          mucusLevel: _mucusAnimation.value,
                          isTherapyActive: isTherapyActive,
                        ),
                        size: Size(screenSize.width * 0.8, screenSize.width * 0.8),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // **Therapy Controls**
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Frequency Control Slider
                    Text(
                      'Vibration Frequency: ${frequency.toStringAsFixed(1)} Hz',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: frequency,
                      min: 5.0,
                      max: 25.0,
                      divisions: 40,
                      label: '${frequency.toStringAsFixed(1)} Hz',
                      activeColor: Colors.blue[800],
                      inactiveColor: Colors.blue[200],
                      onChanged: (value) => setState(() => frequency = value),
                    ),
                    
                    // Therapy Timer & Start/Stop Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Session Time',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              '${therapyDuration ~/ 60}:${(therapyDuration % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTherapyActive
                                  ? [Colors.red[400]!, Colors.red[600]!]
                                  : [Colors.green[400]!, Colors.green[600]!],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: isTherapyActive ? _stopTherapy : _startTherapy,
                              child: Center(
                                child: Text(
                                  isTherapyActive ? 'STOP THERAPY' : 'START THERAPY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Breathing Guidance (Optional)
                    if (isTherapyActive)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '💡 Breathe deeply & cough when needed',
                          style: TextStyle(color: Colors.blue[800], fontSize: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTherapyTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Therapy Tips"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("✅ 5-15 Hz: Loosens thin mucus"),
            Text("✅ 15-25 Hz: Breaks up thick mucus"),
            Text("⏱️ Typical session: 10-20 mins"),
            Text("💧 Drink water before/after"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("GOT IT"),
          ),
        ],
      ),
    );
  }
}

class LungPainter extends CustomPainter {
  final double vibrationIntensity;
  final double mucusLevel;
  final bool isTherapyActive;

  LungPainter({
    required this.vibrationIntensity,
    required this.mucusLevel,
    required this.isTherapyActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    final mucusPaint = Paint()
      ..color = Colors.green.withOpacity(0.5 * mucusLevel)
      ..style = PaintingStyle.fill;
    
    // Draw left lung
    _drawLung(
      canvas,
      Offset(size.width * 0.3, size.height * 0.5),
      size.width * 0.35,
      paint,
      mucusPaint,
    );
    
    // Draw right lung
    _drawLung(
      canvas,
      Offset(size.width * 0.7, size.height * 0.5),
      size.width * 0.35,
      paint,
      mucusPaint,
    );
    
    // Draw vibration waves if active
    if (isTherapyActive) {
      final wavePaint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      for (int i = 1; i <= 3; i++) {
        final waveSize = size.width * 0.1 * i * vibrationIntensity;
        canvas.drawCircle(
          Offset(size.width * 0.5, size.height * 0.5),
          waveSize,
          wavePaint,
        );
      }
    }
  }

  void _drawLung(Canvas canvas, Offset center, double width, Paint outlinePaint, Paint mucusPaint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - width * 0.8);
    path.quadraticBezierTo(
      center.dx - width * 0.5, center.dy - width * 0.3,
      center.dx - width * 0.4, center.dy,
    );
    path.quadraticBezierTo(
      center.dx - width * 0.5, center.dy + width * 0.7,
      center.dx, center.dy + width * 0.9,
    );
    path.quadraticBezierTo(
      center.dx + width * 0.5, center.dy + width * 0.7,
      center.dx + width * 0.4, center.dy,
    );
    path.quadraticBezierTo(
      center.dx + width * 0.5, center.dy - width * 0.3,
      center.dx, center.dy - width * 0.8,
    );
    
    canvas.drawPath(path, mucusPaint); // Mucus fill
    canvas.drawPath(path, outlinePaint); // Lung outline
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  double _sliderValue = 15.0; // Default 15 minutes
  int _remainingSeconds = 15 * 60;
  Timer? _timer;
  bool _isRunning = false;
  bool _showBreathGuide = true;

  @override
  void initState() {
    super.initState();
    
    // Vibration pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _remainingSeconds = (_sliderValue * 60).toInt();
    });
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _stopTimer();
    setState(() => _remainingSeconds = (_sliderValue * 60).toInt());
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_remainingSeconds / (_sliderValue * 60));
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Therapy Timer'),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(_showBreathGuide ? Icons.air : Icons.air_outlined),
            onPressed: () => setState(() => _showBreathGuide = !_showBreathGuide),
            tooltip: 'Toggle Breathing Guide',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Column(
          children: [
            // **Time Display & Visual Feedback**
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Time remaining
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    
                    // Breathing guide indicator
                    if (_showBreathGuide)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Icon(
                              _pulseAnimation.status == AnimationStatus.forward
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 40,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                          );
                        },
                      ),
                    
                    // Progress text
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        '${(progress * 100).toStringAsFixed(0)}% Complete',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // **Slider Control**
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Text(
                    'Set Duration: ${_sliderValue.toStringAsFixed(0)} min',
                    style: TextStyle(fontSize: 18),
                  ),
                  Slider(
                    value: _sliderValue,
                    min: 5,
                    max: 30,
                    divisions: 25,
                    label: '${_sliderValue.toStringAsFixed(0)} min',
                    activeColor: Colors.blue[700],
                    inactiveColor: Colors.blue[200],
                    onChanged: (value) {
                      if (!_isRunning) {
                        setState(() {
                          _sliderValue = value;
                          _remainingSeconds = (value * 60).toInt();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            
            // **Control Buttons**
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Start/Pause Button
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isRunning
                              ? [Colors.orange[600]!, Colors.orange[400]!]
                              : [Colors.green[600]!, Colors.green[400]!],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: _isRunning ? _stopTimer : _startTimer,
                          child: Center(
                            child: Text(
                              _isRunning ? 'PAUSE' : 'START',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Reset Button (only shows when paused mid-session)
                    if (!_isRunning && _remainingSeconds < _sliderValue * 60)
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: TextButton(
                          onPressed: _resetTimer,
                          child: Text(
                            'RESET',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // **Vibration Intensity Indicator**
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Text(
                    'Vibration Intensity',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: screenWidth * 0.6,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7 + 0.3 * _pulseAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[700]!, Colors.blue[400]!],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}