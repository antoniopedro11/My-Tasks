// Mestrado - Computação Móvel
// ToDo App
// António Velez nº18390 - 07/02/2023
//-----------------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditTasks extends StatefulWidget {
  const EditTasks(
      {Key? key,
      this.title,
      this.description,
      this.dateConclusion,
      this.docs,
      this.id})
      : super(key: key);
  final String? title;
  final String? description;
  final String? dateConclusion;
  final Map<String, dynamic>? docs;
  final String? id;

  @override
  State<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasks> {
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  TextEditingController? _dateConclusion;
  String uid = '';

  @override
  void initState() {
    getuid();
    // TODO: implement initState
    super.initState();
    String title = widget.title!;
    _titleController = TextEditingController(text: title);
    String description = widget.description!;
    _descriptionController = TextEditingController(text: description);
    String date = widget.dateConclusion!;
    _dateConclusion = TextEditingController(text: date);
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  edittasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(widget.id)
        .update({
      'title': _titleController!.text,
      'description': _descriptionController!.text,
      'date conclusion': _dateConclusion!.text,
      'time': time.toString(),
      'timestamp': time
    });
    getuid() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      setState(() {
        uid = user!.uid;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("Tarefa Editada com Sucesso"),
    ));
  }

  deletedTask() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(widget.id)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("Tarefa eliminada com sucesso"),
    ));
  }

  showAlertDialog(BuildContext context) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Continar"),
      onPressed: () async {
        deletedTask();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert Dialog"),
      content: Text("Deseja remover a tarefa ?"),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Insira o Título',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  maxLines: 4,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Insira a Descrição',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  controller: _dateConclusion,
                  decoration: InputDecoration(
                      labelText: 'Data de Conclusão',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue;
                      return Colors.blue;
                    })),
                    child: Text(
                      'Editar Tarefa',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      edittasktofirebase();
                      Navigator.pop(context);
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.redAccent;
                      return Colors.redAccent;
                    })),
                    child: Text(
                      'Apagar Tarefa',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(uid)
                          .collection('mytasks')
                          .doc(widget.id)
                          .delete();
                      getuid() async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        final User? user = auth.currentUser;
                        setState(() {
                          uid = user!.uid;
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Tarefa eliminada com sucesso"),
                      ));
                      Navigator.of(context).pop();
                    },
                  )),
            ],
          )),
    );
  }
}
