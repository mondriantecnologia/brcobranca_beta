require 'parseline'
module Brcobranca
  module Retorno
    class RetornoBradesco < Base
      
      def self.read_header(file)
        line_header = LineHeader.load_lines(file).first
      end
      # /[^(02|9)]/

      def self.read_lines(file)
        default_options = { except: /^(92|02)/ }
        lines = Line.load_lines(file, default_options)
      end            

      class LineHeader < Base
        extend ParseLine::FixedWidth

        fixed_width_layout do |parse|
          parse.field :dia_base, 94..95
          parse.field :mes_base, 96..97
          parse.field :ano_base, 98..99
        end
      end

      class Line < Base
        extend ParseLine::FixedWidth

        fixed_width_layout do |parse|
          parse.field :numero_documento, 70..80
          parse.field :numero_documento_crdd, 70..81
          parse.field :dia_pagamento, 110..111
          parse.field :mes_pagamento, 112..113
          parse.field :ano_pagamento, 114..116
          parse.field :id_ocorrencia, 108..109
          parse.field :motivo_ocorrencia, 318..327
          parse.field :valor, 253..265
        end
      end
    end
  end
end
