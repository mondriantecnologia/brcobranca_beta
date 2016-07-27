# -*- encoding: utf-8 -*-
module Brcobranca
  module Boleto
    class Bradesco < Base # Banco BRADESCO

      validates_length_of :agencia, :maximum => 4, :message => "deve ser menor ou igual a 4 dígitos."
      validates_length_of :numero_documento, :maximum => 11, :message => "deve ser menor ou igual a 11 dígitos."
      validates_length_of :conta_corrente, :maximum => 7, :message => "deve ser menor ou igual a 7 dígitos."
      validates_length_of :carteira, :maximum => 2, :message => "deve ser menor ou igual a 2 dígitos."

      # Nova instancia do Bradesco
      # @param (see Brcobranca::Boleto::Base#initialize)
      def initialize(campos={})
        campos = {:carteira => "06", :aceite => "N", :data_processamento => Date.today,
        :local_pagamento => "Pagável em qualquer Banco até o vencimento."}.merge!(campos)
        super(campos)
      end

      # Codigo do banco emissor (3 dígitos sempre)
      #
      # @return [String] 3 caracteres numéricos.
      def banco
        "237"
      end

      # Carteira
      #
      # @return [String] 2 caracteres numéricos.
      def carteira=(valor)
        @carteira = valor.to_s.rjust(2,'0') if valor
      end

      # Número seqüencial utilizado para identificar o boleto.
       # @return [String] 11 caracteres numéricos.
      def numero_documento=(valor)
        @numero_documento = valor.to_s.rjust(11,'0') if valor
      end

      # Dígito verificador do Nosso Número
      # Verificar retorno para digito -> 10
      # @return [String]
      def nosso_numero_dv
        resto  = self.modulo11_nnum_bradesco(7, 1)
        digito = 11 - resto
        return case digito
           when 10 then "P"
           when 11 then 0
           else digito
        end
      end

      # Nosso número para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.nosso_numero_boleto #=> ""06/00000004042-8"
      def nosso_numero_boleto
        "#{self.carteira}/#{self.numero_documento}-#{self.nosso_numero_dv}"
      end

      # Agência + conta corrente do cliente para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.agencia_conta_boleto #=> "0548-7 / 00001448-6"
      def agencia_conta_boleto
        "#{self.agencia}-#{self.agencia_dv} / #{self.conta_corrente}-#{self.conta_corrente_dv}"
      end

      # Segunda parte do código de barras.
      #
      # Posição | Tamanho | Conteúdo<br/>
      # 20 a 23 | 4 |  Agência Cedente (Sem o digito verificador, completar com zeros a esquerda quando  necessário)<br/>
      # 24 a 25 | 2 |  Carteira<br/>
      # 26 a 36 | 11 |  Número do Nosso Número(Sem o digito verificador)<br/>
      # 37 a 43 | 7 |  Conta do Cedente (Sem o digito verificador, completar com zeros a esquerda quando necessário)<br/>
      # 44 a 44 | 1 |  Zero<br/>
      #
      # @return [String] 25 caracteres numéricos.
      def codigo_barras_segunda_parte
        "#{self.agencia}#{self.carteira}#{self.numero_documento}#{self.conta_corrente}0"
      end
      
    
      # modulo11_bradesco
      def modulo11_nnum_bradesco(base=9,r=0)
        num = "#{self.carteira}#{self.numero_documento}"
        soma, fator = 0, 2
        numeros, parcial = [], []
        for i in (1..num.size).to_a.reverse
            numeros[i] = num[i-1,1].to_i
            parcial[i] = numeros[i] * fator
            soma += parcial[i].to_i
            if (fator == base)
      	  fator = 1
            end
            fator += 1
        end
        if (r == 0)
            soma *= 10
            digito = soma % 11
            if (digito == 10)
      	  digito = 0
            end
            return digito
        elsif (r == 1)
            resto = soma % 11
            return resto
        end
      end
    end
  end
end
