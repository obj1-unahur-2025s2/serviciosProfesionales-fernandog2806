// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
// serviciosProfesionales.wlk
class Profesional {
  var property universidadQueEstudiaron
  
  method honorariosDelProfesional()
  
  method provinciasParaTrabajar()
}

class Universidad {
  var property provinciaEnLaQueSeUbica
  var property honorariosDelTrabajador
}

class ProfesionalVinculado inherits Profesional {
  override method provinciasParaTrabajar() = universidadQueEstudiaron.provinciaEnLaQueSeUbica().asSet()
  
  override method honorariosDelProfesional() = universidadQueEstudiaron.honorariosDelTrabajador()
}

class ProfesionalDelLitoral inherits Profesional {
  override method provinciasParaTrabajar() = provinciasDelLitoral.provincias()
  
  override method honorariosDelProfesional() = 3000
}

class ProfesionalLibre inherits Profesional {
  var property provinciasEnLaQuePuedeTrabajar = #{}
  var property honorariosPorHora
  
  override method provinciasParaTrabajar() = provinciasEnLaQuePuedeTrabajar
  
  override method honorariosDelProfesional() = honorariosPorHora
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

class EmpresaDeServicio {
  const profesionalesContratados = #{}
  var property honorarios
  
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