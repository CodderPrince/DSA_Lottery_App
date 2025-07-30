import 'dart:math';
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
  final Project project;
  Assignment({required this.studentId, required this.project});
}

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  State<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  final List<String> studentIds = [
    '12105001', '12105002', '12105003', '12105004', '12105005', '12105006',
    '12105007', '12105008', '12105009', '12105010', '12105011', '12105012',
    '12105013', '12105014', '12105015', '12105016', '12105017', '12105018',
    '12105019', '12105021', '12105024', '12105026', '12105027', '12105028',
    '12105029', '12105030', '12105031', '121050232', '12105034', '12105035',
    '12105037', '12105038', '12105039', '12105040', '12105042', '12105043',
    '12105045', '12105046', '12105047', '12105048', '12005012', '12005023',
    '12005029', '12005031', '12005034', '12005043',
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

  final Map<String, Color> projectColorMap = {};
  final Map<String, PdfColor> pdfProjectColorMap = {};

  Color getRandomLightColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      180 + random.nextInt(75),
      180 + random.nextInt(75),
      180 + random.nextInt(75),
    );
  }

  PdfColor getRandomLightPdfColor() {
    final random = Random();
    return PdfColor.fromInt(0xFF000000 +
        (180 + random.nextInt(75)) * 0x10000 +
        (180 + random.nextInt(75)) * 0x100 +
        (180 + random.nextInt(75)));
  }

  void runLottery() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    final random = Random();
    final shuffledStudents = [...studentIds]..shuffle(random);
    final shuffledProjects = [...projects]..shuffle(random);

    List<Assignment> results = [];
    for (int i = 0; i < shuffledStudents.length; i++) {
      final project = shuffledProjects[i % shuffledProjects.length];
      results.add(Assignment(studentId: shuffledStudents[i], project: project));
    }

    projectColorMap.clear();
    pdfProjectColorMap.clear();
    for (var project in projects) {
      projectColorMap[project.id] = getRandomLightColor();
      pdfProjectColorMap[project.id] = getRandomLightPdfColor();
    }

    setState(() {
      assignments = results;
      isLoading = false;
    });
  }

  void generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> rows = [];

          rows.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
              children: [
                pw.Center(
                    child: pw.Text('Student ID',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold))),
                pw.Center(
                    child: pw.Text('Project ID',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold))),
                pw.Center(
                    child: pw.Text('Project Name',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold))),
              ],
            ),
          );

          for (var assignment in assignments) {
            final pdfColor = pdfProjectColorMap[assignment.project.id]!;
            rows.add(
              pw.TableRow(
                decoration: pw.BoxDecoration(color: pdfColor),
                children: [
                  pw.Center(child: pw.Text(assignment.studentId)),
                  pw.Center(child: pw.Text(assignment.project.id)),
                  pw.Center(child: pw.Text(assignment.project.name)),
                ],
              ),
            );
          }

          return [
            pw.Center(
              child: pw.Text('DSA Project Assignments',
                  style: pw.TextStyle(fontSize: 24, color: PdfColors.deepPurple)),
            ),
            pw.SizedBox(height: 20),
            pw.Table(border: pw.TableBorder.all(), children: rows),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Assignment Lottery')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Projects:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: projects
                    .map((p) => ListTile(
                  leading: const Icon(Icons.assignment),
                  title: Text(
                    p.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getRandomLightColor(),
                    ),
                  ),
                  subtitle: Text('Project ID: ${p.id}'),
                ))
                    .toList(),
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
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
              if (!isLoading && assignments.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    final cardColor =
                        projectColorMap[assignment.project.id] ?? Colors.deepPurple.shade50;
                    return Card(
                      color: cardColor,
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text('Student ID: ${assignment.studentId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Project ID: ${assignment.project.id}'),
                            Text('Project: ${assignment.project.name}'),
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
