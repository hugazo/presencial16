def main(file)
  menu(file)
end

def menu(file)
  puts dialogo_bienvenida
  opcion = 0
  while opcion != 4
    opcion = menu_principal
    motor_seleccion(opcion, file)
  end
  puts dialogo_salida
end

def menu_principal
  opcion = 0
  while opcion < 1 || opcion > 4
    puts dialogo_menu
    opcion = gets.chomp.to_i
  end
  opcion
end

def motor_seleccion(opcion, file)
  case opcion
  when 1 then puts "Opcion 1 seleccionada #{file}"
  when 2 then puts "Opcion 2 seleccionada #{file}"
  when 3 then puts "Opcion 3 seleccionada #{file}"
  when 4 then puts 'Opcion 4 seleccionada'
  else puts 'Opcion seleccionada no valida'
  end
end

# Seccion dialogos - Inicio
def dialogo_bienvenida
  '*******************************
** Programa de Gestion Notas **
*******************************'
end

def dialogo_menu
  # TO-DO hacer el dialogo del menu
end

def dialogo_salida
  # TO-DO Crear dialogo salida
end

# Seccion dialogos - Fin

main('notas.csv')
