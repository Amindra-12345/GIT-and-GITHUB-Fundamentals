import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MindoraApp());

const ink = Color(0xFF173A30), green = Color(0xFF236653), sage = Color(0xFFDCE8DC),
    cream = Color(0xFFF6F5EF), muted = Color(0xFF78877E), line = Color(0xFFE3E7DE), gold = Color(0xFFE9C879);

class MindoraApp extends StatelessWidget {
  const MindoraApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Mindora', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: green, surface: const Color(0xFFFFFEFA)),
      appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink, elevation: 0)),
    home: const MindoraShell());
}

class TaskItem { TaskItem(this.title, this.subtitle, {this.high = false, this.done = false}); final String title, subtitle; final bool high; bool done; }

class MindoraShell extends StatefulWidget { const MindoraShell({super.key}); @override State<MindoraShell> createState() => _MindoraShellState(); }
class _MindoraShellState extends State<MindoraShell> {
  int tab = 0, remaining = 1500, focusMinutes = 85; bool running = false; Timer? timer;
  final tasks = <TaskItem>[
    TaskItem('Circuit analysis problem set', 'Today · 5:00 PM', high: true),
    TaskItem('Read chapter 7 — Signals', 'Today · 8:00 PM'),
    TaskItem('Submit lab report', 'Completed', done: true),
  ];
  final docs = ['Signals_Lecture7.pdf', 'Lab_Manual.pdf', 'Past_Paper_2024.pdf'];
  final notes = ['Signals & Systems — Lecture 07', 'Machine Learning — Python notes'];
  final chat = <Map<String,String>>[{'role':'ai','text':'Hi! Ask me about your notes, documents, or study plan.'}];
  final chatCtl = TextEditingController();
  @override void dispose() { timer?.cancel(); chatCtl.dispose(); super.dispose(); }
  void startTimer() { if (running) { timer?.cancel(); setState(() => running=false); return; } setState(() => running=true); timer=Timer.periodic(const Duration(seconds:1),(t){ if(remaining<=0){t.cancel();setState((){running=false;focusMinutes+=25;});}else{setState(()=>remaining--);} }); }
  void resetTimer(){timer?.cancel();setState((){running=false;remaining=1500;});}
  void addTask(){ final c=TextEditingController(); showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Create a task'),content:TextField(controller:c,autofocus:true,decoration:const InputDecoration(hintText:'What do you need to do?')),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancel')),FilledButton(onPressed:(){if(c.text.trim().isNotEmpty)setState(()=>tasks.insert(0,TaskItem(c.text.trim(),'Today · No due time')));Navigator.pop(ctx);},child:const Text('Add task'))])); }
  void sendChat(){final s=chatCtl.text.trim();if(s.isEmpty)return;setState((){chat.add({'role':'me','text':s});chat.add({'role':'ai','text':'This is a UI prototype. Connect the Mindora AI backend to answer from your documents.'});chatCtl.clear();});}
  @override Widget build(BuildContext context){final pages=[dashboard(),taskPage(),focusPage(),libraryPage(),morePage()];return Scaffold(body:SafeArea(child:IndexedStack(index:tab,children:pages)),floatingActionButton:tab==1?FloatingActionButton(onPressed:addTask,backgroundColor:green,foregroundColor:Colors.white,child:const Icon(Icons.add_rounded)):null,bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),backgroundColor:const Color(0xFFFFFEFA),indicatorColor:sage,destinations:const [NavigationDestination(icon:Icon(Icons.grid_view_rounded),label:'Home'),NavigationDestination(icon:Icon(Icons.check_circle_outline_rounded),label:'Tasks'),NavigationDestination(icon:Icon(Icons.timer_outlined),label:'Focus'),NavigationDestination(icon:Icon(Icons.folder_open_rounded),label:'Library'),NavigationDestination(icon:Icon(Icons.more_horiz_rounded),label:'More')]));}
  Widget dashboard()=>ListView(padding:const EdgeInsets.fromLTRB(20,16,20,28),children:[
    Row(children:[Container(width:42,height:42,decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.auto_awesome_rounded,color:Colors.white)),const SizedBox(width:10),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Mindora',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:ink)),Text('YOUR PERSONAL WORKSPACE',style:TextStyle(fontSize:9,letterSpacing:1.5,color:muted,fontWeight:FontWeight.w700))])),IconButton(onPressed:()=>setState(()=>tab=4),icon:const CircleAvatar(radius:18,backgroundColor:sage,child:Text('A',style:TextStyle(color:ink,fontWeight:FontWeight.bold))))]),
    const SizedBox(height:28),const Text('MONDAY, OCTOBER 20',style:TextStyle(color:muted,fontSize:11,letterSpacing:1.3,fontWeight:FontWeight.w700)),const SizedBox(height:7),const Text('Make today\ncount.',style:TextStyle(color:ink,fontSize:36,height:1.05,fontWeight:FontWeight.w800,letterSpacing:-1)),const SizedBox(height:8),const Text('A little progress each day adds up.',style:TextStyle(color:muted,fontSize:14)),const SizedBox(height:22),
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF245F4E), Color(0xFF173D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, size: 14, color: gold),
                SizedBox(width: 5),
                Text(
                  'UP NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            'Circuit analysis\nproblem set',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(Icons.schedule_rounded, size: 15, color: Color(0xFFC3D7C9)),
              SizedBox(width: 6),
              Text(
                '25 min focus session',
                style: TextStyle(color: Color(0xFFC3D7C9), fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => setState(() => tab = 2),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start focus session'),
              style: FilledButton.styleFrom(
                backgroundColor: cream,
                foregroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          )
        ],
      ),
    ),
    const SizedBox(height:14),
    Row(children: [
      Expanded(child: metric(Icons.timelapse_rounded, '$focusMinutes min', 'Focused today', const Color(0xFFE5EEDF))),
      const SizedBox(width:12),
      Expanded(child: metric(Icons.task_alt_rounded, '${tasks.where((task) => task.done).length}/${tasks.length}', 'Tasks completed', const Color(0xFFF2E8D0))),
    ]),
    const SizedBox(height:25),
    header('Today’s priorities', 'View all', () => setState(() => tab = 1)),
    const SizedBox(height:8),
    ...tasks.take(3).map((task) => taskTile(task)),
    const SizedBox(height:18),
    header('Your workspace', 'Explore', () => setState(() => tab = 3)),
    const SizedBox(height:12),
    Row(children: [
      Expanded(child: quick(Icons.auto_awesome_rounded, 'AI assistant', 'Ask your notes', const Color(0xFFE4EDE2), () => setState(() => tab = 4))),
      const SizedBox(width:10),
      Expanded(child: quick(Icons.menu_book_rounded, 'My library', 'Notes & documents', const Color(0xFFF2E8D0), () => setState(() => tab = 3))),
    ]),
  ]);
  Widget metric(IconData icon,String value,String label,Color tint)=>Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20),border:Border.all(color:line)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:tint,borderRadius:BorderRadius.circular(12)),child:Icon(icon,color:green,size:19)),const SizedBox(height:14),Text(value,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:3),Text(label,style:const TextStyle(color:muted,fontSize:11))]));
  Widget header(String title,String action,VoidCallback fn)=>Row(children:[Expanded(child:Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:ink))),TextButton(onPressed:fn,child:Text(action,style:const TextStyle(color:green,fontWeight:FontWeight.w700)))]);
  Widget taskTile(TaskItem task)=>Container(margin:const EdgeInsets.only(bottom:9),padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(17)),child:Row(children:[InkWell(onTap:()=>setState(()=>task.done=!task.done),borderRadius:BorderRadius.circular(30),child:Container(width:24,height:24,decoration:BoxDecoration(color:task.done?green:Colors.transparent,shape:BoxShape.circle,border:Border.all(color:task.done?green:const Color(0xFFB9C9BB),width:1.7)),child:task.done?const Icon(Icons.check,size:15,color:Colors.white):null)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(task.title,style:TextStyle(fontWeight:FontWeight.w700,fontSize:13,color:task.done?muted:ink,decoration:task.done?TextDecoration.lineThrough:null)),const SizedBox(height:4),Text(task.subtitle,style:const TextStyle(fontSize:11,color:muted))])),Container(width:7,height:7,decoration:BoxDecoration(color:task.done?green:task.high?const Color(0xFFC46B50):const Color(0xFFC5A04B),shape:BoxShape.circle))]));
  Widget quick(IconData icon,String title,String subtitle,Color tint,VoidCallback fn)=>InkWell(onTap:fn,borderRadius:BorderRadius.circular(20),child:Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:tint.withValues(alpha: 0.65),borderRadius:BorderRadius.circular(20)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:green,size:23),const SizedBox(height:19),Text(title,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:4),Text(subtitle,style:const TextStyle(fontSize:11,color:muted))])));
  Widget pageHeader(String eyebrow,String title,String subtitle)=>Padding(padding:const EdgeInsets.only(bottom:22),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(eyebrow.toUpperCase(),style:const TextStyle(fontSize:10,letterSpacing:1.5,fontWeight:FontWeight.w800,color:green)),const SizedBox(height:7),Text(title,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w800,letterSpacing:-1,color:ink)),const SizedBox(height:5),Text(subtitle,style:const TextStyle(color:muted,fontSize:13))]));
  Widget taskPage() => ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          pageHeader('Stay on track', 'Your tasks', 'Small steps make meaningful progress.'),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DAILY PROGRESS',
                        style: TextStyle(
                          color: Color(0xFFC3D7C9),
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${tasks.where((task) => task.done).length} of ${tasks.length} completed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: tasks.isEmpty
                              ? 0
                              : tasks.where((task) => task.done).length /
                                  tasks.length,
                          minHeight: 7,
                          backgroundColor: Colors.white24,
                          color: gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.flag_rounded, color: gold, size: 38),
              ],
            ),
          ),
          const SizedBox(height: 22),
          header('All tasks', '${tasks.length} items', () {}),
          const SizedBox(height: 8),
          ...tasks.map(taskTile),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: addTask,
            icon: const Icon(Icons.add),
            label: const Text('Create a new task'),
            style: OutlinedButton.styleFrom(
              foregroundColor: green,
              side: const BorderSide(color: sage),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      );
  Widget focusPage(){final m=(remaining~/60).toString().padLeft(2,'0'),s=(remaining%60).toString().padLeft(2,'0');return ListView(padding:const EdgeInsets.fromLTRB(20,22,20,30),children:[pageHeader('Protect your attention','Focus space','One thing at a time. You’ve got this.'),Container(padding:const EdgeInsets.fromLTRB(20,26,20,22),decoration:BoxDecoration(color:const Color(0xFFE5EDE2),borderRadius:BorderRadius.circular(28)),child:Column(children:[Container(padding:const EdgeInsets.symmetric(horizontal:20,vertical:10),decoration:BoxDecoration(color:Colors.white.withValues(alpha: 0.7),borderRadius:BorderRadius.circular(30)),child:const Text('POMODORO  ·  25 MIN',style:TextStyle(color:green,fontWeight:FontWeight.bold,fontSize:12,letterSpacing:.7))),const SizedBox(height:24),SizedBox(width:238,height:238,child:Stack(alignment:Alignment.center,children:[SizedBox.expand(child:CircularProgressIndicator(value:remaining/1500,strokeWidth:8,backgroundColor:const Color(0xFFC9D8C8),color:green,strokeCap:StrokeCap.round)),Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Text('FOCUS SESSION',style:TextStyle(fontSize:10,letterSpacing:1.8,color:muted,fontWeight:FontWeight.bold)),const SizedBox(height:10),Text('$m:$s',style:const TextStyle(fontSize:48,fontWeight:FontWeight.w800,color:ink,letterSpacing:-2)),const SizedBox(height:5),Text(running?'You’re in the zone':'25-minute focus block',style:const TextStyle(color:muted,fontSize:12))])])),const SizedBox(height:22),Row(children:[Expanded(child:FilledButton.icon(onPressed:startTimer,icon:Icon(running?Icons.pause_rounded:Icons.play_arrow_rounded),label:Text(running?'Pause':'Start focus'),style:FilledButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,padding:const EdgeInsets.symmetric(vertical:15)))),const SizedBox(width:10),IconButton.filledTonal(onPressed:resetTimer,icon:const Icon(Icons.refresh_rounded),style:IconButton.styleFrom(backgroundColor:Colors.white,foregroundColor:green,padding:const EdgeInsets.all(15)))])])),const SizedBox(height:18),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20),border:Border.all(color:line)),child:const Row(children:[CircleAvatar(backgroundColor:sage,child:Icon(Icons.track_changes_rounded,color:green)),SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Current focus',style:TextStyle(fontSize:11,color:muted)),SizedBox(height:4),Text('Circuit analysis problem set',style:TextStyle(fontWeight:FontWeight.bold,color:ink))])),Icon(Icons.chevron_right_rounded,color:muted)])),const SizedBox(height:18),Row(children:[Expanded(child:metric(Icons.local_fire_department_outlined,'3 days','Focus streak',const Color(0xFFF2E8D0))),const SizedBox(width:12),Expanded(child:metric(Icons.timelapse_rounded,'$focusMinutes min','Today’s focus',const Color(0xFFE5EEDF)))])]);}
  Widget libraryPage()=>ListView(padding:const EdgeInsets.fromLTRB(20,22,20,30),children:[pageHeader('Everything in one place','Study library','Your notes and documents, ready when you are.'),TextField(decoration:InputDecoration(prefixIcon:const Icon(Icons.search_rounded),hintText:'Search notes and documents',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))),const SizedBox(height:18),Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:const Color(0xFFE5EDE2),borderRadius:BorderRadius.circular(22)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.auto_awesome_rounded,color:green,size:28),const SizedBox(height:13),const Text('Learn smarter with AI',style:TextStyle(color:ink,fontSize:19,fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('Summarize your study material and ask questions about it.',style:TextStyle(color:muted,fontSize:12,height:1.5)),const SizedBox(height:14),FilledButton.icon(onPressed:()=>setState(()=>tab=4),icon:const Icon(Icons.chat_bubble_outline_rounded),label:const Text('Open AI assistant'),style:FilledButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white))])),const SizedBox(height:22),header('Recent documents','${docs.length} files',()=>{}),const SizedBox(height:8),...docs.map((d)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(18)),child:Row(children:[Container(width:44,height:48,decoration:BoxDecoration(color:const Color(0xFFF2E8D0),borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.picture_as_pdf_outlined,color:Color(0xFF9A7130))),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(d,style:const TextStyle(fontSize:13,color:ink,fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('PDF document · Ready to explore',style:TextStyle(fontSize:11,color:muted))])),const Icon(Icons.more_vert_rounded,color:muted)]))),const SizedBox(height:12),header('My notes','${notes.length} notes',()=>{}),...notes.map((n)=>ListTile(contentPadding:EdgeInsets.zero,leading:const CircleAvatar(backgroundColor:sage,child:Icon(Icons.edit_note_rounded,color:green)),title:Text(n,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:ink)),subtitle:const Text('Edited recently',style:TextStyle(color:muted,fontSize:11)),trailing:const Icon(Icons.chevron_right_rounded)))]);
  Widget morePage()=>ListView(
    padding: const EdgeInsets.fromLTRB(20,22,20,30),
    children: [
      pageHeader('Your space','More','Personalize your Mindora experience.'),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(22),border: Border.all(color: line)),
        child: Row(children:[
          Container(width:58,height:58,decoration:BoxDecoration(color:sage,borderRadius:BorderRadius.circular(19)),child:const Center(child:Text('A',style:TextStyle(fontSize:25,color:green,fontWeight:FontWeight.w800)))),
          const SizedBox(width:14),
          const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('Amindra',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:ink)),
            SizedBox(height:4),
            Text('Personal workspace',style:TextStyle(fontSize:12,color:muted))
          ])),
          const Icon(Icons.edit_outlined,color:green),
        ]),
      ),
      const SizedBox(height:24),
      const Text('WORKSPACE',style:TextStyle(color:muted,fontSize:10,letterSpacing:1.5,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),
      setting(Icons.insights_rounded,'Productivity insights','Review your focus and progress',()=>info('Productivity insights','Connect session storage to show real history and weekly charts.')),
      setting(Icons.calendar_month_rounded,'Calendar & reminders','Keep important dates in view',()=>info('Calendar & reminders','Calendar integration can be added later.')),
      setting(Icons.notifications_none_rounded,'Notifications','Reminders for tasks and focus blocks',()=>info('Notifications','Push notifications require platform setup.')),
      const SizedBox(height:20),
      const Text('PREFERENCES',style:TextStyle(color:muted,fontSize:10,letterSpacing:1.5,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal:15,vertical:4),
        decoration: BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:line)),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value:false,
          onChanged:(v)=>info('Theme preference','Dark mode styling can be connected to the app theme.'),
          title:const Text('Dark appearance',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:ink)),
          subtitle:const Text('Theme preference',style:TextStyle(fontSize:11,color:muted)),
          secondary:const Icon(Icons.dark_mode_outlined,color:green),
        ),
      ),
      const SizedBox(height:18),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color:const Color(0xFFE5EDE2),borderRadius:BorderRadius.circular(18)),
        child: const Row(children:[
          Icon(Icons.auto_awesome_rounded,color:green),
          SizedBox(width:10),
          Expanded(child:Text('Mindora helps you plan, focus, and reflect — one day at a time.',style:TextStyle(color:ink,fontSize:12,height:1.5)))
        ]),
      ),
      const SizedBox(height:20),
      header('AI assistant','Open chat',()=>setState(()=>tab=4)),
      ...chat.map((m)=>Align(
        alignment: m['role']=='me' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom:8),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth:300),
          decoration: BoxDecoration(
            color: m['role']=='me' ? green : sage,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            m['text']!,
            style: TextStyle(color: m['role']=='me' ? Colors.white : ink, fontSize: 13),
          ),
        ),
      )),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatCtl,
              onSubmitted: (_) => sendChat(),
              decoration: InputDecoration(
                hintText: 'Ask your study assistant…',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width:8),
          IconButton.filled(
            onPressed: sendChat,
            icon: const Icon(Icons.send_rounded),
            style: IconButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white),
          ),
        ],
      ),
    ],
  );
  Widget setting(IconData icon,String title,String sub,VoidCallback fn)=>ListTile(onTap:fn,contentPadding:const EdgeInsets.symmetric(horizontal:4,vertical:4),leading:Container(width:42,height:42,decoration:BoxDecoration(color:sage.withValues(alpha: 0.7),borderRadius:BorderRadius.circular(14)),child:Icon(icon,color:green)),title:Text(title,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:ink)),subtitle:Text(sub,style:const TextStyle(fontSize:11,color:muted)),trailing:const Icon(Icons.chevron_right_rounded,color:muted));
  void info(String title,String text)=>showDialog(context:context,builder:(ctx)=>AlertDialog(title:Text(title),content:Text(text),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Close'))]));
}
