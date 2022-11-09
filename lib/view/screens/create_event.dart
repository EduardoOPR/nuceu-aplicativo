import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nuceu/models/event_model.dart';
import 'package:nuceu/services/firebase_api.dart';
import 'package:nuceu/themes/themes.dart';
import 'package:nuceu/view/widgets/colored_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:nuceu/notificationservice.dart';
import '../widgets/navigation_drawer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CreateEvent extends StatefulWidget {
  final bool isEdit;
  final String? documentId;
  final String? documentTitle;
  final String? documentDescription;
  final dynamic documentPhoto;
  final DateTime? documentData;

  const CreateEvent(
      {Key? key,
      this.isEdit = false,
      this.documentId = null,
      this.documentTitle = null,
      this.documentDescription = null,
      this.documentPhoto = null,
      this.documentData = null})
      : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  void  initState(){
    super.initState();

    tz.initializeTimeZones();
  }
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  UploadTask? task;
  File? file;
  bool haveImage = false;
  String caminho = '';
  late DateTime data;
  late TimeOfDay tempo;

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit == true) {
      titleController.text = widget.documentTitle!;
      descriptionController.text = widget.documentDescription!;
      // sobre a imagem
      haveImage = true;
      caminho = widget.documentPhoto!;
      data = widget.documentData!;
      tempo = TimeOfDay(
          hour: widget.documentData!.hour, minute: widget.documentData!.minute);
    }

    final fileName =
        file != null ? Path.basename(file!.path) : 'Nenhum arquivo selecionado';
    return Scaffold(
      drawer: const NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Informações sobre o evento',
            style: Themes.latoRegular(20).copyWith(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Informe o Titulo do Evento',
                textAlign: TextAlign.left,
                style: Themes.latoRegular(16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Titulo',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(height: 1.0),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Breve Descrição do Evento',
                textAlign: TextAlign.left,
                style: Themes.latoRegular(16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 150,
                  child: TextField(
                    //obscureText: true,
                    maxLines: null,
                    expands: true,
                    controller: descriptionController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: '(Procure colocar um \nmínimo de 20 palavras)',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Insira uma Imagem',
                textAlign: TextAlign.left,
                style: Themes.latoRegular(16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: selectFile,
                      child: Container(
                        height: 225,
                        width: 225,
                        color: Colors.grey[400],
                        child: Center(
                          child: haveImage
                              ? Image.network(
                                  caminho,
                                  fit: BoxFit.cover,
                                )
                              : const Text(
                                  '+',
                                  style: TextStyle(fontSize: 25),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColoredButton(
                    text: 'Cancelar',
                    width: 120,
                    ontap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ColoredButton(
                    text: 'Ok',
                    width: 84,
                    ontap: () async {
                      final day = await showDatePicker(
                        context: context,
                        locale: const Locale('pt', 'BR'),
                        initialDate: widget.isEdit ? data : DateTime.now(),
                        firstDate: widget.isEdit ? data : DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      final time = await showTimePicker(
                        context: context,
                        initialTime: widget.isEdit ? tempo : TimeOfDay.now(),
                        cancelText: 'CANCELAR',
                        hourLabelText: 'Hora',
                        minuteLabelText: 'Minuto',
                        helpText: 'ESCOLHA O HORÁRIO',
                      );

                      if (time != null && day != null) {
                        final data = DateTime(day.year, day.month, day.day,
                            time.hour, time.minute);

                        final event = EventModel(
                          titulo: titleController.text,
                          textoInformativo: descriptionController.text,
                          data: data,
                          fotoUrl: caminho,
                        );
                        widget.isEdit == false
                            ? createEvent(event: event)
                            : editEvent(event: event);
                      } else {
                        FocusManager.instance.primaryFocus?.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Data não inserida',
                            style: Themes.latoRegular(20),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.pinkAccent,
                          duration: const Duration(seconds: 2),
                        ));
                      }
                       NotificationService().showNotification(1, "Novo evento disponível!", titleController.text, 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createEvent({required EventModel event}) async {
    try {
      await FirebaseFirestore.instance
          .collection('eventos')
          .add(event.toJson())
          .then((value) async {
        await value.update({'id': value.id});
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/home-screen', (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
    uploadFile();
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = Path.basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    caminho = urlDownload;
    haveImage = true;
    setState(() {});
  }

  Future editEvent({required EventModel event}) async {
    try {
      await FirebaseFirestore.instance
          .collection('eventos')
          .doc(widget.documentId)
          .update(event.toJson());
      Navigator.pushNamedAndRemoveUntil(
          context, '/home-screen', (route) => false);
    } catch (e) {
      print(e);
    }
  }
}
