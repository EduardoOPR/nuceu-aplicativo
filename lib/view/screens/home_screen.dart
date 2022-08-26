import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:nuceu/utils/dialogs/admin_event_dialog.dart';
import 'package:nuceu/view/widgets/home_screen_widgets/cardhome.dart';
import 'package:nuceu/view/screens/quem_somos.dart';
import 'package:nuceu/view/widgets/home_screen_widgets/pesquisa.dart';
import 'package:nuceu/themes/themes.dart';
import 'package:nuceu/view/widgets/home_screen_widgets/home_bottom_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double slideValue = 5;
  final Timestamp now = Timestamp.fromDate(DateTime.now());
  final bool isLogged =
      FirebaseAuth.instance.currentUser == null ? false : true;
  var bCardColor, sCardColor;
  int colorControl = 0;

  colorSelector() {
    switch (colorControl) {
      case 0:
        bCardColor = 0xFF59968C;
        sCardColor = 0xFF167263;
        colorControl++;
        break;
      case 1:
        bCardColor = 0xFFF99C66;
        sCardColor = 0xFFE46F40;
        colorControl++;
        break;
      case 2:
        bCardColor = 0xFF82BCD7;
        sCardColor = 0xFF348BAA;
        colorControl = 0;
        break;
    }
  }

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
                    style: Themes.latoRegular(19),
                  ),
                  Text(
                    'Como você está se sentindo hoje?',
                    style: Themes.latoLight(19),
                  ),
                ],
              ),
            ),
            const Pesquisa(),
            Padding(
              padding: Themes.paddingHome,
              child: Text(
                'EVENTOS',
                style: Themes.latoExtraBold(20),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('eventos')
                    .where('data', isGreaterThanOrEqualTo: now)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //Animação enquanto estiver carregando
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    );
                  }
                  //Erro ao carregar ou não tem nenhum evento próximo
                  if (snapshot.data!.docs.isEmpty || snapshot.hasError) {
                    return Row(
                      children: [
                        CardHome(
                          id: '',
                          ontap: () {},
                          textoCard: 'Aguardando\nNovos Eventos',
                          dataTextoCard: '',
                          cardColor: const Color(0xFF535353),
                          smallCardColor: const Color(0xFF757575),
                          thereAreEvents: false,
                        ),
                      ],
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      DateTime eventDate = data['data'].toDate();
                      eventDate = eventDate.subtract(const Duration(hours: 3));
                      final String eventDateFormated =
                          DateFormat('kk:mm - dd-MM-yyyy').format(eventDate);
                      colorSelector();
                      return CardHome(
                        id: document.id,
                        ontap: () {
                          if (isLogged) {
                            editEventDialoig(
                                context: context,
                                onView: () {
                                  //mesma função que vai aparecer no else
                                },
                                onDelete: () {
                                  setState(() {
                                    FirebaseFirestore.instance
                                        .collection('eventos')
                                        .doc(document.id)
                                        .delete();
                                  });
                                  Navigator.pop(context);
                                },
                                onEdit: () {
                                  
                                });
                          } else {
                            //Push pra página do evento
                          }
                        },
                        textoCard: data['titulo'].toString(),
                        dataTextoCard: eventDateFormated,
                        cardColor: Color(bCardColor),
                        smallCardColor: Color(sCardColor),
                        thereAreEvents: true,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: Themes.paddingHome,
              child: Text(
                'HOME',
                style: Themes.latoExtraBold(20),
              ),
            ),
            HomeBottomCard(
              colorCard: const Color(0xFF82BCD7),
              colorIconCard: const Color(0xFF348BAA),
              title: 'Conheça-nos',
              icon: Elusive.heart_empty,
              ontap: () {
                Navigator.of(context).pushNamed('/quem-somos');
              },
            ),
            HomeBottomCard(
              colorCard: const Color(0xFF82D78A),
              colorIconCard: const Color(0xFF34AA55),
              title: 'Vídeos informativos',
              icon: Icons.play_circle_outline_outlined,
              ontap: () {
                Navigator.of(context).pushNamed('/videos-screen');
              },
            ),
            HomeBottomCard(
              colorCard: Colors.amber,
              colorIconCard: const Color.fromARGB(255, 145, 110, 7),
              title: 'Teste',
              icon: Icons.cable_sharp,
              ontap: () {},
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