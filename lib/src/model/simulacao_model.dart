class SimulacaoModel {
  final double taxa;
  final int parcelas;
  final double valorParcela;
  final String convenio;
  final String instituicao;

  SimulacaoModel({
    required this.taxa,
    required this.parcelas,
    required this.valorParcela,
    required this.convenio,
    required this.instituicao,
  });

  factory SimulacaoModel.fromJson(Map<String, dynamic> json) {
    return SimulacaoModel(
      taxa: json['taxa'].toDouble(),
      parcelas: json['parcelas'],
      valorParcela: json['valor_parcela'].toDouble(),
      convenio: json['convenio'],
      instituicao: json['instituicao'],
    );
  }

}
