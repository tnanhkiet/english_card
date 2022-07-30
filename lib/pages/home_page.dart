import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_card/models/english_today.dart';
import 'package:english_card/packages/quote/quote.dart';
import 'package:english_card/packages/quote/quote_model.dart';
import 'package:english_card/pages/all_words_page.dart';
import 'package:english_card/pages/control_page.dart';
import 'package:english_card/values/app_assets.dart';
import 'package:english_card/values/app_colors.dart';
import 'package:english_card/values/app_styles.dart';
import 'package:english_card/values/shared_key.dart';
import 'package:english_card/widgets/app_button.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _curentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  String quote = Quotes().getRandom().content!;

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    final prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(SharedKey.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    for (var index in rans) {
      newList.add(nouns[index]);
    }
    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English today',
          style: AppStyles.h4.copyWith(
            color: AppColors.textColor,
            fontSize: 36,
          ),
        ),
        leading: RawMaterialButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            height: size.height * 1 / 10,
            child: AutoSizeText(
              '“$quote”',
              style: AppStyles.h5.copyWith(
                fontSize: 12,
                color: AppColors.textColor,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 2 / 3,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _curentIndex = index;
                  });
                },
                itemCount: words.length >= 5 ? 6 : words.length,
                itemBuilder: (context, index) {
                  String firstLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  firstLetter = firstLetter.substring(0, 1);

                  String leftLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  leftLetter = leftLetter.substring(1, leftLetter.length);

                  String quoteDefault =
                      'Think of all the beauty still left around you and be happy.';

                  String quote = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: AppColors.primaryColor,
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: index >= 5
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AllWordsPage(
                                                words: words,
                                              )));
                                },
                                child: Center(
                                  child: Text(
                                    'Show more...',
                                    style: AppStyles.h3.copyWith(
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(3, 6),
                                            blurRadius: 6,
                                          )
                                        ]),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LikeButton(
                                    onTap: (bool isLiked) async {
                                      setState(() {
                                        words[index].isFavorite =
                                            !words[index].isFavorite;
                                      });
                                      return words[index].isFavorite;
                                    },
                                    isLiked: words[index].isFavorite,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    size: 42,
                                    circleColor: CircleColor(
                                        start: Color(0xff00ddff),
                                        end: Color(0xff0099cc)),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return ImageIcon(
                                        AssetImage(AppAssets.heart),
                                        color:
                                            isLiked ? Colors.red : Colors.white,
                                        size: 42,
                                      );
                                    },
                                  ),
                                  // Container(
                                  //   alignment: Alignment.centerRight,
                                  //   child: Image.asset(AppAssets.heart,
                                  //       color: words[index].isFavorite
                                  //           ? Colors.red
                                  //           : Colors.white),
                                  // ),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: firstLetter,
                                          style: AppStyles.h1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                const BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6,
                                                ),
                                              ]),
                                        ),
                                        TextSpan(
                                          text: leftLetter,
                                          style: AppStyles.h2.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 62,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 37),
                                    child: Text(
                                      '"$quote"',
                                      style: AppStyles.h4.copyWith(
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: 12,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, intdex) {
                  return buildIndicator(intdex == _curentIndex, size);
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        backgroundColor: AppColors.primaryColor,
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lighBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 22),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Favorites',
                  onTap: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Your Control',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ControlPage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(2, 3),
            blurRadius: 3,
          ),
        ],
      ),
    );
  }

// --------------------------------Indicator Show More------------------------------------------------
  // Widget buildShowMore() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //     alignment: Alignment.centerLeft,
  //     child: Material(
  //       borderRadius: const BorderRadius.all(Radius.circular(24)),
  //       color: AppColors.primaryColor,
  //       elevation: 4,
  //       child: InkWell(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => AllWordsPage(
  //                 words: words,
  //               ),
  //             ),
  //           );
  //         },
  //         splashColor: Colors.black38,
  //         borderRadius: const BorderRadius.all(Radius.circular(24)),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 24,
  //             vertical: 12,
  //           ),
  //           child: Text(
  //             'Show more',
  //             style: AppStyles.h5,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
