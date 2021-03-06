import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:nuceu/view/widgets/cardhome.dart';
import 'package:nuceu/view/widgets/pesquisa.dart';
import 'package:nuceu/themes/themes.dart';
import 'package:nuceu/view/widgets/home_bottom_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double slideValue = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 60, top: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá,',
                    style: Themes.homeTitlBold,
                  ),
                  Text(
                    'Como você está se sentindo hoje?',
                    style: Themes.homeTitle,
                  ),
                ],
              ),
            ),
            Pesquisa(),
            Padding(
              padding: Themes.paddingHome,
              child: Text(
                'EVENTOS',
                style: Themes.latoBold,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  CardHome(
                    textoCard: 'Plantão \nPsicológico',
                    dataTextoCard: '12, Julho',
                    cardColor: Color(0xFF59968C),
                    smallCardColor: Color(0xFF167263),
                  ),
                  CardHome(
                    textoCard: 'Plantão \nPsicológico',
                    dataTextoCard: '12, Julho',
                    cardColor: Color(0xFFF99C66),
                    smallCardColor: Color(0xFFE46F40),
                  ),
                  CardHome(
                    textoCard: 'Plantão \nPsicológico',
                    dataTextoCard: '12, Julho',
                    cardColor: Color(0xFF82BCD7),
                    smallCardColor: Color(0xFF348BAA),
                  ),
                ],
              ),
            ),
            Padding(
              padding: Themes.paddingHome,
              child: Text(
                'HOME',
                style: Themes.latoBold,
              ),
            ),
            HomeBottomCard(
              colorCard: Color(0xFF82BCD7),
              colorIconCard: Color(0xFF348BAA),
              title: 'Conheça-nos',
              icon: Elusive.heart_empty,
            ),
            HomeBottomCard(
              colorCard: Color(0xFF82D78A),
              colorIconCard: Color(0xFF34AA55),
              title: 'Vídeos informativos',
              icon: Icons.play_circle_outline_outlined,
            ),
            HomeBottomCard(
              colorCard: Colors.amber,
              colorIconCard: Color.fromARGB(255, 145, 110, 7),
              title: 'Teste',
              icon: Icons.cable_sharp,
            ),
          ],
        ),
      ),
    );
  }
}


/*
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Liga para a gente!',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 2.6,
                                letterSpacing: 1,
                              ),
                            ),
                            Icon(
                              Icons.perm_phone_msg_outlined,
                              color: Color(0xFF92E3A9),
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                    */