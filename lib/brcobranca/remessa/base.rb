# encoding: utf-8

module Brcobranca
  module Remessa
    class Base # Classe base para retornos bancários
      attr_accessor :nome_arquivo
      attr_accessor :caminho_arquivo
      attr_accessor :objeto
      attr_accessor :boletos
    end
  end
end
