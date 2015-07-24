<?php
$message = "Nombre: ". $_POST['name'] . "\r\n";
$message .= "Teléfono: ". $_POST['number'] . "\r\n";
$message = "Email: ". $_POST['mail'] . "\r\n";
$message = "Comentarios: ". $_POST['comments'] . "\r\n";
$message = "País de Interés: ". $_POST['country'] . "\r\n";
mail($_POST['mail'], $_POST['Formulario de Contacto Ortiferet.net'], $message);