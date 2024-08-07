import 'dart:async';

import 'package:app_emprestimo/src/model/simulacao_model.dart';
import 'package:app_emprestimo/src/module/comparator_controller.dart';
import 'package:app_emprestimo/src/module/widgets/comparato_form_field_widget.dart';
import 'package:app_emprestimo/src/module/widgets/comparator_dropbutton_form_widget.dart';
import 'package:app_emprestimo/src/module/widgets/dropdown_search_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class ComparatorPage extends StatefulWidget {
  const ComparatorPage({super.key});

  @override
  State<ComparatorPage> createState() => _ComparatorPageState();
}

class _ComparatorPageState extends State<ComparatorPage> {
  final formKey = GlobalKey<FormState>();
  final valorEC = TextEditingController();
  final parcelasEC = TextEditingController();
  final ComparatorController controller = ComparatorController();
  List<String?> conveniosItems = ['default'];
  List<String?> instituicoesItems = [];
  List<String?> selectedInstituicoes = [];
  List<String?> selectedConvenios = [];
  Future<List<SimulacaoModel?>>? simulacoes;

  @override
  void dispose() {
    super.dispose();
    valorEC.dispose();
    parcelasEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    setState(() {});
  }

  Future<void> _loadData() async {
    final conveniosData = await controller.getConvenio();
    final instituicoesData = await controller.getInstituicao();
    setState(() {
      conveniosItems = getValues(conveniosData);
      instituicoesItems = getValues(instituicoesData);
    });
  }

  void _loadSimulacoes() {
    final valorEmpestimo =
        UtilBrasilFields.converterMoedaParaDouble(valorEC.text);
    setState(() {
      simulacoes = controller.sendSimulation(
          valorEmpestimo,
          selectedConvenios,
          parcelasEC.text.isEmpty ? 0 : int.parse(parcelasEC.text),
          selectedInstituicoes);
    });
    // log(simulacoes.toString());
  }

  List<String> getValues(List<Map<String, String>>? data) {
    if (data == null || data.isEmpty) {
      return [];
    }

    List<String> values = [];

    for (var map in data) {
      if (map.isNotEmpty) {
        values.add(map.values.first);
      }
    }

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Simulador App'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ComparatorFormFieldWidget(
                  onChanged: (value) {},
                  controller: valorEC,
                  label: 'Valor do empréstimo',
                ),
                const SizedBox(
                  height: 8,
                ),
                ComparatorDropButtonFormWidget(
                  onChanged: (value) {
                    parcelasEC.text = value.toString();
                  },
                  items: const [36, 48, 60, 72, 84],
                  label: 'Quantidade de parcelas',
                ),
                const SizedBox(
                  height: 8,
                ),
                DropDownSearchWidget(
                  onChanged: (value) {
                    setState(() {
                      selectedInstituicoes = value;
                    });
                  },
                  items: instituicoesItems,
                  label: 'Instituições',
                ),
                const SizedBox(
                  height: 8,
                ),
                DropDownSearchWidget(
                  items: conveniosItems,
                  label: 'convênio',
                  onChanged: (value) {
                    setState(() {
                      selectedConvenios = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.orange)),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            _loadSimulacoes();
                          }
                        },
                        child: const Text(
                          'SIMULAR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<SimulacaoModel?>>(
                    future: simulacoes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        if (snapshot.data!.isEmpty){
                          return const Center(child: Text('Nenhum item com esse filtro\n encrotrado!'),);
                        }
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final simulacao = data[index]!;
                            return ListTile(
                              title: Text(
                                  '${valorEC.text} - ${simulacao.parcelas} x R\$ ${simulacao.valorParcela}'),
                              subtitle: Text(
                                  '${simulacao.instituicao}(${simulacao.convenio}) - ${simulacao.taxa}%'),
                              leading: Text(simulacao.instituicao),
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
