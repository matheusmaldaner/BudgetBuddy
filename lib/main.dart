import 'package:flutter/material.dart'; 
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';


//~ are changes made - matheus
//? are questions I had - matheus
//! are comments I added - matheus

void main() {
  //!passes widget MyApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      double maxY = (random.nextDouble() * 10 + 1); //? unsure how this may affect graph
      list.add(FlSpot(maxX, maxY));
    }
  }
}



//Collapse the data (sum up transactions made on the same day and make a list)
List<FlSpot> sumData(List<FlSpot> list) {
  List<FlSpot> temp = [];
  //Add first point
  temp.add(const FlSpot(0, 0)); //~ added const keyword
  Map<double, double> map = {};
  Map<double, double> mapMonthly = {};

  //Fill the map
  for (var a in list) {
    //First x of is kind push Flspot and push into set
    if (map.containsKey(a.x) == false) {
      map[a.x] = a.y;
    }
    //If that x already exists... add the y's
    else {
      //If value is null use zero instead
      double newY = (map[a.x] ?? 0) + a.y;
      map[a.x] = newY;
    }
  }

  //Convert map to month basis
  map.forEach((key, value) {
    //Jan
    if (key <= 31) {
      mapMonthly[30.41] = (mapMonthly[30.41] ?? 0) + value;
    }
    //Feb
    else if (key <= 61) {
      mapMonthly[60.83] = (mapMonthly[60.83] ?? 0) + value;
    }
    //Mar
    else if (key <= 92) {
      mapMonthly[91.25] = (mapMonthly[91.25] ?? 0) + value;
    }
    //Apr
    else if (key <= 122) {
      mapMonthly[122] = (mapMonthly[122] ?? 0) + value;
    }
    //May
    else if (key <= 153) {
      mapMonthly[153] = (mapMonthly[153] ?? 0) + value;
    }
    //Jun
    else if (key <= 183) {
      mapMonthly[183] = (mapMonthly[183] ?? 0) + value;
    }
    //July
    else if (key <= 214) {
      mapMonthly[214] = (mapMonthly[214] ?? 0) + value;
    }
    //Aug
    else if (key <= 245) {
      mapMonthly[245] = (mapMonthly[245] ?? 0) + value;
    }
    //Sep
    else if (key <= 275) {
      mapMonthly[275] = (mapMonthly[275] ?? 0) + value;
    }
    //Oct
    else if (key <= 306) {
      mapMonthly[306] = (mapMonthly[306] ?? 0) + value;
    }
    //Nov
    else if (key <= 336) {
      mapMonthly[336] = (mapMonthly[336] ?? 0) + value;
    }
    //Dec
    else {
      mapMonthly[366] = (mapMonthly[366] ?? 0) + value;
    }
  });

  //turn map into list to sort back into map
  mapMonthly = Map.fromEntries(
      mapMonthly.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  //For every key and value make an FlSpot
  //Bc ordered it will be organized from day 0++
  mapMonthly.forEach((key, value) => temp.add(FlSpot(key, value)));

  return temp;
}

// -------------------------------------------------------------------------------------------------------------------------------------- \\


//~quick sort function based on y component of FlSpot
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

// -------------------------------------------------------------------------------------------------------------------------------------- \\

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

// -------------------------------------------------------------------------------------------------------------------------------------- \\


double getMaxMinMedian(String data, List<FlSpot> sortedList) {
  double max = 0;
  double min = 0;
  double median = 0;

  //~handles edge case with empty list
  if (sortedList.isEmpty) {
    return 0;
  }
  
  //Max
  if (data == "max") {
    max = sortedList[sortedList.length - 1].y;
    return max;
  }
  //Min
  else if (data == "min") {
    min = sortedList[0].y;
    return min;
  }
     
  //Median
  else {
    //If even
    if ((sortedList.length % 3) == 0) {
      int index = sortedList.length ~/ 2; //Tilde is used to turn division to integer
      median = sortedList[index + 1].y;
      return median;
    }
    //Odd case
    else {
      double floorValue = sortedList[(sortedList.length / 2).floor()].y;
      double ceilingValue = sortedList[(sortedList.length / 2).ceil()].y;
      median = ((floorValue + ceilingValue) / 2);
      return median;
    }
  }
}


// -------------------------------------------------------------------------------------------------------------------------------------- \\



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initial data for the graph
  final List<bool> _toggleLists = <bool>[false, false, false]; //~ initialized it to false because the graph is not present
  List<Color> myGradient = [Colors.greenAccent, Colors.green];


  //List<FlSpot> currentList = sumData(getList(1)); //? why was it defined like this
  List<FlSpot> currentList = [];

  //Use from inorder to get a copy of the list, dhanges wont reflect
  //!declares all lists variables to be empty
  List<FlSpot> list1 = [];
  List<FlSpot> list2 = [];
  List<FlSpot> list3 = [];
 
  // ~still playing with this, but if set to empty list, graph does not show up
  List<FlSpot> _chartData = []; // List<FlSpot>.from(sumData(List<FlSpot>.from(getList(1)))); // ~changed to pass declaration instead of list1
  
  
  // List<FlSpot> _chartData = List<FlSpot>.from(sumData(list1));

  String currentMethod = 'Method:'; // ~changed so method name shows when option is selected
  String mostExpensive = '';
  String leastExpensive = '';
  String medianPurchase = '';

  int sortTime = 0; //~changed variable name from shellSort1Time

  @override
  Widget build(BuildContext context) {

    // fills lists up using populate function
    populateList(list1, 100);
    populateList(list2, 250);
    populateList(list3, 500);

    // scaffold is the basic framework of the app
    return Scaffold(
    
      // represents the top of a scaffold
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
                      // SHELL SORT BUTTON
                      onPressed: () {
                        setState(() {
                          currentMethod = 'Method: Shell Sort';

                          List<FlSpot> sortedShell = [...currentList];
                          //!tracks speed of shell sort algorithm
                          Stopwatch stopwatch = Stopwatch();
                          stopwatch.start();
                          shellSort(sortedShell, sortedShell.length);
                          stopwatch.stop();
                      
                          sortTime = stopwatch.elapsedMilliseconds;

                          //!calls getMaxMinMedian function and updates respective variables
                          mostExpensive = getMaxMinMedian("max", sortedShell).toStringAsPrecision(4);
                          leastExpensive = getMaxMinMedian("min", sortedShell).toStringAsPrecision(4);
                          medianPurchase = getMaxMinMedian("median", sortedShell).toStringAsPrecision(4);

                          //_chartData = sumData(sortedShell);
                        });
                      },
                      child: const Text('Shell Sort')),
                ),
                
                const SizedBox(
                  height: 50,
                  width: 200, //~changed from 300 to current to lessen gap between options
                ),
              
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                      // QUICK SORT BUTTON
                      onPressed: () {
                        setState(() {
                          currentMethod = 'Method: Quick Sort';

                          List<FlSpot> sortedQuick = [...currentList];                         
                          //!tracks speed of quick sort algorithm
                          Stopwatch stopwatch2 = Stopwatch();
                          stopwatch2.start();
                          quickSort(sortedQuick, 0, sortedQuick.length - 1);
                          stopwatch2.stop();

                          sortTime = stopwatch2.elapsedMilliseconds;

                          //!calls getMaxMinMedian function and updates respective variables
                          mostExpensive = getMaxMinMedian("max", sortedQuick).toStringAsPrecision(4);
                          leastExpensive = getMaxMinMedian("min", sortedQuick).toStringAsPrecision(4);
                          medianPurchase =getMaxMinMedian("median", sortedQuick).toStringAsPrecision(4);
                          
                          //_chartData = sumData(sortedQuick);
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
                      // dimensions for text box on left of graph
                      height: 300,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentMethod),
                          Text('High: $mostExpensive'),
                          Text('Low: $leastExpensive'),
                          Text('Median: $medianPurchase'),
                          Text('Time Elapsed: $sortTime milliseconds')
                        ],
                      )),
                  SizedBox(
                    // dimensions for graph
                    height: 300,
                    width: 460,
                    child: SizedBox(
                      child: LineChart(
                        LineChartData(
                          // shows monthly value when hover over graph
                          lineTouchData: LineTouchData(enabled: true),

                          // x,y axis
                          minX: 1,
                          maxX: 365,
                          minY: 0,
                          maxY: 100000,
                          
                          gridData: FlGridData(
                            show: true,
                            //~ NO IDEA ABOUT THIS PART
                            drawHorizontalLine: false,
                            drawVerticalLine: true,
                            horizontalInterval: 10000,
                            //Every month
                            verticalInterval: 30.416,
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
                          titlesData: FlTitlesData(show: false),
                          lineBarsData: [
                            //Aesthetics of the actual line on the graph
                            LineChartBarData(
                                spots: _chartData, //Data of the graph
                                isCurved: true,
                                gradient: LinearGradient(colors: myGradient),
                                barWidth: 5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                //Shade in under the line on graph
                                //call below bar and use bar area
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
                              //No right border
                              right: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              //No top border
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
                      //Keep track of button and method
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

                          } else if (i == 2) { // ~changed from else to else if (i == 2)
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
                    Text('List 1'), 
                    Text('List 2'),
                    Text('List 3')
                  ]),
            ),
          ],
        ),
      ),
      
      // sets background of scaffold
      backgroundColor: Color.fromARGB(255, 215, 213, 213),
    );
  }
}
