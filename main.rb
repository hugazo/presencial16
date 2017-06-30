# Programa de calculo de notas en base a un archivo csv para Desafio Latam
# 2017 - Hugo Morales

require 'io/console'

def main(file)
  menu(file)
end

# Menus
def menu(file)
  # Vertebra del programa, muestra los dialogos de inicio y ejecuta los Metodos
  # que ejecutara el programa en su ciclo de vida.
  clear
  puts dialogo_bienvenida
  opcion = 0
  while opcion != 4
    opcion = menu_seleccion_principal
    motor_seleccion(opcion, file)
  end
end

def menu_seleccion_principal
  # Muestra en pantalla las opciones de menu habilitadas y devuelve la
  # opcion seleccionada como entero para luego ser ejecutada
  opcion = 0
  while opcion < 1 || opcion > 4
    puts dialogo_menu
    opcion = gets.chomp
    opcion_no_valida(opcion) unless opcion.to_i >= 1 && opcion.to_i <= 4
    opcion = opcion.to_i
    clear
  end
  opcion
end
# Fin seccion menus

# Inicio seccion motor de opciones
def motor_seleccion(opcion, file)
  # Ejecuta la opcion seleccionada llamando a los metodos necesarios.
  case opcion
  when 1 then opcion_uno(file)
  when 2 then opcion_dos(file)
  when 3 then opcion_tres(file)
  when 4 then dialogo_salida
  end
end

def opcion_uno(file)
  # Ejecuta la opcion uno, crear un informe de promedio de notas, muestra los
  # resultados en pantalla y consulta si debe guardar los datos mostrados.
  clear
  data_ordenada = crear_array_notas(file)
  promedios = calcular_promedios(data_ordenada)
  imprimir_resultados(promedios)
  guardar_resultados(promedios)
  finalizar_ejecucion_opcion
end

def opcion_dos(file)
  # Ejecuta la opcion dos, crear un informe de inasistencias, muestra los
  # resultados en pantalla y consulta si se debe guardar los datos mostrados.
  clear
  data_ordenada = crear_array_notas(file)
  inasistencias = contar_inasistencias(data_ordenada)
  imprimir_resultados(inasistencias)
  guardar_resultados(inasistencias)
  finalizar_ejecucion_opcion
end

def opcion_tres(file)
  # Ejecuta la opcion tres, solicita una nota de aprobacion y luego muestra
  # los alumnos que cumplen con esa nota y consulta si debe guardar.
  clear
  data_ordenada = crear_array_notas(file)
  promedios = calcular_promedios(data_ordenada)
  aprobados = obtener_aprobados(promedios)
  imprimir_resultados(aprobados)
  guardar_resultados(aprobados)
  finalizar_ejecucion_opcion
end
# Fin seccion motor de opciones

# Inicio seccion motor de calculo para opciones

def crear_array_notas(file)
  # Metodo que toma un archivo, luego llama a el metodo que genera el array y
  # despues ese array lo procesa como Hash estandar de notas.
  hash_data(procesar_data(file))
end

def procesar_data(file)
  # Se le entrega un archivo y devuelve un array con sus datos separados.
  file = File.open(file, 'r')
  data = []
  raw_data = file.readlines
  raw_data.each { |x| data.push(x.split(', ').map(&:chomp)) }
  data
end

def hash_data(data_array)
  # Se le entrega un array y devuelve un Hash con los nombres y las notas.
  data = {}
  largo = data_array.length + 1
  data_array.each { |x| data[x[0].to_sym] = x[1..largo + 1].map(&:to_i) }
  data
end

def calcular_promedios(data)
  # Se le entrega un hash con nombre y notas y devuelve un hash con promedios
  # por nombre.
  promedios = {}
  data.each_pair { |key, value| promedios[key] = obtener_promedio(value) }
  promedios
end

def contar_inasistencias(data)
  # Cuenta las inasistencias por alumno y luego llama al metodo que Cuenta
  # el total de las inasistencias.
  inasistencias = {}
  data.each_pair { |key, value| inasistencias[key] = value.count(0) }
  inasistencias[:Total] = total_inasistencias(inasistencias)
  inasistencias
end

def obtener_aprobados(data)
  # Llama a metodo auxiliar para obtener la nota de aprobacion, luego evalua
  # quienes cumplen con dicha nota y llena el hash con los aprobados
  nota_aprobacion = obtener_nota_aprobacion
  aprobados = {}
  data.each_pair { |key, val| aprobados[key] = val if val >= nota_aprobacion }
  aprobados
end

def obtener_nota_aprobacion
  # Muestra en pantalla la seleccion de la nota de aprobacion, evaluando
  # correcto ingreso y luego devolviendo ese valor como decimal.
  nota = 0
  while nota < 1 || nota > 10
    puts 'Ingrese nota de aprobación (5 por defecto)'
    nota = gets.chomp
    nota = nota.tr(',', '.')
    nota = '5' if nota == ''
    opcion_no_valida(nota) unless nota.to_f >= 1 && nota.to_f <= 10
    nota = nota.to_f
  end
  nota
end

def opcion_no_valida(opcion)
  # Metodo a ejecutar en caso de ingresar una opcion no valida. Muestra en
  # pantalla un mensaje de error y la opcion ingresada.
  clear
  puts "Opción ingresada #{opcion} no es válida, intente nuevamente"
  finalizar_ejecucion_opcion
end

def total_inasistencias(inasistencias)
  # Cuenta el total de las inasistencias de un hash entregado.
  total = 0
  inasistencias.each_value { |value| total += value }
  total
end

def obtener_promedio(notas)
  # Se le entrega un array con notas y entrega el promedio.
  suma_notas = notas.inject(0) { |sum, x| sum + x }
  suma_notas / notas.length.to_f
end

def imprimir_resultados(hash)
  # Crea una impresion para pantalla de un hash entregado
  hash.each_pair { |key, value| puts "#{key}: #{value}" }
end

def guardar_resultados(data)
  # Se le pasa un hash y comienza una subrutina para guardar los resultados
  # incluidos en ese hash
  opcion = nil
  while opcion != 's' && opcion != 'n'
    puts 'Desea guardar el resultado? (s/n)'
    opcion = gets.downcase.chomp
    opcion_no_valida(opcion) if opcion != 'n' && opcion != 's'
  end
  ejecutar_opcion_guardado(opcion, data)
end

def ejecutar_opcion_guardado(opcion, data)
  # Se llama desde guardar_resultados para poder procesar la opcion seleccionada
  dialogo_guardado_archivo(data) if opcion == 's'
  return unless opcion == 'n'
  clear
  puts 'No se guardará archivo'
end

def dialogo_guardado_archivo(hash)
  # Se le pasa data en hash y guarda esa data en un archivo con extension csv
  # luego comprueba si ese archivo fue correctamente guardado.
  puts "Ingrese el nombre de archivo\nSe utilizará la extensión .csv"
  filename = gets.chomp
  filename += '.csv'
  data = ''
  hash.each_pair { |key, value| data << "#{key}, #{value}\n" }
  File.open(filename, 'w') { |file| file.puts data }
  resultado_guardado(filename)
end

def resultado_guardado(filename)
  # Determina si un archivo se encuentra creado e imprime en pantalla su ruta.
  if File.exist?(filename)
    file = File.expand_path(filename)
    puts "Archivo #{file} guardado correctamente"
  else
    puts 'No se pudo guardar el archivo'
  end
end

# Fin Seccion motor de calculo

# Seccion dialogos - Inicio
def dialogo_bienvenida
  # Retorna string de bienvenida al programa.
  '*******************************
** Programa de Gestion Notas **
*******************************'
end

def dialogo_menu
  # Retorna string de menu principal.
  'Ingrese una opcion:
1) Generar archivo con promedios de cada alumno.
2) Mostrar total de inasistencias.
3) Mostrar alumnos aprobados.
4) Salir de este programa.'
end

def dialogo_salida
  # Muestra mensaje de despedida
  clear
  puts 'Gracias por utilizar este programa'
  presione_para_continuar
  clear
end

# Seccion dialogos - Fin

# Metodos auxiliares
def presione_para_continuar
  # Pausa la ejecucion, mostrando mensaje de presionar tecla y al presionar una,
  #  se continua la ejecucion del programa
  puts '[Presione cualquier tecla para continuar]'
  STDIN.getch
end

def clear
  # Limpia la pantalla, metodo no funciona en Windows
  system 'clear'
end

def finalizar_ejecucion_opcion
  # Muestra mensaje de presionar para continuar y limpia pantalla una vez
  # presionada una tecla.
  presione_para_continuar
  clear
end

# Ejecucion de programa
main('notas.csv')
