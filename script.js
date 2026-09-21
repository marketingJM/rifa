const contenedorNumeros = document.getElementById("numeros");

const modal = document.getElementById("modal");

const cerrarModal = document.getElementById("cerrarModal");

const numeroSeleccionado = document.getElementById("numeroSeleccionado");

const formulario = document.getElementById("formulario");

let numeroActual = null;


/* =========================
   CREAR NÚMEROS 00 - 99
========================= */

for (let i = 0; i <= 99; i++) {

    const numero = i.toString().padStart(2, "0");

    const boton = document.createElement("button");

    boton.type = "button";

    boton.className = "numero";

    boton.textContent = numero;

    boton.addEventListener("click", function () {

        numeroActual = numero;

        numeroSeleccionado.textContent = numero;

        modal.classList.add("activo");

    });

    contenedorNumeros.appendChild(boton);
}


/* =========================
   CERRAR MODAL
========================= */

cerrarModal.addEventListener("click", function () {

    modal.classList.remove("activo");

});


/* =========================
   CERRAR TOCANDO AFUERA
========================= */

modal.addEventListener("click", function (evento) {

    if (evento.target === modal) {

        modal.classList.remove("activo");

    }

});


/* =========================
   CONFIRMAR
========================= */

formulario.addEventListener("submit", function (evento) {

    evento.preventDefault();

    const nombre =
        document.getElementById("nombre").value.trim();

    const estadoPago =
        document.getElementById("estadoPago").value;


    if (!nombre || !estadoPago || !numeroActual) {

        alert("Por favor completa todos los datos.");

        return;

    }


    const mensaje =
        `Hola, quiero participar en la RIFA.%0A%0A` +
        `🎟️ Número: ${numeroActual}%0A` +
        `👤 Nombre: ${nombre}%0A` +
        `💰 Estado: ${estadoPago}%0A%0A` +
        `Quedo atento(a) a la confirmación.`;


    const telefono = "573226082281";

    const url =
        `https://wa.me/${telefono}?text=${mensaje}`;


    window.location.href = url;

});
