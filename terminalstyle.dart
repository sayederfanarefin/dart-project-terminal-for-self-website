

import 'dart:convert' show HtmlEscape;
import 'dart:html';


Terminalstuff t;
void main() {
  t = new Terminalstuff('#input-line', '#output', '#cmdline');
  t.initializeFilesystem(false, 1024 * 1024);
}


class Terminalstuff {
  String cmdLineContainer;
  String outputContainer;
  String cmdLineInput;
  OutputElement output;
  InputElement input;
  DivElement cmdLine;
  String version = '2.1';
  List<String> themes = ['default', 'cream'];
  List<String> history = [];
  int historyPosition = 0;
  Map<String, Function> cmds;
  Map<String, Function> lselem;
  List<String> skills = [];
  List <String> awards = [];
  List<String> planguages = [];
  List<String> contact = [];
  List<String> publicProfiles = [];

  HtmlEscape sanitizer = new HtmlEscape();


  Terminalstuff(this.cmdLineContainer, this.outputContainer, this.cmdLineInput) {
    cmdLine = document.querySelector(cmdLineContainer);
    output = document.querySelector(outputContainer);
    input = document.querySelector(cmdLineInput);


    window.onClick.listen((event) => cmdLine.focus());


    cmdLine.onClick.listen((event) => input.value = input.value);


    cmdLine.onKeyDown.listen(historyHandler);
    cmdLine.onKeyDown.listen(processNewCommand);
  }

  void historyHandler(KeyboardEvent event) {
    var histtemp = "";
    int upArrowKey = 38;
    int downArrowKey = 40;


    if (event.keyCode == upArrowKey || event.keyCode == downArrowKey) {
      event.preventDefault();


      if (historyPosition < history.length) {
        history[historyPosition] = input.value;
      } else {
        histtemp = input.value;
      }
    }

    if (event.keyCode == upArrowKey) {
      historyPosition--;
      if (historyPosition < 0) {
        historyPosition = 0;
      }
    } else if (event.keyCode == downArrowKey) {
      historyPosition++;
      if (historyPosition >= history.length) {
        historyPosition = history.length - 1;
      }
    }


    if (event.keyCode == upArrowKey || event.keyCode == downArrowKey) {

      input.value = history[historyPosition] != null ? history[historyPosition]  : histtemp;
    }
  }

  void processNewCommand(KeyboardEvent event) {
    int enterKey = 13;
    int tabKey = 9;

    if (event.keyCode == tabKey) {
      event.preventDefault();
    } else if (event.keyCode == enterKey) {

      if (!input.value.isEmpty) {
        history.add(input.value);
        historyPosition = history.length;
      }

      DivElement line = input.parent.parent.clone(true);
      line.attributes.remove('id');
      line.classes.add('line');
      InputElement cmdInput = line.querySelector(cmdLineInput);
      cmdInput.attributes.remove('id');
      cmdInput.autofocus = false;
      cmdInput.readOnly = true;
      output.children.add(line);
      String cmdline = input.value;
      input.value = ""; // clear input


      List<String> args;
      String cmd = "";
      if (!cmdline.isEmpty) {
        cmdline.trim();
        args = sanitizer.convert(cmdline).split(' ');
        cmd = args[0];
        args.removeRange(0, 1);
      }


      if (cmds[cmd] is Function) {
        cmds[cmd](cmd, args);
      } else {
        writeOutput('${sanitizer.convert(cmd)}: command not found');
      }

      window.scrollTo(0, window.innerHeight);
    }
  }

  void initializeFilesystem(bool persistent, int size) {
    cmds = {
      'ls': lsCommand,
      'contact': contactCommand,
      'clear': clearCommand,
      'help': helpCommand,
      'version': versionCommand,
      //'cd': cdCommand,
      'date': dateCommand,

      'who': whoCommand,
      'theme': themeCommand
    };
    lselem = {
      'skills': skillsCommand,
      'planguages': languagesCommand,
      'awards': awardsCommand,

      'publicProfiles' : publicProfileCommand
    };
    skills = ['android app development', 'windows universal & nativ app development' , 'microsoft azure', 'web development'];
    planguages = ['java', 'php', 'python', 'dart', 'ruby','c#'];
    contact = ['+8801521107480' , 'erfanjordison@gmail.com', 'fb.com/erfanarefin'];
    publicProfiles = ['github.com/sayederfanarefin','sayederfanarefin.wordpress.com','mva.microsoft.com/Profile.aspx?alias=2603111', 'bd.linkedin.com/in/sayederfanarefin','www.codecademy.com/SayedErfanArefin'];
    awards = ['winner national hackathon 2014', 'runners up aust enginues 2015', '2nd runenrs up dhaka university inter university quiz ' ,'etc....'];

    writeOutput('<div>Welcome to erfan`s website! </div>');
    writeOutput(new DateTime.now().toLocal().toString());
    writeOutput('<p>type necessary commands in this terminal <br> or type "help" to know more about the available commands</p>');
  }

  void skillsCommand() {
    writeOutput('<br>');
    StringBuffer sb = new StringBuffer();
    skills.forEach((key) => sb.write('$key<br>'));
    writeOutput(sb.toString());
    writeOutput('Want to know more? PLease browse to experiences > skills');
  }
  void languagesCommand() {
    writeOutput('<br>');
    StringBuffer sb = new StringBuffer();
    planguages.forEach((key) => sb.write('$key<br>'));
    writeOutput(sb.toString());

  }
  void awardsCommand() {
    writeOutput('<br>');
    StringBuffer sb = new StringBuffer();
    awards.forEach((key) => sb.write('$key<br>'));
    writeOutput(sb.toString());
    writeOutput('Want to know more? PLease browse to awards & honors');
  }
  void contactCommand() {
    writeOutput('<br>');
    StringBuffer sb = new StringBuffer();
    contact.forEach((key) => sb.write('$key<br>'));
    writeOutput(sb.toString());

  }
  void publicProfileCommand() {
    writeOutput('<br>');
    StringBuffer sb = new StringBuffer();
    publicProfiles.forEach((key) => sb.write('$key<br>'));
    writeOutput(sb.toString());
    writeOutput('Want to know more? PLease browse to experiences > Public Profiles');
  }


  void filesystemNotInitialized(String cmd, List<String> args) {
    writeOutput('<div>${sanitizer.convert(cmd)}: not available since filesystem was not initialized</div>');
  }



  void errorHandler(error) {
    var msg = '';
    switch (error.code) {
      case FileError.QUOTA_EXCEEDED_ERR:
        msg = 'QUOTA_EXCEEDED_ERR';
        break;
      case FileError.NOT_FOUND_ERR:
        msg = 'NOT_FOUND_ERR';
        break;
      case FileError.SECURITY_ERR:
        msg = 'SECURITY_ERR';
        break;
      case FileError.INVALID_MODIFICATION_ERR:
        msg = 'INVALID_MODIFICATION_ERR';
        break;
      case FileError.INVALID_STATE_ERR:
        msg = 'INVALID_STATE_ERR';
        break;
      case FileError.TYPE_MISMATCH_ERR:
        msg = 'TYPE_MISMATCH_ERR';
        break;
      default:
        msg = 'FileError = ${error.code}: Error not handled';
        break;
    };
    writeOutput('<div>Error: ${sanitizer.convert(msg)}</div>');
  }

  void invalidOpForEntryType(FileError error, String cmd, String dest) {
    switch (error.code) {
      case FileError.NOT_FOUND_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: No such file or directory<br>');
        break;
      case FileError.INVALID_STATE_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: Not a directory<br>');
        break;
      case FileError.INVALID_MODIFICATION_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: File already exists<br>');
        break;
      default:
        errorHandler(error);
        break;
    }
  }
  void themeCommand(String cmd, List<String> args) {
    var theme = args.join(' ').trim();
    if (theme.isEmpty) {
      writeOutput('missing args. available arguments: ${sanitizer.convert(cmd)} ${sanitizer.convert(themes.toString())}');
    } else {
      if (themes.contains(theme)) {
        setTheme(theme);
      } else {
        writeOutput('Error - Unrecognized theme used');
      }
    }
  }

  void setTheme([String theme='default']) {
    if (theme == null || theme == 'default') {
      window.localStorage.remove('theme');
      document.body.classes.clear();
    } else {
      document.body.classes.add(theme);
      window.localStorage['theme'] = theme;
    }
  }




  void clearCommand(String cmd, List<String> args) {
    output.innerHtml = '';
  }

  void helpCommand(String cmd, List<String> args) {
    StringBuffer sb = new StringBuffer();
    sb.write('<div class="ls-files">');
    cmds.keys.forEach((key) => sb.write('$key<br>'));

    sb.write('</div>');
    writeOutput(sb.toString());

    writeOutput('<br>note: try using the "ls" command');
  }

  void versionCommand(String cmd, List<String> args) {
    writeOutput("$version");
  }


  void cdCommand(String cmd, List<String> args) {

  }

  void dateCommand(String cmd, var args) {
    writeOutput(new DateTime.now().toLocal().toString());
  }

  StringBuffer formatColumns(List<Entry> entries) {
    var maxName = entries[0].name;
    entries.forEach((entry) {
      if (entry.name.length > maxName.length) {
        maxName = entry.name;
      }
    });

    // If we have 3 or less entires, shorten the output container's height.
    var height = entries.length <= 3 ? 'height: ${entries.length}em;' : '${entries.length ~/ 3}em';
    var colWidth = "${maxName.length}em";
    StringBuffer sb = new StringBuffer();
    sb.write('<div class="ls-files" style="-webkit-column-width: $colWidth; height: $height">');
    return sb;
  }


  void lsCommand(String cmd, List<String> args) {
    if(args.length==0){
      writeOutput('missing arg: Please provide an argument. Available arguments:<br><br>');
      StringBuffer sb = new StringBuffer();
      sb.write('<div class="ls-files">');
      lselem.keys.forEach((key) => sb.write('$key<br>'));
      sb.write('</div>');
      writeOutput(sb.toString());
    }else{
      if(lselem.containsKey(args[0])){

        lselem.keys.forEach((key) => checker(args[0], key ));
      }else{
        writeOutput('wrong arg: please enter a valid argument');
      }
    }


  }

  void checker(String arg, String key){
    if(arg == key){
      lselem[key]();
    }
  }




  void whoCommand(String cmd, List<String> args) {
    writeOutput('Hello! This is Sayed Erfan Arefin. A guy from Dhaka, Bangladesh. He is mainly a computer science guy. In this website, you will get to know him. ( -_- )');
  }

  void writeOutput(String h) {
    output.insertAdjacentHtml('beforeEnd', h);
  }
}
