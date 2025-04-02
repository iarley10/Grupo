using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class Reparacion
    {
        public int NumReparacion { get; set; }
        public string Matricula { get; set; }
        public string Descripcion { get; set; }
        public DateTime FechaEntrada { get; set; }
        public DateTime FechaSalida { get; set; }
        public int Horas { get; set; }
        public Coche Coche { get; set; }
        public List<DetalleReparacion> Detalles { get; set; } = new List<DetalleReparacion>();
    }
}
