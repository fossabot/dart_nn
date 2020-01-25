import 'dart:math';
import './matrix.dart';
import './activation.dart';
import './neuralNetwork.dart';

Random rnd = new Random();

double map(double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

class Perceptron {
  final weights = new List<double>(2);

  Perceptron() {
    for(int i = 0; i < weights.length; i++) {
      weights[i] = map(rnd.nextDouble(), 0, 1, -1, 1);
    }
    print(weights);
  }

  double weightedSum(List<double> inputs) {
    double sum = 0;
    for(int i = 0; i < inputs.length; i++) {
      sum += inputs[i]*weights[i];
    }
    return sum;
  }
}

void main() {
  //var p = Perceptron();
  //print(p.weightedSum([0.8, 0.2]));
  NeuralNetwork brain = NeuralNetwork(2,3,1);
  Matrix inp = Matrix(3, 2);
  var train_data = [{
    "inputs": [1.0, 1.0],
    "outputs": [0.0],
  }, {
    "inputs": [0.0, 0.0],
    "outputs": [0.0],
  }, {
    "inputs": [0.0, 1.0],
    "outputs": [1.0],
  }, {
    "inputs": [1.0, 0.0],
    "outputs": [1.0],
  }];
  int epoch = 500000;

  Random rnd = Random();
  for(int i = 0; i < epoch; i++) {
    int d = rnd.nextInt(4);
    brain.train(train_data[d]["inputs"], train_data[d]["outputs"]);
  }
  for(int i = 0; i < train_data.length; i++) {
    print("Test: In: ${train_data[i]['inputs']} ${brain.predict(train_data[i]['inputs'])}");
  }
  //print(brain.feedForward([1.0,2.0,3.0]));
  // Matrix m1 = Matrix(3,4);
  // Matrix m2 = Matrix(4,3);
  // m1 = m1.randomize();
  // m2 = m2.randomize();
  // print(m1);
  // print(m1.multiply(2));
  // print(m1);
  // print(m1.transpose());
  // print(m1);
  // print(m1);
  // print(m2);
  // print(m1.multiply(m2));
  // print(m1);
  // print(m2);

  // print(m1.map((x) => x*10));

  // int x = 5;
  // print(x);
  // x = 10;
  // print(x);

  // print(Activation.ArcTan(0.23, derivative: true));
}
