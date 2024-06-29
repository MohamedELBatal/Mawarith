import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final boysController = TextEditingController();
  final girlsController = TextEditingController();
  final fatherController = TextEditingController();
  final motherController = TextEditingController();
  final husbandController = TextEditingController();
  final wifeController = TextEditingController();
  final brothersController = TextEditingController();
  final sistersController = TextEditingController();
  String? selectedGender;

  double totalAmount = 0;
  int boys = 0;
  int girls = 0;
  int father = 0;
  int mother = 0;
  int husband = 0;
  int wife = 0;
  String result = '';

  final numberFormat = NumberFormat("#,##0", "en_US");

  void showResultDialog(String resultText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: const Text(
            'النتيجة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            resultText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Ok',
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void calculateInheritance() {
    if (formKey.currentState!.validate() && selectedGender != null) {
      setState(() {
        try {
          // Parse totalAmount as double
          double originalTotalAmount = double.parse(amountController.text.replaceAll(',', ''));
          double remainingAmount = originalTotalAmount;

          // Parse other inputs as doubles with default value of 0.0
          num boys = num.parse(boysController.text.isEmpty ? '0' : boysController.text);
          num girls = num.parse(girlsController.text.isEmpty ? '0' : girlsController.text);
          num father = num.parse(fatherController.text.isEmpty ? '0' : fatherController.text);
          num mother = num.parse(motherController.text.isEmpty ? '0' : motherController.text);
          num husband = num.parse(husbandController.text.isEmpty ? '0' : husbandController.text);
          num wife = num.parse(wifeController.text.isEmpty ? '0' : wifeController.text);
          num brothers = num.parse(brothersController.text.isEmpty ? '0' : brothersController.text);
          num sisters = num.parse(sistersController.text.isEmpty ? '0' : sistersController.text);

          // Variables to hold shares (using num for flexibility)
          num boyShare = 0;
          num girlShare = 0;
          num fatherShare = 0;
          num motherShare = 0;
          num husbandShare = 0;
          num wifeShare = 0;
          num brotherShare = 0;
          num sisterShare = 0;

          // Calculate shares based on selected gender
          if (selectedGender == 'ذكر') {
            // حصة الزوجة
            if (wife > 0) {
              if (boys > 0 || girls > 0) {
                wifeShare = remainingAmount * 0.125; // الثمن
              } else {
                wifeShare = remainingAmount * 0.5; // النصف
              }
              remainingAmount -= wifeShare;
            }
            // حصة الأب
            if (father > 0) {
              fatherShare = remainingAmount * 0.1667; // السدس
              remainingAmount -= fatherShare;
            }
            // حصة الأم
            if (mother > 0) {
              motherShare = remainingAmount * 0.1667; // السدس
              remainingAmount -= motherShare;
            }
            // توزيع الباقي على الأخوة إذا لم يكن هناك أولاد أو بنات أو زوجة
            if (boys == 0 && girls == 0 && wife == 0) {
              brotherShare = remainingAmount / (brothers + 1);
              sisterShare = remainingAmount / (sisters + 1);
            }
          } else if (selectedGender == 'أنثى') {
            // حصة الزوج
            if (husband > 0) {
              if (boys > 0 || girls > 0) {
                husbandShare = remainingAmount * 0.25; // الربع
              } else {
                husbandShare = remainingAmount * 0.5; // النصف
              }
              remainingAmount -= husbandShare;
            }
            // حصة الأب
            if (father > 0) {
              fatherShare = remainingAmount * 0.1667; // السدس
              remainingAmount -= fatherShare;
            }
            // حصة الأم
            if (mother > 0) {
              motherShare = remainingAmount * 0.1667; // السدس
              remainingAmount -= motherShare;
            }
            // توزيع الباقي على الأخوات إذا لم يكن هناك أولاد أو بنات أو زوج
            if (boys == 0 && girls == 0 && husband == 0) {
              sisterShare = 0; // عدم تخصيص حصة للأخوات
              brotherShare = 0; // عدم تخصيص حصة للأخوة
            } else {
              sisterShare = remainingAmount / (sisters + 1);
              brotherShare = remainingAmount / (brothers + 1);
            }}

          // Calculate total shares
          num totalShares = boys * 2 + girls + brothers * 2 + sisters;

          // Distribute remaining amount among children and siblings
          if (totalShares > 0) {
            if (boys > 0) {
              boyShare = (remainingAmount * 2) / totalShares;
            }
            if (girls > 0) {
              girlShare = remainingAmount / totalShares;
            }
            if (brothers > 0) {
              brotherShare = (remainingAmount * 2) / totalShares;
            }
            if (sisters > 0) {
              sisterShare = remainingAmount / totalShares;
            }
          }

          // Prepare result text
          List<String> resultList = [];
          if (boyShare > 0) resultList.add('حصة كل ولد: ${numberFormat.format(boyShare)}');
          if (girlShare > 0) resultList.add('حصة كل بنت: ${numberFormat.format(girlShare)}');
          if (fatherShare > 0) resultList.add('حصة الأب: ${numberFormat.format(fatherShare)}');
          if (motherShare > 0) resultList.add('حصة الأم: ${numberFormat.format(motherShare)}');
          if (husbandShare > 0) resultList.add('حصة الزوج: ${numberFormat.format(husbandShare)}');
          if (wifeShare > 0) resultList.add('حصة الزوجة: ${numberFormat.format(wifeShare)}');
          if (brotherShare > 0) resultList.add('حصة كل أخ: ${numberFormat.format(brotherShare)}');
          if (sisterShare > 0) resultList.add('حصة كل أخت: ${numberFormat.format(sisterShare)}');

          String result = resultList.join('\n');

          // Show the result in a dialog
          showResultDialog(result);
        } catch (e) {
          // Handle any parsing errors or other exceptions
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/pattern.png"),fit: BoxFit.cover,
        ),
    color: Colors.transparent),
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          ' المواريث',
          style: GoogleFonts.elMessiri(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'جنس المتوفى',
                    label: Text(
                      "جنس المتوفى",
                      style: GoogleFonts.elMessiri(
                          fontSize: 19.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  value: selectedGender,
                  items: <String>['ذكر', 'أنثى'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // قبول القيم الفارغة
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: amountController,
                  decoration:  InputDecoration(
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    labelText: 'المبلغ الكلي',
                    labelStyle: GoogleFonts.elMessiri(
                      fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final newText = value.replaceAll(',', '');
                    final number = double.tryParse(newText);
                    if (number != null) {
                      amountController.value = TextEditingValue(
                        text: numberFormat.format(number),
                        selection: TextSelection.collapsed(
                            offset: numberFormat.format(number).length),
                      );
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // قبول القيم الفارغة
                    }
                    return null;
                  },

                ),

                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: boysController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد الأولاد',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: girlsController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد البنات',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fatherController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'الاب',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: motherController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'الأم',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: husbandController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد الأزواج',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: wifeController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد الزوجات',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: brothersController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد الأخوة',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: sistersController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          labelText: 'عدد الأخوات',
                          labelStyle: GoogleFonts.elMessiri(
                              fontSize: 19.0, fontWeight: FontWeight.w600// تعديل حجم العنوان هنا
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // قبول القيم الفارغة
                          }
                          return null;
                        },

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                  ),
                  onPressed: calculateInheritance,
                  child: Text(
                    'احسب الميراث',
                    style: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    boysController.dispose();
    girlsController.dispose();
    fatherController.dispose();
    motherController.dispose();
    husbandController.dispose();
    wifeController.dispose();
    super.dispose();
  }
}
