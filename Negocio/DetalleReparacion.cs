using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class DetalleReparacion
    {
        public int NumReparacion { get; set; }
        public string Referencia { get; set; }
        public int Unidades { get; set; }
        public Reparacion Reparacion { get; set; }
        public Pieza Pieza { get; set; }
    }
}
