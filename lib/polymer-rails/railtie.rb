module Polymer
  module Rails
    class Railtie < ::Rails::Railtie
      initializer :polymer_html_import do |app|
        ::ActionView::Base.module_eval("include AssetTagHelper")
      end

      initializer :precompile_polymer do |app|
        if app.config.respond_to?(:assets)
          app.config.assets.precompile += %w( polymer/polymer.js )
        end
      end

      config.after_initialize do |app|
        app.config.assets.context_class.class_eval("include Polymer::Rails::AssetTagHelper")

        app.assets.register_preprocessor 'text/html', Polymer::Rails::Processors::Directive
        app.assets.register_mime_type 'text/html', extensions: ['.html']
        app.assets.register_bundle_processor 'text/html', ::Sprockets::Bundle
        app.assets.register_postprocessor 'text/html', Polymer::Rails::Processors::Component
      end
    end
  end
end
