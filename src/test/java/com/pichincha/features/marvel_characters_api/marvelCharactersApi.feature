@REQ_MARVEL-001 @HU001 @marvel_characters_management @marvel_characters_api @Agente2 @E2 @iniciativa_marvel_api
Feature: MARVEL-001 Gestión integral de personajes Marvel (microservicio API para gestión CRUD)
  Background:
    * url port_marvel_characters_api
    * def username = karate.get('username', 'javbaezga')
    * configure retry = { count: 3, interval: 5000 }
    * configure connectTimeout = 60000
    * configure readTimeout = 60000
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  # ========== ESCENARIO PRINCIPAL CRUD ==========
  @id:1 @gestionCompleta @flujoIntegral
  Scenario: T-API-MARVEL-001-CA01-Gestión completa de personajes CRUD exitosa - karate
    # === PASO 1: CREAR PERSONAJE ===
    * def uniqueTimestamp = java.lang.System.nanoTime()
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = jsonData.name + '_' + uniqueTimestamp
    * path '/' + username + '/api/characters'
    And request jsonData
    When method POST
    Then status 201
    # Validar estructura de la respuesta de creación
    And match response != null
    And match response.id != null
    And match response.name == jsonData.name
    And match response.alterego == 'Tony Stark'
    And match response.description == 'Genius billionaire'
    And match response.powers == ['Armor', 'Flight']
    # Validar tipos de datos
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.alterego == '#string'
    And match response.description == '#string'
    And match response.powers == '#[]'
    # Capturar datos para usar en pasos siguientes
    * def characterId = response.id
    * def uniqueName = response.name
    
    # === PASO 2: OBTENER TODOS LOS PERSONAJES ===
    * path '/' + username + '/api/characters'
    When method GET
    Then status 200
    # Validar que la respuesta es un array y contiene nuestro personaje
    And match response != null
    And match response == '#[]'
    And match response == '#[_ > 0]'
    # Buscar nuestro personaje creado en la lista
    * def ourCharacter = karate.filter(response, function(x){ return x.id == characterId })
    And match ourCharacter == '#[1]'
    # Validar que contiene el personaje creado
    And match ourCharacter[0].id == characterId
    And match ourCharacter[0].name == uniqueName
    And match ourCharacter[0].alterego == 'Tony Stark'
    And match ourCharacter[0].description == 'Genius billionaire'
    And match ourCharacter[0].powers == ['Armor', 'Flight']
    # Validar tipos de datos del elemento encontrado
    And match ourCharacter[0].id == '#number'
    And match ourCharacter[0].name == '#string'
    And match ourCharacter[0].alterego == '#string'
    And match ourCharacter[0].description == '#string'
    And match ourCharacter[0].powers == '#[]'
    
    # === PASO 3: OBTENER PERSONAJE POR ID ===
    * path '/' + username + '/api/characters/' + characterId
    When method GET
    Then status 200
    # Validar estructura completa de la respuesta
    And match response != null
    And match response.id == characterId
    And match response.name == uniqueName
    And match response.alterego == 'Tony Stark'
    And match response.description == 'Genius billionaire'
    And match response.powers == ['Armor', 'Flight']
    # Validar tipos de datos
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.alterego == '#string'
    And match response.description == '#string'
    And match response.powers == '#[]'
    # Validar que todos los campos requeridos están presentes
    And match response == '#object'
    And match response.powers == '#[2]'
    
    # === PASO 4: ACTUALIZAR PERSONAJE ===
    * def updateData = read('classpath:data/marvel_characters_api/request_update_character.json')
    * set updateData.name = uniqueName
    * path '/' + username + '/api/characters/' + characterId
    And request updateData
    When method PUT
    Then status 200
    # Validar estructura de la respuesta de actualización
    And match response != null
    And match response.id == characterId
    And match response.name == uniqueName
    And match response.alterego == 'Tony Stark'
    And match response.description == 'Updated description'
    And match response.powers == ['Armor', 'Flight']
    # Validar tipos de datos
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.alterego == '#string'
    And match response.description == '#string'
    And match response.powers == '#[]'
    # Validar que todos los campos requeridos están presentes
    And match response == '#object'
    And match response.powers == '#[2]'
    
    # === PASO 5: ELIMINAR PERSONAJE ===
    * path '/' + username + '/api/characters/' + characterId
    When method DELETE
    Then status 204
    # Validar que la respuesta está vacía (sin contenido)
    And match response == ''
    And match responseBytes.length == 0

  # ========== ESCENARIOS DE LECTURA ==========
  @id:2 @obtenerPersonajeNoExiste @personajeNoEncontrado404
  Scenario: T-API-MARVEL-001-CA02-Obtener personaje por ID no existente 404 - karate
    * path '/' + username + '/api/characters/999999'
    When method GET
    Then status 404
    # Validar estructura exacta de la respuesta de error
    And match response != null
    And match response.error == 'Character not found'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Character not found' }

  @id:3 @obtenerPersonajeNull @errorInterno500
  Scenario: T-API-MARVEL-001-CA03-Obtener personaje con ID null genera error interno 500 - karate
    * path '/' + username + '/api/characters/null'
    When method GET
    Then status 500
    # Validar estructura exacta de la respuesta de error interno
    And match response != null
    And match response.error == 'Internal server error'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Internal server error' }

  # ========== ESCENARIOS DE CREACIÓN ==========
  @id:4 @crearPersonajeDuplicado @nombreDuplicado400
  Scenario: T-API-MARVEL-001-CA04-Crear personaje con nombre duplicado 400 - karate
    # === PASO 1: CREAR PERSONAJE ===
    * def uniqueTimestamp = java.lang.System.nanoTime()
    * def jsonData = read('classpath:data/marvel_characters_api/request_duplicate_character.json')
    * set jsonData.name = jsonData.name + '_' + uniqueTimestamp
    * path '/' + username + '/api/characters'
    And request jsonData
    When method POST
    Then status 201
    # Validar estructura de la respuesta de creación
    And match response != null
    And match response.id != null
    And match response.name == jsonData.name
    And match response.alterego == 'Otro'
    And match response.description == 'Otro'
    And match response.powers == ['Armor']
    # Validar tipos de datos
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.alterego == '#string'
    And match response.description == '#string'
    And match response.powers == '#[]'

    # === PASO 2: INTENTAR CREAR PERSONAJE CON NOMBRE DUPLICADO ===
    * def jsonData = read('classpath:data/marvel_characters_api/request_duplicate_character.json')
    * set jsonData.name = jsonData.name + '_' + uniqueTimestamp
    * path '/' + username + '/api/characters'
    And request jsonData
    When method POST
    Then status 400
    # Validar estructura exacta de la respuesta de error
    And match response != null
    And match response.error == 'Character name already exists'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Character name already exists' }

  @id:5 @crearPersonajeInvalido @datosInvalidos400
  Scenario: T-API-MARVEL-001-CA05-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_invalid_character.json')
    * path '/' + username + '/api/characters'
    And request jsonData
    When method POST
    Then status 400
    # Validar estructura exacta de la respuesta de error con múltiples campos
    And match response != null
    And match response.name == 'Name is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'
    And match response.alterego == 'Alterego is required'
    # Validar tipos de datos de los errores
    And match response.name == '#string'
    And match response.description == '#string'
    And match response.powers == '#string'
    And match response.alterego == '#string'
    # Validar que la respuesta es un objeto con los 4 campos de error
    And match response == '#object'
    And match response == { name: 'Name is required', description: 'Description is required', powers: 'Powers are required', alterego: 'Alterego is required' }

  @id:6 @crearPersonajeJsonMalformado @errorServidor500
  Scenario: T-API-MARVEL-001-CA06-Crear personaje con JSON mal formado 500 - karate
    * def jsonMalformado = read('classpath:data/marvel_characters_api/request_malformed_character.json')
    * path '/' + username + '/api/characters'
    And request jsonMalformado
    When method POST
    Then status 500
    # Validar estructura exacta de la respuesta de error interno
    And match response != null
    And match response.error == 'Internal server error'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Internal server error' }

  # ========== ESCENARIOS DE ACTUALIZACIÓN ==========
  @id:7 @actualizarPersonajeNoExiste @personajeNoEncontrado404
  Scenario: T-API-MARVEL-001-CA07-Actualizar personaje no existente 404 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    * path '/' + username + '/api/characters/999999'
    And request jsonData
    When method PUT
    Then status 404
    # Validar estructura exacta de la respuesta de error
    And match response != null
    And match response.error == 'Character not found'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Character not found' }

  @id:8 @actualizarPersonajeInvalido @datosInvalidos400
  Scenario: T-API-MARVEL-001-CA08-Actualizar personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_invalid_update_character.json')
    * path '/' + username + '/api/characters/1'
    And request jsonData
    When method PUT
    Then status 400
    # Validar estructura exacta de la respuesta de error con múltiples campos
    And match response != null
    And match response.name == 'Name is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'
    And match response.alterego == 'Alterego is required'
    # Validar tipos de datos de los errores
    And match response.name == '#string'
    And match response.description == '#string'
    And match response.powers == '#string'
    And match response.alterego == '#string'
    # Validar que la respuesta es un objeto con los 4 campos de error
    And match response == '#object'
    And match response == { name: 'Name is required', description: 'Description is required', powers: 'Powers are required', alterego: 'Alterego is required' }

  @id:9 @actualizarPersonajeIdNull @errorInterno500
  Scenario: T-API-MARVEL-001-CA09-Actualizar personaje con ID null genera error interno 500 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    * path '/' + username + '/api/characters/null'
    And request jsonData
    When method PUT
    Then status 500
    # Validar estructura exacta de la respuesta de error interno
    And match response != null
    And match response.error == 'Internal server error'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Internal server error' }

  # ========== ESCENARIOS DE ELIMINACIÓN ==========
  @id:10 @eliminarPersonajeNoExiste @personajeNoEncontrado404
  Scenario: T-API-MARVEL-001-CA10-Eliminar personaje no existente 404 - karate
    * path '/' + username + '/api/characters/999999'
    When method DELETE
    Then status 404
    # Validar estructura exacta de la respuesta de error
    And match response != null
    And match response.error == 'Character not found'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Character not found' }

  @id:11 @eliminarPersonajeIdNull @errorInterno500
  Scenario: T-API-MARVEL-001-CA11-Eliminar personaje con ID null genera error interno 500 - karate
    * path '/' + username + '/api/characters/null'
    When method DELETE
    Then status 500
    # Validar estructura exacta de la respuesta de error interno
    And match response != null
    And match response.error == 'Internal server error'
    # Validar tipos de datos
    And match response.error == '#string'
    # Validar que la respuesta es un objeto con solo el campo error
    And match response == '#object'
    And match response == { error: 'Internal server error' }
