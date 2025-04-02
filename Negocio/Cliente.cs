using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class Cliente
    {
        public string DNI { get; set; }
        public string Apellidos { get; set; }
        public string Nombre { get; set; }
        public string Direccion { get; set; }
        public string CP { get; set; }
        public string Poblacion { get; set; }
        public string Telefono { get; set; }
        public string Telefono2 { get; set; }
        public List<Coche> Coches { get; set; } = new List<Coche>();
    }
}
