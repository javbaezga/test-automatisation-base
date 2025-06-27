function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com',
    username: 'javbaezga'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.username = 'javbaezga';
    config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.username = 'javbaezga';
    config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  }
  
  // Debug: mostrar la configuración cargada
  karate.log('Environment:', env);
  karate.log('Config loaded:', config);
  
  return config;
}
