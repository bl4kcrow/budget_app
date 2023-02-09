import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  const ExpenseViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);

    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomesStream();
      isLoading = false;
    }

    double deviceWidth = MediaQuery.of(context).size.width;
    int totalExpense = 0;
    int totalIncome = 0;

    void calculate() {
      for (int i = 0; i < viewModelProvider.expensesAmount.length; i++) {
        totalExpense =
            totalExpense + int.parse(viewModelProvider.expensesAmount[i]);
      }

      for (int i = 0; i < viewModelProvider.incomesAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(viewModelProvider.incomesAmount[i]);
      }
    }

    calculate();

    int budgetLeft = totalIncome - totalExpense;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                viewModelProvider.reset();
              },
              icon: const Icon(Icons.refresh),
            )
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30.0,
          ),
          title: const Poppins(
            text: 'Dashboard',
            size: 20.0,
            color: Colors.white,
          ),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.black),
                  ),
                  child: CircleAvatar(
                    radius: 180.0,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/logo.png',
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              MaterialButton(
                color: Colors.black,
                elevation: 20.0,
                height: 50.0,
                minWidth: 200.0,
                onPressed: () async {
                  viewModelProvider.logout();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const OpenSans(
                  text: 'Logout',
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async => launchUrl(
                      Uri.parse('https://instagram.com'),
                    ),
                    icon: SvgPicture.asset(
                      'assets/instagram.svg',
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () async => launchUrl(
                      Uri.parse('https://twitter.com'),
                    ),
                    icon: SvgPicture.asset(
                      'assets/twitter.svg',
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 40.0),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: deviceWidth / 1.5,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Poppins(
                            text: 'Budget left',
                            size: 14,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total expenses',
                            size: 14,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total income',
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        indent: 40.0,
                        endIndent: 40.0,
                        color: Colors.grey,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Poppins(
                            text: budgetLeft.toString(),
                            size: 14,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalExpense.toString(),
                            size: 14,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalIncome.toString(),
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40.0,
                      width: 155.0,
                      child: MaterialButton(
                        color: Colors.black,
                        onPressed: () async {
                          await viewModelProvider.addExpense(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        splashColor: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            OpenSans(
                              text: 'Add Expense',
                              color: Colors.white,
                              size: 14.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    SizedBox(
                      height: 40.0,
                      width: 155.0,
                      child: MaterialButton(
                        color: Colors.black,
                        onPressed: () async {
                          await viewModelProvider.addIncome(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        splashColor: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            OpenSans(
                              text: 'Add Income',
                              color: Colors.white,
                              size: 14.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const OpenSans(
                            text: 'Expenses',
                            size: 15.0,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(7.0),
                            height: 210.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: ListView.builder(
                              itemCount:
                                  viewModelProvider.expensesAmount.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Poppins(
                                      text:
                                          viewModelProvider.expensesName[index],
                                      size: 12.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Poppins(
                                        text: viewModelProvider
                                            .expensesAmount[index],
                                        size: 12.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const OpenSans(
                            text: 'Incomes',
                            size: 15.0,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(7.0),
                            height: 210.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: viewModelProvider.incomesAmount.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Poppins(
                                      text:
                                          viewModelProvider.incomesName[index],
                                      size: 12.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Poppins(
                                        text: viewModelProvider
                                            .incomesAmount[index],
                                        size: 12.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
