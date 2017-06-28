# Programa de calculo de notas en base a un archivo csv para Desafio Latam
# 2017 - Hugo Morales

require 'io/console'

def main(file)
  menu(file)
end

# Menus
def menu(file)
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
  when 1 then puts "Opcion 1 seleccionada #{file}"
  when 2 then puts "Opcion 2 seleccionada #{file}"
  when 3 then puts "Opcion 3 seleccionada #{file}"
  when 4 then dialogo_salida
  else puts 'Opcion seleccionada no valida'
  end
end

# Fin seccion motor de opciones

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

main('notas.csv')
