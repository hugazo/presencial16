# Programa de calculo de notas en base a un archivo csv para Desafio Latam
# 2017 - Hugo Morales

require 'io/console'

def main(file)
  menu(file)
end

# Menus
def menu(file)
  clear
  puts dialogo_bienvenida
  opcion = 0
  while opcion != 4
    opcion = menu_principal
    motor_seleccion(opcion, file)
  end
end

def menu_principal
  opcion = 0
  while opcion < 1 || opcion > 4
    puts dialogo_menu
    opcion = gets.chomp.to_i
    clear
  end
  opcion
end
# Fin seccion menus

# Inicio seccion motor de opciones
def motor_seleccion(opcion, file)
  case opcion
  when 1 then opcion_uno(file)
  when 2 then puts "Opcion 2 seleccionada #{file}"
  when 3 then puts "Opcion 3 seleccionada #{file}"
  when 4 then dialogo_salida
  else puts 'Opcion seleccionada no valida'
  end
end

def opcion_uno(file)
  clear
  data_array = procesar_data(file)
  data_ordenada = hash_data(data_array)
  promedios = calcular_promedios(data_ordenada)
  imprimir_resultados(promedios)
  guardar_resultados(promedios)
  finalizar_ejecucion_opcion
end

def opcion_dos(file)

end
# Fin seccion motor de opciones

# Inicio seccion motor de calculo para opciones

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

def obtener_promedio(notas)
  # Se le entrega un array con notas y entrega el promedio.
  suma_notas = notas.inject(0) { |sum, x| sum + x }
  suma_notas / notas.length.to_f
end

def imprimir_resultados(hash)
  hash.each_pair { |key, value| puts "#{key}: #{value}" }
end

def guardar_resultados(data)
  opcion = nil
  while opcion != 's' && opcion != 'n'
    puts 'Desea guardar el resultado? (s/n)'
    opcion = gets.downcase.chomp
  end
  ejecutar_opcion_guardado(opcion, data)
end

def ejecutar_opcion_guardado(opcion, data)
  dialogo_guardado_archivo(data) if opcion == 's'
  puts 'No se guardará archivo' if opcion == 'n'
  puts 'Opcion no valida' if opcion != 'n' && opcion != 's'
end

def dialogo_guardado_archivo(hash)
  puts "Ingrese el nombre de archivo\nSe utilizará la extensión .csv"
  filename = gets.chomp
  filename += '.csv'
  data = ''
  hash.each_pair { |key, value| data << "#{key}, #{value}\n" }
  File.open(filename, 'w') { |file| file.puts data }
  resultado_guardado(filename)
end

def resultado_guardado(filename)
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
  '*******************************
** Programa de Gestion Notas **
*******************************'
end

def dialogo_menu
  'Ingrese una opcion:
1) Generar archivo con promedios de cada alumno.
2) Mostrar total de inasistencias.
3) Mostrar alumnos aprobados.
4) Salir de este programa.'
end

def dialogo_salida
  clear
  puts 'Gracias por utilizar este programa'
  presione_para_continuar
  clear
end

# Seccion dialogos - Fin

# Metodos auxiliares
def presione_para_continuar
  puts '[Presione cualquier tecla para continuar]'
  STDIN.getch
end

def clear
  system 'clear'
end

def finalizar_ejecucion_opcion
  presione_para_continuar
  clear
end

# Ejecucion de programa
main('notas.csv')
