import 'dart:math';
import 'dart:convert';
import 'package:dart_nn/src/utils.dart' as utils;

// Matrix Class
class Matrix {
  int rows;
  int cols;
  List<List<double>> matrix;
  Random rnd = Random();

  Matrix(int rows, int cols, {int rngSeed}) {
    this.rows = rows;
    this.cols = cols;
    if (rngSeed != null) {
      rnd = Random(rngSeed);
    }
    matrix = List.generate(rows, (_) => List(cols));
    ones();
  }

  static Matrix fromArray(List<double> arr) {
    var result = Matrix(arr.length, 1);
    for (var i = 0; i < arr.length; i++) {
      result.matrix[i][0] = arr[i];
    }
    return result;
  }

  static List<double> toArray(Matrix mat) {
    var result = [];
    for (var i = 0; i < mat.rows; i++) {
      for (var j = 0; j < mat.cols; j++) {
        var elem = mat.matrix[i][j];
        result.add(elem);
      }
    }
    return result.cast<double>();
  }

  static Matrix dotProduct(Matrix a, Matrix b) {
    // Dot product
    if (a.cols != b.rows) {
      throw ('The columns of A = ${a.cols} must match rows of B = ${b.rows}');
    }
    var result = Matrix(a.rows, b.cols);
    for (var i = 0; i < result.rows; i++) {
      for (var j = 0; j < result.cols; j++) {
        var sum = 0.0;
        for (var k = 0; k < a.cols; k++) {
          sum += a.matrix[i][k] * b.matrix[k][j];
        }
        result.matrix[i][j] = sum;
      }
    }
    return result;
  }

  static Matrix clone(Matrix x) {
    var result = Matrix(x.rows, x.cols);
    for (var i = 0; i < x.rows; i++) {
      for (var j = 0; j < x.cols; j++) {
        result.matrix[i][j] = x.matrix[i][j];
      }
    }
    return result;
  }

  static Matrix transpose(Matrix x) {
    var result = Matrix(x.cols, x.rows);
    for (var i = 0; i < x.rows; i++) {
      for (var j = 0; j < x.cols; j++) {
        result.matrix[j][i] = x.matrix[i][j];
      }
    }
    return result;
  }

  static Matrix immutableMap(Matrix m, Function fn) {
    var result = Matrix(m.rows, m.cols);
    for (var i = 0; i < m.rows; i++) {
      for (var j = 0; j < m.cols; j++) {
        result.matrix[i][j] = fn(m.matrix[i][j]);
      }
    }
    return result;
  }

  Matrix map(Function fn) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        var val = matrix[i][j];
        matrix[i][j] = fn(val);
      }
    }
    return this;
  }

  Matrix multiply(var val, {bool hadamard = false}) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (val is Matrix && hadamard) {
          // Hadamard product
          matrix[i][j] *= val.matrix[i][j];
        } else {
          // Scalar product
          matrix[i][j] *= val;
        }
      }
    }
    return this;
  }

  Matrix add(var val) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (val is Matrix) {
          matrix[i][j] += val.matrix[i][j];
        } else {
          matrix[i][j] += val;
        }
      }
    }
    return this;
  }

  Matrix subtract(var val) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (val is Matrix) {
          matrix[i][j] -= val.matrix[i][j];
        } else {
          matrix[i][j] -= val;
        }
      }
    }
    return this;
  }

  Matrix ones() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        matrix[i][j] = 1.0;
      }
    }
    return this;
  }

  Matrix zeros() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        matrix[i][j] = 0.0;
      }
    }
    return this;
  }

  Matrix randomize() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        matrix[i][j] = utils.map(rnd.nextDouble(), 0, 1, -1, 1);
      }
    }
    return this;
  }

  @override
  String toString() {
    var m = '';
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        m += matrix[i][j].toStringAsFixed(3) + ((j + 1 == cols) ? '' : ', ');
      }
      m += '\n';
    }
    return m;
  }

  // serialize
  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'cols': cols,
      'matrix': List<dynamic>.from(
          matrix.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
  }

  // deserialize
  Matrix.fromJson(Map<String, dynamic> json) {
    rows = json['rows'];
    cols = json['cols'];
    matrix = List<List<double>>.from(json['matrix']
        .map((x) => List<double>.from(x.map((x) => x.toDouble()))));
  }

  static String serialize(Matrix mat) {
    return jsonEncode(mat);
  }

  static Matrix deserialize(String jsonString) {
    Map mat = jsonDecode(jsonString);
    var result = Matrix.fromJson(mat);
    return result;
  }
}
