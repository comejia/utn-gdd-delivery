# TP Delivery

Trabajo Practico integrador de la materia Gestión de Datos

El presente trabajo práctico persigue los siguientes objetivos generales
* Promover la investigación de técnicas de base de datos.
* Aplicar la teoría vista en la asignatura en una aplicación concreta.
* Desarrollar y probar distintos algoritmos sobre datos reales.
* Fomentar la delegación y el trabajo en grupo.

### Descripción
Mediante este trabajo práctico se intenta simular la implementación de un nuevo sistema. El mismo consiste en una aplicación de Delivery Online que permite a los usuarios elegir entre una variedad platos de comida y/o productos y realizar su pedido a distintos locales (restaurantes/mercados), conectando de esta manera a quien quiere el producto con quién lo vende y con quien lo entrega. El sistema permite a cada local gestionar sus productos y órdenes de pedidos. Además, cuenta con un módulo de mensajería donde el usuario puede solicitar envíos de una ubicación a otra.
La implementación de dicho sistema, requiere previamente realizar la migración de los datos que se tenían registrados hasta el momento. Para ello es necesario que se reformule el diseño de la base de datos actual y los procesos, de manera tal que cumplan con los nuevos requerimientos.
Además, se solicita la implementación de un segundo modelo, con sus correspondientes procedimientos y vistas, que pueda ser utilizado para la obtención de indicadores de gestión, análisis de escenarios y proyección para la toma de decisiones.

## Etapas
Mediante los requerimientos enunciados en el [TP](Enunciado.pdf), se debe desarrollar el trabajo en 3 etapas:

1) [DER](diagramas/DER%20-%20Transaccional.jpg): Desarrollo del diagrama entidad - relacion que representa el modelo planteado y cumpla con los requerimientos

2) Modelo transaccional: A partir del DER creado se debe realizar la migración de la tabla maestra, que esta completamente desnormalizado, a las entidades definidas en el DER mediante un [script](script_creacion_inicial.sql) que contenga todo el codigo SQL necesario para la migración

3) Modelos de Inteligencia de Negocios (BI): Esta etapa consiste en implementar un modelo de negocio que permita consultar facilmente la información/vistas pedidas en el enunciado. Para ello es necesario crear un [DER de BI](diagramas/DER%20-%20BI.jpg) que tenga las dimensiones y tabla de hechos junto a un [script](script_creacion_BI.sql) que migre los datos del modelo transaccional a dicho modelo

## Herramientas utilizadas
* Sistema operativos: Windows
* SQL Server Managment
* Motor de SQL Server
* SQL
* TSQL

