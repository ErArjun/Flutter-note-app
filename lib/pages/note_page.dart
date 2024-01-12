import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/components/drawer.dart';
import 'package:note/components/note_tile.dart';
import 'package:note/models/note.dart';
import 'package:note/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

// on startup,fetch the existing notes
    readNotes();
  }

  //create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              //add to the db
              if (textController.text.isEmpty) {
                return;
              }
              context.read<NoteDatabase>().addNote(textController.text);

              //clear the controller
              textController.clear();

              //pop dialogue box
              Navigator.pop(context);
            },
            child: const Text('create'),
          )
        ],
      ),
    );
  }

  //read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNotes(Note note) {
    //pre-fill the current note text
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Note!'),
        content: TextField(controller: textController),
        actions: [
          //updateButton
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);

              //clear the controller
              textController.clear();

              //pop dialogue box
              Navigator.pop(context);
            },
            child: const Text('update'),
          ),
        ],
      ),
    );
  }

  //delete a node
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    //note db
    final noteDatabases = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabases.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNote(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          //list of notes

          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                //get individual notes
                final note = currentNotes[index];

                //list tile ui
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNotes(note),
                  onDeletePressed: () => deleteNote(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
