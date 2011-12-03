class SplunkOutput < Fluent::Output
  Fluent::Plugin.register_output('splunk', self)

  config_param :host, :string
  config_param :port, :string

  def configure(conf)
    super
  end

  def start
    super
    puts @host
    puts @port
    @splunk_connection = TCPSocket.open(@host, @port)
  end

  def shutdown
    super
    @splunk_connection.close 
  end

  def emit(tag, es, chain)
    chain.next
    es.each {|time,record|
      @splunk_connection.puts  "#{time}: #{record}\n" 
    }
  end
end
