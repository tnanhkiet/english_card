import 'package:english_card/values/app_assets.dart';
import 'package:english_card/values/app_colors.dart';
import 'package:english_card/values/app_styles.dart';
import 'package:english_card/values/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;

  // ignore: prefer_typing_uninitialized_variables
  late final prefs;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(SharedKey.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.secondColor,
        appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          title: Text(
            'Your Control',
            style: AppStyles.h4.copyWith(
              color: AppColors.textColor,
              fontSize: 36,
            ),
          ),
          leading: RawMaterialButton(
            onPressed: () async {
              await prefs.setInt(SharedKey.counter, sliderValue.toInt());
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.leftArrow),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 66),
                child: Text(
                  'How much a number word at once?',
                  style: AppStyles.h4.copyWith(
                    color: AppColors.lightGrey,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                '${sliderValue.toInt()}',
                style: AppStyles.h1.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 144,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 27),
                child: Slider(
                    value: sliderValue,
                    min: 5,
                    max: 100,
                    divisions: 95,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 40),
                child: Text(
                  'slide to set',
                  style: AppStyles.h4.copyWith(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
