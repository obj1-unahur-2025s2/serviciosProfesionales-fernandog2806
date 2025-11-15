// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
class Profesional {
  var property universidadQueEstudiaron
  var property dineroRecibido = 0
  
  method honorariosDelProfesional()
  
  method provinciasParaTrabajar()
  
  method donarSueldo()
  
  method recibirDinero(unMonto) {
    dineroRecibido += unMonto
  }
}

class Universidad {
  var property provinciaEnLaQueSeUbica
  var property honorariosDelTrabajador
  var property dineroDonado = 0
  
  method recibirDonacion(monto) {
    dineroDonado += monto
  }
}

class ProfesionalVinculado inherits Profesional {
  override method provinciasParaTrabajar() = universidadQueEstudiaron.provinciaEnLaQueSeUbica().asSet()
  
  override method honorariosDelProfesional() = universidadQueEstudiaron.honorariosDelTrabajador()
  
  override method donarSueldo() {
    universidadQueEstudiaron.recibirDonacion(
      self.honorariosDelProfesional() / 2
    )
  }
}

class ProfesionalDelLitoral inherits Profesional {
  override method provinciasParaTrabajar() = provinciasDelLitoral.provincias()
  
  override method honorariosDelProfesional() = 3000
  
  override method donarSueldo() {
    asociacionProfesionalesDelLitoral.recibirDonacion(
      self.honorariosDelProfesional()
    )
  }
}

class ProfesionalLibre inherits Profesional {
  var property provinciasEnLaQuePuedeTrabajar = #{}
  var property honorariosPorHora
  
  override method provinciasParaTrabajar() = provinciasEnLaQuePuedeTrabajar
  
  override method honorariosDelProfesional() = honorariosPorHora
  
  override method donarSueldo() {
    self.recibirDinero(self.honorariosDelProfesional())
  }
  
  method pasarDinero(unProfesional, unMonto) {
    dineroRecibido -= unMonto
    unProfesional.recibirDinero(unMonto)
  }
}

object provinciasDelLitoral {
  const property provincias = [entreRios, santaFe, corrientes]
}

object entreRios {
  
}

object santaFe {
  
}

object corrientes {
  
}

object asociacionProfesionalesDelLitoral {
  var property dineroDonado = 0
  
  method recibirDonacion(monto) {
    dineroDonado += monto
  }
}

class EmpresaDeServicio {
  const profesionalesContratados = #{}
  var property honorarios
  const clientes = #{}
  
  method cuantosEstudiaronEn(unaUniversidad) = profesionalesContratados.count(
    { profesional => profesional.universidadQueEstudiaron() == unaUniversidad }
  )
  
  method profesionalesCaros() = profesionalesContratados.filter(
    { h => h.honorariosDelProfesional() > honorarios }
  ).asSet()
  
  method universidadesFormadoras() = profesionalesContratados.map(
    { u => u.universidadQueEstudiaron() }
  ).asSet()
  
  method profesionalesBaratos() = profesionalesContratados.min(
    { h => h.honorariosDelProfesional() }
  )
  
  method esDeGenteAcotada() = profesionalesContratados.all(
    { p => p.provinciasParaTrabajar().size() <= 3 }
  )
  
  method puedeSatisfacerASolicitante(
    unSolicitante
  ) = unSolicitante.puedeSerAtendidoPorUnProfesional(profesionalesContratados)
  
  method darServicio(unSolicitante) {
    if (self.puedeSatisfacerASolicitante(unSolicitante)) {
      const profesionalElegido = profesionalesContratados.find(
        { p => unSolicitante.puedeSerAtendidoPorUnProfesional({ p }) }
      )
      profesionalElegido.donarSueldo()
      
      clientes.add(unSolicitante)
    }
  }
  
  method cantidadDeClientes() = clientes.size()
  
  method clientesTieneASolicitante(unSolicitante) = clientes.contains(
    unSolicitante
  )
  
  method esProfesionalPocoAtractivo(unProfesional) {
    unProfesional.provinciasParaTrabajar().all(
      { prov => self.hayOtroMasBaratoEn(prov, unProfesional) }
    )
  }
  
  method hayOtroMasBaratoEn(unaProvincia, unProfesional) {
    profesionalesContratados.any(
      { otro => self.esMasBaratoEnProvincia(otro, unaProvincia, unProfesional) }
    )
  }
  
  method esMasBaratoEnProvincia(otro, unaProvincia, unProfesional) {
    ((otro != unProfesional) && otro.provinciasParaTrabajar().contains(
      unaProvincia
    )) && (otro.honorariosDelProfesional() < unProfesional.honorariosDelProfesional())
  }
}

class Solicitante {
  method puedeSerAtendidoPorUnProfesional(profesionales)
}

class Persona inherits Solicitante {
  var property provinciaEnLaQueVive
  
  override method puedeSerAtendidoPorUnProfesional(
    profesionales
  ) = profesionales.any(
    { p => p.provinciasParaTrabajar().contains(provinciaEnLaQueVive) }
  )
}

class Institucion inherits Solicitante {
  const property universidades = #{}
  
  override method puedeSerAtendidoPorUnProfesional(
    profesionales
  ) = profesionales.any(
    { p => universidades.contains(p.universidadQueEstudiaron()) }
  )
}

class Club inherits Solicitante {
  const property provinciaEnLaQueSeEncuentra = #{}
  
  override method puedeSerAtendidoPorUnProfesional(
    profesionales
  ) = profesionales.any(
    { p => provinciaEnLaQueSeEncuentra.any(
        { prov => p.provinciasParaTrabajar().contains(prov) }
      ) }
  )
}