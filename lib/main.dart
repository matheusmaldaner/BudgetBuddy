import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  // passes widget MyApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // this widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Budget Buddy'),
    );
  }
}

void populateList(List<FlSpot> list, int rand) {
  var random = Random(rand);

  // iterates 100,000 times
  if (list.isEmpty) {
    for (int i = 0; i < 100000; ++i) {
      double maxX = random.nextInt(365).toDouble();
      double maxY = random.nextDouble() * 199 + 1;

      list.add(FlSpot(maxX, maxY));
    }
  }
}

// collapse the data: sums up transactions made on the same day and forms a list
List<FlSpot> sumData(List<FlSpot> list) {
  List<FlSpot> temp = [];

  // adds first point
  temp.add(const FlSpot(0, 0));

  // declares two empty maps
  Map<double, double> map = {};
  Map<double, double> mapMonthly = {};

  // populates the maps
  for (var a in list) {

    // first x of is kind is pushed into map
    if (map.containsKey(a.x) == false) {
      map[a.x] = a.y;
    }

    // if that x already exists, add the y components
    else {

      // in case value is null, use zero instead
      double newY = (map[a.x] ?? 0) + a.y;

      map[a.x] = newY;
    }
  }

  // makes subdivisions for each month expenditure
  map.forEach((key, value) {
    double temp = 0;

    // converting to string then back to double to round off to nearest 100th
    // January
    if (key <= 31) {
      temp = (mapMonthly[30.41] ?? 0) + value;
      mapMonthly[30.41] = double.parse(temp.toStringAsFixed(2));
    }

    // February
    else if (key <= 61) {
      temp = (mapMonthly[60.83] ?? 0) + value;
      mapMonthly[60.83] = double.parse(temp.toStringAsFixed(2));
    }

    // March
    else if (key <= 92) {
      temp = (mapMonthly[91.25] ?? 0) + value;
      mapMonthly[91.25] = double.parse(temp.toStringAsFixed(2));
    }

    // April
    else if (key <= 122) {
      temp = (mapMonthly[122] ?? 0) + value;
      mapMonthly[122] = double.parse(temp.toStringAsFixed(2));
    }

    // May
    else if (key <= 153) {
      temp = (mapMonthly[153] ?? 0) + value;
      mapMonthly[153] = double.parse(temp.toStringAsFixed(2));
    }

    // June
    else if (key <= 183) {
      temp = (mapMonthly[183] ?? 0) + value;
      mapMonthly[183] = double.parse(temp.toStringAsFixed(2));
    }

    // July 
    else if (key <= 214) {
      temp = (mapMonthly[214] ?? 0) + value;
      mapMonthly[214] = double.parse(temp.toStringAsFixed(2));
    }

    // August
    else if (key <= 245) {
      temp = (mapMonthly[245] ?? 0) + value;
      mapMonthly[245] = double.parse(temp.toStringAsFixed(2));
    }

    // September
    else if (key <= 275) {
      temp = (mapMonthly[275] ?? 0) + value;
      mapMonthly[275] = double.parse(temp.toStringAsFixed(2));
    }

    // October
    else if (key <= 306) {
      temp = (mapMonthly[306] ?? 0) + value;
      mapMonthly[306] = double.parse(temp.toStringAsFixed(2));
    }

    // November
    else if (key <= 336) {
      temp = (mapMonthly[366] ?? 0) + value;
      mapMonthly[336] = double.parse(temp.toStringAsFixed(2));
    }

    // December
    else {
      temp = (mapMonthly[366] ?? 0) + value;
      mapMonthly[366] = double.parse(temp.toStringAsFixed(2));
    }
  });

  // turn map into list to sort it, then convert it back into a map
  mapMonthly = Map.fromEntries(
      mapMonthly.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

  // for every key and value make an FlSpot
  // because map is ordered, it will be organized starting from day 0

  mapMonthly.forEach((key, value) => temp.add(FlSpot(key, value)));

  return temp;
}

// quick sort function based on y component of FlSpot
void quickSort(List<FlSpot> arr, int left, int right) {
  // makes sure list is not empty
  if (arr.isNotEmpty) {
    if (left < right) {
      int pivotIndex = partition(arr, left, right);
      // calls quicksort recursively on left subarray
      quickSort(arr, left, pivotIndex - 1);
      // calls quicksort recursively on right subarray
      quickSort(arr, pivotIndex + 1, right);
    }
  }
}

// partitions the list based on the y component of FlSpot
int partition(List<FlSpot> arr, int left, int right) {
  // assigns pivot value to the very right
  FlSpot pivotValue = arr[right];

  int i = left - 1;

  // loops subarray from left to right
  for (int j = left; j < right; j++) {
    if (arr[j].y < pivotValue.y) {
      i++;

      swap(arr, i, j);
    }
  }

  swap(arr, i + 1, right);

  // returns index of pivot element
  return i + 1;
}

// swaps two elements in the list
void swap(List<FlSpot> arr, int i, int j) {
  FlSpot temp = arr[i];

  arr[i] = arr[j];

  arr[j] = temp;
}

// shell sort function based on y component of FlSpot
void shellSort(List<FlSpot> arr, int size) {
  // passed by reference - default on Dart
  // loops while gap is greater or equal to 1
  for (int gap = (size / 2).floor(); gap >= 1; gap = (gap / 2).floor()) {

    // iterates from [gap, size)
     for (int i = gap; i < size; i++) {

      // iterates the left side of gap
      int j = i - gap;
      FlSpot temp = arr[i];

      // if swapped elements can be swapped again
      while (j >= 0 && arr[j].y > temp.y) {
        arr[j + gap] = arr[j];
        j -= gap;
      }
      // swaps
      arr[j + gap] = temp;
    }
  }
}

// function used to get max, min and median of lists
double getMaxMinMedian(String data, List<FlSpot> sortedList) {
  double max = 0;
  double min = 0;
  double median = 0;

  // handles edge case with empty list
  if (sortedList.isEmpty) {
    return 0;
  }

  // returns max
  if (data == "max") {
    max = sortedList[sortedList.length - 1].y;

    return max;
  }

  // returns min
  else if (data == "min") {
    min = sortedList[0].y;

    return min;
  }

  // returns median
  else {
    // in case sorted list is even
    if ((sortedList.length % 3) == 0) {
      int index =
          sortedList.length ~/ 2; //Tilde is used to turn division to integer

      median = sortedList[index + 1].y;

      return median;
    }

    // in case sorted list is odd
    else {
      double floorValue = sortedList[(sortedList.length / 2).floor()].y;
      double ceilingValue = sortedList[(sortedList.length / 2).ceil()].y;

      median = ((floorValue + ceilingValue) / 2);

      return median;
    }
  }
}

// widget to label left axis will start at 100k and go up by 100k each interval
Widget leftAxis(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 10,
  );
  int num = value ~/ 1000;
  String text = '$num\K';
  if (num == 1000 || num == 0) {
    text = '';
  }

  return Padding(
    padding: const EdgeInsets.only(right: 4.0),
    child: Text(text, style: style, textAlign: TextAlign.right),
  );
}

// additional widget for labeling the axis on monthly basis
Widget bottomAxis(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 10,
  );
  String text = '';
  int num = value.floor();
  if (num == 30) {
    text = 'Jan';
  } else if (num == 60) {
    text = 'Feb';
  } else if (num == 91) {
    text = 'Mar';
  } else if (num == 121) {
    text = 'Apr';
  } else if (num == 152) {
    text = 'May';
  } else if (num == 182) {
    text = 'Jun';
  } else if (num == 212) {
    text = 'Jul';
  } else if (num == 243) {
    text = 'Aug';
  } else if (num == 273) {
    text = 'Sept';
  } else if (num == 304) {
    text = 'Oct';
  } else if (num == 334) {
    text = 'Nov';
  } else if (num == 364) {
    text = 'Dec';
  } else {
    text = '';
  }

  return Padding(
    padding: const EdgeInsets.only(right: 40, top: 2),
    child: Text(text, style: style, textAlign: TextAlign.center),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // initial data for the graph

  final List<bool> _toggleLists = <bool>[
    false,
    false,
    false
  ]; // initializes it to false because the graph is not visible

  List<Color> myGradient = [Colors.greenAccent, Colors.green];

  List<FlSpot> currentList = [];

  // declares all lists variables to be empty
  List<FlSpot> list1 = [];
  List<FlSpot> list2 = [];
  List<FlSpot> list3 = [];

  List<FlSpot> _chartData = []; 

  // text on the left of the screen displaying stats
  String currentMethod = 'Method:'; 
  String mostExpensive = '0';
  String leastExpensive = '0';
  String medianPurchase = '0';

  // stores sorting time for each function
  int sortTime = 0; 

  @override
  Widget build(BuildContext context) {
    // fills lists up using populate function

    populateList(list1, 100);
    populateList(list2, 250);
    populateList(list3, 500);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Buddy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(

                      // Shell Sort button
                      onPressed: () {
                        setState(() {
                          currentMethod = 'Method: Shell Sort';

                          List<FlSpot> sortedShell = [...currentList];

                          // tracks speed of shell sort algorithm
                          Stopwatch stopwatch = Stopwatch();
                          stopwatch.start();
                          shellSort(sortedShell, sortedShell.length);
                          stopwatch.stop();
                          sortTime = stopwatch.elapsedMilliseconds;

                          // calls getMaxMinMedian function and updates respective variables

                          mostExpensive = getMaxMinMedian("max", sortedShell)
                              .toStringAsFixed(2);

                          leastExpensive = getMaxMinMedian("min", sortedShell)
                              .toStringAsFixed(2);

                          medianPurchase =
                              getMaxMinMedian("median", sortedShell)
                                  .toStringAsFixed(2);

                        });
                      },
                      child: const Text('Shell Sort')),
                ),
                const SizedBox(
                  height: 50,
                  width:
                      200, 
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(

                      // Quick Sort button
                      onPressed: () {
                        setState(() {
                          currentMethod = 'Method: Quick Sort';

                          List<FlSpot> sortedQuick = [...currentList];

                          // tracks speed of quick sort algorithm
                          Stopwatch stopwatch2 = Stopwatch();
                          stopwatch2.start();
                          quickSort(sortedQuick, 0, sortedQuick.length - 1);
                          stopwatch2.stop();
                          sortTime = stopwatch2.elapsedMilliseconds;

                          // calls getMaxMinMedian function and updates respective variables

                          mostExpensive = getMaxMinMedian("max", sortedQuick)
                              .toStringAsFixed(2);

                          leastExpensive = getMaxMinMedian("min", sortedQuick)
                              .toStringAsFixed(2);

                          medianPurchase =
                              getMaxMinMedian("median", sortedQuick)
                                  .toStringAsFixed(2);

                        });
                      },
                      child: const Text('Quick Sort')),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 30.0),
              child: Row(
                children: [
                  SizedBox(

                      // dimensions for text book on left of graph
                      height: 300,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentMethod),
                          Text('Highest Single Purchase: \$$mostExpensive'),
                          Text('Lowest Single Purchase: \$$leastExpensive'),
                          Text('Median Purchase: \$$medianPurchase'),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text('Time Elapsed: $sortTime milliseconds'),
                          )
                        ],
                      )),
                  SizedBox(
                    // dimensions for graph
                    height: 300,
                    width: 460,
                    child: SizedBox(
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: leftAxis)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 30.4,
                                      getTitlesWidget: bottomAxis))),
                          lineTouchData: LineTouchData(enabled: true),
                          minX: 0,
                          maxX: 365,
                          minY: 0,
                          maxY: 1000000,
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: true,
                            horizontalInterval: 200000,
                            // interval for each month
                            verticalInterval: 30.4,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey,
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          lineBarsData: [
                            // aesthetics of the line on the graph
                            LineChartBarData(
                                spots: _chartData, // data of the graph
                                isCurved: true,
                                gradient: LinearGradient(colors: myGradient),
                                barWidth: 5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                // shades under the line on graph
                                // calls below bar and uses bar area
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: myGradient
                                        .map((color) => color.withOpacity(0.3))
                                        .toList(),
                                  ),
                                )),
                          ],
                          borderData: FlBorderData(
                            border: const Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              // no right border
                              right: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              // no top border
                              top: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      // keeps track of button and method
                      for (int i = 0; i < _toggleLists.length; i++) {

                        // index is the selected option (list1 corresponds 0, list2...)
                        if (i == index) {
                          _toggleLists[i] = true;

                          if (i == 0) {
                            currentList = [...list1];

                            _chartData = sumData(currentList);
                          } else if (i == 1) {
                            currentList = [...list2];

                            _chartData = sumData(currentList);
                          } else if (i == 2) {
                            currentList = [...list3];

                            _chartData = sumData(currentList);
                          }
                        } else {
                          _toggleLists[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.blueAccent,
                  selectedColor: Colors.white,
                  fillColor: Colors.blueAccent,
                  color: Colors.blueAccent,
                  constraints: const BoxConstraints(
                    // size of buttons below graph
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _toggleLists,
                  children: const <Widget>[
                    // labels the buttons below graph
                    Text('Sam'),
                    Text('Matheus'),
                    Text('Nico')
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
