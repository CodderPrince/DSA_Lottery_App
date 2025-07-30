// Flutter app implementing DSA Lottery with student names, colorful UI, and styled PDF output

import 'dart:math';
import 'package:cgpa_calculator/MyAppBar18.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() => runApp(const DSALotteryApp());

class DSALotteryApp extends StatelessWidget {
  const DSALotteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSA Project Lottery',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LotteryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Project {
  final String id;
  final String name;
  const Project({required this.id, required this.name});
}

class Assignment {
  final String studentId;
  final String studentName;
  final Project project;
  Assignment({required this.studentId, required this.studentName, required this.project});
}

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  State<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  final List<Map<String, String>> students = [
    {"id": "12105001", "name": "MD. FUAD HASAN BASHAR"},
    {"id": "12105002", "name": "SAMANTA BUSHRA"},
    {"id": "12105003", "name": "S.M. MUBASHSHIR AL KASSHAF"},
    {"id": "12105004", "name": "MST. MANIZA KADRIN MIRA"},
    {"id": "12105005", "name": "BINOY BARMAN"},
    {"id": "12105006", "name": "S. M. SULTAN BORHAN UDDIN"},
    {"id": "12105007", "name": "MD. AN NAHIAN PRINCE"},
    {"id": "12105008", "name": "MD. AHSAN HABIB"},
    {"id": "12105009", "name": "SHITHI RANI ROY"},
    {"id": "12105010", "name": "ISMAIL HOSSEN"},
    {"id": "12105011", "name": "DIBOS KUMAR RAY"},
    {"id": "12105012", "name": "BIJOY CHANDRA"},
    {"id": "12105013", "name": "MD. SABBIR MIAH"},
    {"id": "12105014", "name": "MD. ESTIAK AHMMED NIMON"},
    {"id": "12105015", "name": "MD. RASHEL ISLAM"},
    {"id": "12105016", "name": "BIPUL CHANDRA SARKER"},
    {"id": "12105017", "name": "RIMTI KARMOKAR"},
    {"id": "12105018", "name": "PROVASH ROY"},
    {"id": "12105019", "name": "MD. MORSALIN ISLAM"},
    {"id": "12105021", "name": "MD. RAKIBUL HASAN"},
    {"id": "12105024", "name": "ANUPAM ROY"},
    {"id": "12105026", "name": "MD. RAKIBUL ISLAM"},
    {"id": "12105027", "name": "MD. RUHAN BABU"},
    {"id": "12105028", "name": "MST. MUHTARIMA HAQUE"},
    {"id": "12105029", "name": "DEWAN MD. SAFAET-E-RABBI"},
    {"id": "12105030", "name": "MD. RAKIBUL HASAN RIYAD"},
    {"id": "12105031", "name": "MD. MINHAJUL HAQUE TANZIM"},
    {"id": "121050232", "name": "MARZIA DIYA KHAN"},
    {"id": "12105034", "name": "MD. HABIBUL BASHAR"},
    {"id": "12105035", "name": "MD. MAHIR LABIB"},
    {"id": "12105037", "name": "MD. FAYSHAL BIN AMIR PRODHAN"},
    {"id": "12105038", "name": "MD. MOJAHID HOSSAIN"},
    {"id": "12105039", "name": "SIMANTO CHAKROBORTTY"},
    {"id": "12105040", "name": "NAZMUS SAKIB MONDAL"},
    {"id": "12105042", "name": "MD. SAKIB HASAN"},
    {"id": "12105043", "name": "FEDOUS MIA"},
    {"id": "12105045", "name": "SHAKILA ALAM AISHY"},
    {"id": "12105047", "name": "DULAL CHANDRA SHARMA"},
    {"id": "12105048", "name": "MAHMUDUL HASSAN"},
    {"id": "12005012", "name": "Md. Fazle Rabbi"},
    {"id": "12005023", "name": "Md. Atikur Islam"},
    {"id": "12005029", "name": "Most. Afsana Mimi"},
    {"id": "12005031", "name": "Md. Mahamudul Hasan"},
    {"id": "12005034", "name": "Ramjan Hossain"},
    {"id": "12005043", "name": "Munib Mubashsir Shishir"},
  ];

  final List<Project> projects = [
    Project(id: '7', name: 'City Traffic Flow Analyzer'),
    Project(id: '9', name: 'Multimedia File Indexer'),
    Project(id: '10', name: 'Job Scheduling Visualizer'),
    Project(id: '11', name: 'Network Packet Routing Simulator'),
    Project(id: '12', name: 'Directory Tree Visualizer'),
  ];

  List<Assignment> assignments = [];
  bool isLoading = false;

  final Map<String, Color> projectLightColorMap = {};
  final Map<String, PdfColor> pdfProjectColorMap = {};
  final Map<String, Color> projectDarkColorMap = {};
  final random = Random();

  final List<Color> lightColors = [

    Color.fromRGBO(255, 233, 148, 1.0),
    Color.fromRGBO(232, 215, 251, 1.0),
    Color.fromRGBO(236, 255, 140, 1.0),
    Color.fromRGBO(200, 255, 233, 1.0),
    Color.fromRGBO(254, 254, 254, 1.0),
    //Color.fromRGBO(178, 178, 178, 1.0),
    Color(0xFFFFECB3), // Light Amber

  ];

  final List<Color> darkColors = [
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.teal,
  ];

  Color getRandomDarkColor() {
    return darkColors[random.nextInt(darkColors.length)];
  }

  PdfColor convertToPdfColor(Color color) {
    return PdfColor.fromInt(color.value);
  }

  void runLottery() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final shuffledStudents = [...students]..shuffle(random);
    final shuffledProjects = [...projects]..shuffle(random);

    List<Assignment> results = [];
    for (int i = 0; i < shuffledStudents.length; i++) {
      final student = shuffledStudents[i];
      final project = shuffledProjects[i % shuffledProjects.length];
      results.add(Assignment(
          studentId: student['id']!,
          studentName: student['name']!,
          project: project));
    }

    projectLightColorMap.clear();
    pdfProjectColorMap.clear();
    projectDarkColorMap.clear();

    for (int i = 0; i < projects.length; i++) {
      final lightColor = lightColors[i % lightColors.length];
      final darkColor = getRandomDarkColor();
      projectLightColorMap[projects[i].id] = lightColor;
      pdfProjectColorMap[projects[i].id] = convertToPdfColor(lightColor);
      projectDarkColorMap[projects[i].id] = darkColor;
    }

    setState(() {
      assignments = results;
      isLoading = false;
    });
  }

  void generatePdf() async {
    final pdf = pw.Document();

    // Sort assignments by original student order
    List<Assignment> orderedAssignments = [];
    for (var student in students) {
      final match = assignments.firstWhere(
            (a) => a.studentId == student['id'],
        orElse: () => Assignment(
          studentId: student['id']!,
          studentName: student['name']!,
          project: Project(id: '-', name: 'Not Assigned'),
        ),
      );
      orderedAssignments.add(match);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> rows = [];

          // Table Header
          rows.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
              children: [
                pw.Center(
                  child: pw.Text(
                    'Student ID',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Student Name',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Project ID',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Project Name',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );

          // Table Rows
          for (var assignment in orderedAssignments) {
            final pdfColor =
                pdfProjectColorMap[assignment.project.id] ?? PdfColors.grey300;

            rows.add(
              pw.TableRow(
                decoration: pw.BoxDecoration(color: pdfColor),
                children: [
                  pw.Center(
                    child: pw.Text(
                      assignment.studentId,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      assignment.studentName,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      assignment.project.id,
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Center(
                    child: pw.Container(
                      width: double.infinity,
                      child: pw.Text(
                        assignment.project.name,
                        textAlign: pw.TextAlign.center,
                        maxLines: 1,
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return [
            pw.Center(
              child: pw.Text(
                'DSA Project Assignments',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey700,
                width: 0.5,
              ),
              children: rows,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }


  @override
  void initState() {
    super.initState();
    for (var project in projects) {
      projectDarkColorMap[project.id] = getRandomDarkColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text('Project Assignment Lottery')),
      appBar: MyAppBar18(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Projects:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: projects.map((p) => ListTile(
                leading: const Icon(Icons.assignment),
                title: Text(
                  p.name,
                  style: TextStyle(fontWeight: FontWeight.bold, color: projectDarkColorMap[p.id] ?? getRandomDarkColor()),
                ),
                subtitle: Text('Project ID: ${p.id}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15),),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : runLottery,
                icon: const Icon(Icons.casino),
                label: const Text('🎲 Draw Lottery'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading && assignments.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  final cardColor = projectLightColorMap[assignment.project.id] ?? Colors.grey.shade200;
                  return Card(
                    color: cardColor,
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text('${assignment.studentName}\nID: ${assignment.studentId}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(
                              0, 34, 255, 1.0))),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Project ID: ${assignment.project.id}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            'Project: ${assignment.project.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            if (!isLoading && assignments.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: generatePdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export to PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
