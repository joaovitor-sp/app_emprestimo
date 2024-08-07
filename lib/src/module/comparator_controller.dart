import 'dart:convert';
import 'dart:developer';

import 'package:app_emprestimo/src/model/simulacao_model.dart';
import 'package:dio/dio.dart';

class ComparatorController {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  Future<List<Map<String, String>>?> getInstituicao() async {
    String url = 'instituicao';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          final List<dynamic> jsonList = jsonDecode(response.data);

          List<Map<String, String>> data = List<Map<String, String>>.from(
            jsonList.map((item) => Map<String, String>.from(item)),
          );

          log('instituicoes recebidos com sucesso: $data');
          return data;
        } else {
          log('Formato de dados inesperado: ${response.data}');
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log('Erro ao realizar request instituicoes: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>?> getConvenio() async {
    try {
      final response = await _dio.get(
        'convenio',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          final List<dynamic> jsonList = jsonDecode(response.data);

          List<Map<String, String>> data = List<Map<String, String>>.from(
            jsonList.map((item) => Map<String, String>.from(item)),
          );

          log('convenios recebidos com sucesso: $data');
          return data;
        } else {
          log('Formato de dados inesperado: ${response.data}');
          return null;
        }
      } else {
        log('Falha ao realizar request convenios: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Erro ao realizar request convenios: $e');
      return null;
    }
  }

  Future<List<SimulacaoModel?>> sendSimulation(double valor,
      List<String?> convenio, int parcelas, List<String?> instituicoes) async {
    final data = {
      'valor_emprestimo': valor,
      'convenios': convenio,
      'parcela': parcelas,
      'instituicoes': instituicoes,
    };

    try {
      final response = await _dio.post(
        'simular',
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        log('Simulação enviada com sucesso: ${response.data}');
        try{
        response.data as List<dynamic>; 
          return [];
        } catch (e) {
          final jsonData = response.data as Map<String, dynamic>; 
          List<SimulacaoModel> allSimulacoes = [];
          jsonData.forEach((key, value) {
            if (value is List) {
              log(value.toString());
              allSimulacoes.addAll(
                (value)
                    .map((item) =>
                        SimulacaoModel.fromJson(item as Map<String, dynamic>))
                    .toList(),
              );
            }
          });
          return allSimulacoes;
        }
      } else {
        log('Falha ao enviar a simulação: ${response.statusCode}');
        log('Resposta do servidor: ${response.data}');
      }
    } catch (e) {
      log('Erro ao enviar a simulação: $e');
    }
    return [];
  }
}
