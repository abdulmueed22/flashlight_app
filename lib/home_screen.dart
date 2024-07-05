import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Color bigButtonColor = Color(0xFF312C27);
  Color midButtonColor = Color(0xFF484242);
  Color smallButtonColor = Color(0xFF504847);
  bool isOn = false;
  bool _isColorChanged = false;

  late AnimationController controller;
  Animation<Color?>? colorAnimationBigButton;
  Animation<Color?>? colorAnimationMidButton;
  Animation<Color?>? colorAnimationSmallButton;

  void _changeColor() {
    if (_isColorChanged) {
      controller.reverse();
    } else {
      controller.forward();
    }
    _isColorChanged = !_isColorChanged;
  }

  @override
  void initState() {
    super.initState();
    _isTorchAvailable(context);
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    colorAnimationBigButton = ColorTween(
      begin: bigButtonColor,
      end: Color(0xFF312C27).withOpacity(0.3),
    ).animate(controller);

    colorAnimationMidButton = ColorTween(
      begin: midButtonColor,
      end: Color(0xFFFF8E01).withOpacity(0.4),
    ).animate(controller);

    colorAnimationSmallButton = ColorTween(
      begin: smallButtonColor,
      end: Color(0xFFFF8E01),
    ).animate(controller);

    controller.addListener(() {
      setState(() {
        bigButtonColor = colorAnimationBigButton?.value ?? bigButtonColor;
        midButtonColor = colorAnimationMidButton?.value ?? midButtonColor;
        smallButtonColor = colorAnimationSmallButton?.value ?? smallButtonColor;
      });
    });
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (e) {
      print(e);
      showMessage(context, 'Could not check if the device has an available torch');
      rethrow;
    }
  }

  Future<void> torchLight(BuildContext context) async {
    if (isOn) {
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        showMessage(context, 'Could not enable torch');
      }
    } else {
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        showMessage(context, 'Could not disable torch');
      }
    }
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Alert',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          content: Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF333333),
        title: Text('Flash App', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Icon(
                (isOn) ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                size: 100,
                color: (isOn) ? Color(0xFFFF8E01) : Color(0xFF504847),
              ),
              SizedBox(height: 50),
              Text(
                (isOn) ? 'FlashLight : ON' : 'FlashLight : OFF',
                style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleContainer(
                    w: 300,
                    h: 300,
                    color: (isOn)
                        ? Color(0xFF312C27).withOpacity(0.3)
                        : bigButtonColor,
                  ),
                  CircleContainer(
                    w: 260,
                    h: 260,
                    color: (isOn)
                        ? Color(0xFFFF8E01).withOpacity(0.4)
                        : midButtonColor,
                  ),
                  Container(
                    width: 190,
                    height: 190,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isOn = !isOn;
                          _changeColor();
                          torchLight(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.power_settings_new,
                          size: 170,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        backgroundColor:
                        (isOn) ? Color(0xFFFF8E01) : smallButtonColor,
                        foregroundColor:
                        (isOn) ? Color(0xFF504847) : Color(0xFFFF8E01),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    required this.w,
    required this.h,
    required this.color,
  });

  final double w;
  final double h;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

