function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080',
    username: 'javbaezga'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_marvel_characters_api = 'http://localhost:8080';
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://localhost:8080';
    config.username = 'javbaezga';
    config.port_marvel_characters_api = 'http://localhost:8080';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'http://localhost:8080';
    config.username = 'javbaezga';
    config.port_marvel_characters_api = 'http://localhost:8080';
  }
  
  // Debug: mostrar la configuración cargada
  karate.log('Environment:', env);
  karate.log('Config loaded:', config);
  
  return config;
}
