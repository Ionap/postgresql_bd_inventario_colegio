--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.2

-- Started on 2025-03-14 21:06:58

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 1622036)
-- Name: Iona Duarte; Type: SCHEMA; Schema: -; Owner: Comfe_owner
--

CREATE SCHEMA "Iona Duarte";


ALTER SCHEMA "Iona Duarte" OWNER TO "Comfe_owner";

--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA "Iona Duarte"; Type: COMMENT; Schema: -; Owner: Comfe_owner
--

COMMENT ON SCHEMA "Iona Duarte" IS 'BBDD Gestión Inventario Colegio Privado.
';


--
-- TOC entry 359 (class 1255 OID 1916933)
-- Name: registrar_compra(integer, jsonb); Type: PROCEDURE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE PROCEDURE "Iona Duarte".registrar_compra(IN p_id_proveedor integer, IN p_productos jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INT;
    item JSONB;
BEGIN
 raise notice 'aqui-1';
    -- Insertar una nueva compra
    INSERT INTO "Iona Duarte".compras (fecha, id_proveedor)
    VALUES (NOW(), p_id_proveedor)
    RETURNING id_compra INTO v_id_compra;
    raise notice 'aqui';
    -- Insertar los productos en la compra
    FOR item IN SELECT * FROM jsonb_array_elements(p_productos) LOOP
        INSERT INTO "Iona Duarte".detalles_compras (id_compra, id_producto, cantidad, precio_unitario)
        VALUES (v_id_compra, 
                (item->>'id_producto')::INT, 
                (item->>'cantidad')::INT, 
                (item->>'precio_unitario')::NUMERIC);
    END LOOP;
	 raise notice 'aqui-3';
END;
$$;


ALTER PROCEDURE "Iona Duarte".registrar_compra(IN p_id_proveedor integer, IN p_productos jsonb) OWNER TO "Comfe_owner";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 1638440)
-- Name: areas_colegio; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".areas_colegio (
    id_area integer NOT NULL,
    nombre character varying(100) NOT NULL,
    responsable character varying(100) NOT NULL,
    id_responsable integer
);


ALTER TABLE "Iona Duarte".areas_colegio OWNER TO "Comfe_owner";

--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE areas_colegio; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".areas_colegio IS 'Contiene los departamentos del colegio que reciben los productos (ej.: Biblioteca, Laboratorio).

Relación de tablas: Se vincula con Salidas_Inventario mediante id_area (las áreas reciben materiales del inventario).';


--
-- TOC entry 247 (class 1259 OID 1638439)
-- Name: areas_colegio_id_area_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".areas_colegio_id_area_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".areas_colegio_id_area_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 247
-- Name: areas_colegio_id_area_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".areas_colegio_id_area_seq OWNED BY "Iona Duarte".areas_colegio.id_area;


--
-- TOC entry 242 (class 1259 OID 1638401)
-- Name: categorias; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".categorias (
    id_categoria integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE "Iona Duarte".categorias OWNER TO "Comfe_owner";

--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE categorias; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".categorias IS 'Clasifica los productos en categorías como útiles escolares, libros, equipos tecnológicos y mobiliario.
Se relaciona con la Tabla Productos mediante id_categoria (una categoría puede tener varios productos).';


--
-- TOC entry 241 (class 1259 OID 1638400)
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".categorias_id_categoria_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 241
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".categorias_id_categoria_seq OWNED BY "Iona Duarte".categorias.id_categoria;


--
-- TOC entry 250 (class 1259 OID 1638447)
-- Name: compras; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".compras (
    id_compra integer NOT NULL,
    fecha date NOT NULL,
    id_proveedor integer,
    total numeric(10,2)
);


ALTER TABLE "Iona Duarte".compras OWNER TO "Comfe_owner";

--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE compras; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".compras IS 'Registra las compras de productos realizadas por el colegio.

Relación de tablas: Relacionada con Proveedores (id_proveedor).
Vinculada con Detalles_Compras (id_compra), que indica qué productos se compraron.';


--
-- TOC entry 249 (class 1259 OID 1638446)
-- Name: compras_id_compra_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".compras_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".compras_id_compra_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 249
-- Name: compras_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".compras_id_compra_seq OWNED BY "Iona Duarte".compras.id_compra;


--
-- TOC entry 252 (class 1259 OID 1638459)
-- Name: detalles_compras; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".detalles_compras (
    id_detalle integer NOT NULL,
    id_compra integer,
    id_producto integer,
    cantidad integer,
    precio_unitario numeric(10,2)
);


ALTER TABLE "Iona Duarte".detalles_compras OWNER TO "Comfe_owner";

--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE detalles_compras; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".detalles_compras IS 'Contiene los productos adquiridos en cada compra, con cantidades y precios unitarios.

Relación de tablas:  Se conecta con Compras (id_compra).
Se relaciona con Productos (id_producto).';


--
-- TOC entry 251 (class 1259 OID 1638458)
-- Name: detalles_compras_id_detalle_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".detalles_compras_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".detalles_compras_id_detalle_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 251
-- Name: detalles_compras_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".detalles_compras_id_detalle_seq OWNED BY "Iona Duarte".detalles_compras.id_detalle;


--
-- TOC entry 256 (class 1259 OID 1638488)
-- Name: detalles_salidas; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".detalles_salidas (
    id_detalle integer NOT NULL,
    id_salida integer,
    id_producto integer,
    cantidad integer
);


ALTER TABLE "Iona Duarte".detalles_salidas OWNER TO "Comfe_owner";

--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE detalles_salidas; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".detalles_salidas IS 'Indica los productos que fueron entregados a cada área del colegio y en qué cantidad.

Relación de tablas:  Se conecta con Salidas_Inventario (id_salida).
Se vincula con Productos (id_producto).';


--
-- TOC entry 255 (class 1259 OID 1638487)
-- Name: detalles_salidas_id_detalle_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".detalles_salidas_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".detalles_salidas_id_detalle_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 255
-- Name: detalles_salidas_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".detalles_salidas_id_detalle_seq OWNED BY "Iona Duarte".detalles_salidas.id_detalle;


--
-- TOC entry 244 (class 1259 OID 1638419)
-- Name: productos; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".productos (
    id_producto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text NOT NULL,
    precio numeric(10,2),
    stock integer,
    id_categoria integer
);


ALTER TABLE "Iona Duarte".productos OWNER TO "Comfe_owner";

--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE productos; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".productos IS 'Contiene los artículos del inventario (ej.: lápices, computadoras, sillas).

Relación de tablas: Pertenece a una Categoría (id_categoria).
Se usa en Compras y Salidas de Inventario.';


--
-- TOC entry 243 (class 1259 OID 1638418)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".productos_id_producto_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 243
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".productos_id_producto_seq OWNED BY "Iona Duarte".productos.id_producto;


--
-- TOC entry 246 (class 1259 OID 1638433)
-- Name: proveedores; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".proveedores (
    id_proveedor integer NOT NULL,
    nombre character varying(100),
    contacto character varying(100),
    telefono character varying(20),
    email character varying(100),
    direccion character varying(100)
);


ALTER TABLE "Iona Duarte".proveedores OWNER TO "Comfe_owner";

--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE proveedores; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".proveedores IS 'Almacena información de los proveedores que suministran los productos al colegio.

Relación de tablas: Se vincula con Compras mediante id_proveedor (cada compra es realizada a un proveedor).';


--
-- TOC entry 245 (class 1259 OID 1638432)
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".proveedores_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".proveedores_id_proveedor_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 245
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".proveedores_id_proveedor_seq OWNED BY "Iona Duarte".proveedores.id_proveedor;


--
-- TOC entry 309 (class 1259 OID 1794130)
-- Name: responsable; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".responsable (
    id_responsable integer NOT NULL,
    nombre character varying(100) NOT NULL,
    cargo character varying(100),
    contacto character varying(100)
);


ALTER TABLE "Iona Duarte".responsable OWNER TO "Comfe_owner";

--
-- TOC entry 308 (class 1259 OID 1794129)
-- Name: responsable_id_responsable_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".responsable_id_responsable_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".responsable_id_responsable_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 308
-- Name: responsable_id_responsable_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".responsable_id_responsable_seq OWNED BY "Iona Duarte".responsable.id_responsable;


--
-- TOC entry 254 (class 1259 OID 1638476)
-- Name: salidas_inventario; Type: TABLE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE TABLE "Iona Duarte".salidas_inventario (
    id_salida integer NOT NULL,
    fecha date,
    id_area integer,
    id_responsable integer
);


ALTER TABLE "Iona Duarte".salidas_inventario OWNER TO "Comfe_owner";

--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE salidas_inventario; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON TABLE "Iona Duarte".salidas_inventario IS 'Registra los productos que salen del inventario y se asignan a las áreas del colegio.

Relación de tablas: Se asocia con Áreas_Colegio (id_area).
Se conecta con Detalles_Salidas (id_salida), que almacena los productos entregados.';


--
-- TOC entry 253 (class 1259 OID 1638475)
-- Name: salidas_inventario_id_salida_seq; Type: SEQUENCE; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE SEQUENCE "Iona Duarte".salidas_inventario_id_salida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Iona Duarte".salidas_inventario_id_salida_seq OWNER TO "Comfe_owner";

--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 253
-- Name: salidas_inventario_id_salida_seq; Type: SEQUENCE OWNED BY; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER SEQUENCE "Iona Duarte".salidas_inventario_id_salida_seq OWNED BY "Iona Duarte".salidas_inventario.id_salida;


--
-- TOC entry 311 (class 1259 OID 1794172)
-- Name: vista_inventario; Type: VIEW; Schema: Iona Duarte; Owner: Comfe_owner
--

CREATE VIEW "Iona Duarte".vista_inventario AS
 SELECT si.fecha AS fecha_salida,
    ac.nombre AS area_destino,
    r.nombre AS responsable,
    ds.cantidad,
    p.nombre AS producto,
    p.descripcion,
    dc.precio_unitario,
    ((ds.cantidad)::numeric * dc.precio_unitario) AS total_valor
   FROM (((((("Iona Duarte".salidas_inventario si
     JOIN "Iona Duarte".areas_colegio ac ON ((si.id_area = ac.id_area)))
     JOIN "Iona Duarte".responsable r ON ((si.id_responsable = r.id_responsable)))
     JOIN "Iona Duarte".detalles_salidas ds ON ((si.id_salida = ds.id_salida)))
     JOIN "Iona Duarte".productos p ON ((ds.id_producto = p.id_producto)))
     JOIN "Iona Duarte".detalles_compras dc ON ((p.id_producto = dc.id_producto)))
     JOIN "Iona Duarte".compras c ON ((dc.id_compra = c.id_compra)))
  ORDER BY si.fecha DESC;


ALTER VIEW "Iona Duarte".vista_inventario OWNER TO "Comfe_owner";

--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 311
-- Name: VIEW vista_inventario; Type: COMMENT; Schema: Iona Duarte; Owner: Comfe_owner
--

COMMENT ON VIEW "Iona Duarte".vista_inventario IS 'La vista Vista_Inventario facilita la consulta del historial de salidas de inventario en el colegio, mostrando información clave sobre los productos entregados.';


--
-- TOC entry 3442 (class 2604 OID 1638443)
-- Name: areas_colegio id_area; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".areas_colegio ALTER COLUMN id_area SET DEFAULT nextval('"Iona Duarte".areas_colegio_id_area_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 1638404)
-- Name: categorias id_categoria; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".categorias ALTER COLUMN id_categoria SET DEFAULT nextval('"Iona Duarte".categorias_id_categoria_seq'::regclass);


--
-- TOC entry 3443 (class 2604 OID 1638450)
-- Name: compras id_compra; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".compras ALTER COLUMN id_compra SET DEFAULT nextval('"Iona Duarte".compras_id_compra_seq'::regclass);


--
-- TOC entry 3444 (class 2604 OID 1638462)
-- Name: detalles_compras id_detalle; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_compras ALTER COLUMN id_detalle SET DEFAULT nextval('"Iona Duarte".detalles_compras_id_detalle_seq'::regclass);


--
-- TOC entry 3446 (class 2604 OID 1638491)
-- Name: detalles_salidas id_detalle; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_salidas ALTER COLUMN id_detalle SET DEFAULT nextval('"Iona Duarte".detalles_salidas_id_detalle_seq'::regclass);


--
-- TOC entry 3440 (class 2604 OID 1638422)
-- Name: productos id_producto; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".productos ALTER COLUMN id_producto SET DEFAULT nextval('"Iona Duarte".productos_id_producto_seq'::regclass);


--
-- TOC entry 3441 (class 2604 OID 1638436)
-- Name: proveedores id_proveedor; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('"Iona Duarte".proveedores_id_proveedor_seq'::regclass);


--
-- TOC entry 3447 (class 2604 OID 1794133)
-- Name: responsable id_responsable; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".responsable ALTER COLUMN id_responsable SET DEFAULT nextval('"Iona Duarte".responsable_id_responsable_seq'::regclass);


--
-- TOC entry 3445 (class 2604 OID 1638479)
-- Name: salidas_inventario id_salida; Type: DEFAULT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".salidas_inventario ALTER COLUMN id_salida SET DEFAULT nextval('"Iona Duarte".salidas_inventario_id_salida_seq'::regclass);


--
-- TOC entry 3637 (class 0 OID 1638440)
-- Dependencies: 248
-- Data for Name: areas_colegio; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".areas_colegio (id_area, nombre, responsable, id_responsable) VALUES (1, 'Biblioteca', 'María López', 1);
INSERT INTO "Iona Duarte".areas_colegio (id_area, nombre, responsable, id_responsable) VALUES (2, 'Laboratorio de Computación', 'José Martínez', 2);
INSERT INTO "Iona Duarte".areas_colegio (id_area, nombre, responsable, id_responsable) VALUES (3, 'Administración', 'Laura Fernández', 3);
INSERT INTO "Iona Duarte".areas_colegio (id_area, nombre, responsable, id_responsable) VALUES (4, 'Aula de Clases', 'Pedro Ramírez', 4);


--
-- TOC entry 3631 (class 0 OID 1638401)
-- Dependencies: 242
-- Data for Name: categorias; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".categorias (id_categoria, nombre, descripcion) VALUES (1, 'Útiles Escolares', 'Material de papelería y útiles escolares');
INSERT INTO "Iona Duarte".categorias (id_categoria, nombre, descripcion) VALUES (2, 'Libros', 'Libros de texto y literatura');
INSERT INTO "Iona Duarte".categorias (id_categoria, nombre, descripcion) VALUES (3, 'Equipos Tecnológicos', 'Computadoras, proyectores y equipos electrónicos');
INSERT INTO "Iona Duarte".categorias (id_categoria, nombre, descripcion) VALUES (4, 'Mobiliario', 'Mesas, sillas y muebles escolares');


--
-- TOC entry 3639 (class 0 OID 1638447)
-- Dependencies: 250
-- Data for Name: compras; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (1, '2024-01-01', 1, 500.00);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (2, '2024-02-01', 2, 1000.00);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (3, '2024-03-01', 3, 1500.00);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (7, '2025-02-27', 3, 2500.00);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (12, '2025-03-15', 1, NULL);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (13, '2025-03-15', 1, NULL);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (15, '2025-03-15', 1, NULL);
INSERT INTO "Iona Duarte".compras (id_compra, fecha, id_proveedor, total) VALUES (17, '2025-03-15', 1, NULL);


--
-- TOC entry 3641 (class 0 OID 1638459)
-- Dependencies: 252
-- Data for Name: detalles_compras; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (1, 1, 1, 100, 0.50);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (2, 1, 2, 50, 2.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (3, 2, 3, 30, 20.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (4, 3, 4, 5, 800.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (5, 1, 1, 100, 0.50);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (6, 1, 2, 50, 2.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (7, 2, 3, 30, 20.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (8, 3, 4, 5, 800.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (13, 7, 4, 5, 800.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (14, 7, 5, 2, 500.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (23, 12, 3, 10, 1500.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (24, 12, 5, 5, 3200.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (25, 13, 3, 50, 1500.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (26, 13, 5, 15, 3200.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (29, 15, 3, 50, 1500.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (30, 15, 4, 15, 3200.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (33, 17, 3, 50, 1500.00);
INSERT INTO "Iona Duarte".detalles_compras (id_detalle, id_compra, id_producto, cantidad, precio_unitario) VALUES (34, 17, 5, 15, 3200.00);


--
-- TOC entry 3645 (class 0 OID 1638488)
-- Dependencies: 256
-- Data for Name: detalles_salidas; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".detalles_salidas (id_detalle, id_salida, id_producto, cantidad) VALUES (1, 1, 1, 20);
INSERT INTO "Iona Duarte".detalles_salidas (id_detalle, id_salida, id_producto, cantidad) VALUES (2, 1, 2, 10);
INSERT INTO "Iona Duarte".detalles_salidas (id_detalle, id_salida, id_producto, cantidad) VALUES (3, 2, 4, 2);
INSERT INTO "Iona Duarte".detalles_salidas (id_detalle, id_salida, id_producto, cantidad) VALUES (4, 4, 4, 5);
INSERT INTO "Iona Duarte".detalles_salidas (id_detalle, id_salida, id_producto, cantidad) VALUES (5, 4, 5, 2);


--
-- TOC entry 3633 (class 0 OID 1638419)
-- Dependencies: 244
-- Data for Name: productos; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES (1, 'Lápiz', 'Lápiz de grafito HB', 0.50, 500, 1);
INSERT INTO "Iona Duarte".productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES (2, 'Cuaderno', 'Cuaderno de 100 hojas', 2.00, 300, 1);
INSERT INTO "Iona Duarte".productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES (3, 'Libro de Matemáticas', 'Libro de álgebra para secundaria', 20.00, 100, 2);
INSERT INTO "Iona Duarte".productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES (4, 'Computadora', 'Laptop para docentes', 800.00, 20, 3);
INSERT INTO "Iona Duarte".productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES (5, 'Silla Escolar', 'Silla con escritorio adjunto', 50.00, 50, 4);


--
-- TOC entry 3635 (class 0 OID 1638433)
-- Dependencies: 246
-- Data for Name: proveedores; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".proveedores (id_proveedor, nombre, contacto, telefono, email, direccion) VALUES (1, 'Distribuidora Escolar', 'Juan Pérez', '555-1111', 'contacto@distescolar.com', NULL);
INSERT INTO "Iona Duarte".proveedores (id_proveedor, nombre, contacto, telefono, email, direccion) VALUES (2, 'Librería Central', 'Ana Gómez', '555-2222', 'ventas@libreriacentral.com', NULL);
INSERT INTO "Iona Duarte".proveedores (id_proveedor, nombre, contacto, telefono, email, direccion) VALUES (3, 'TecnoEdu', 'Carlos Rivas', '555-3333', 'info@tecnoedu.com', NULL);


--
-- TOC entry 3647 (class 0 OID 1794130)
-- Dependencies: 309
-- Data for Name: responsable; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".responsable (id_responsable, nombre, cargo, contacto) VALUES (1, 'María López', 'Bibliotecaria', 'mlopez@colegio.edu');
INSERT INTO "Iona Duarte".responsable (id_responsable, nombre, cargo, contacto) VALUES (2, 'José Martínez', 'Encargado de Laboratorio', 'jmartinez@colegio.edu');
INSERT INTO "Iona Duarte".responsable (id_responsable, nombre, cargo, contacto) VALUES (3, 'Laura Fernández', 'Administradora', 'lfernandez@colegio.edu');
INSERT INTO "Iona Duarte".responsable (id_responsable, nombre, cargo, contacto) VALUES (4, 'Pedro Ramírez', 'Profesor', 'pramirez@colegio.edu');


--
-- TOC entry 3643 (class 0 OID 1638476)
-- Dependencies: 254
-- Data for Name: salidas_inventario; Type: TABLE DATA; Schema: Iona Duarte; Owner: Comfe_owner
--

INSERT INTO "Iona Duarte".salidas_inventario (id_salida, fecha, id_area, id_responsable) VALUES (1, '2024-02-10', 1, NULL);
INSERT INTO "Iona Duarte".salidas_inventario (id_salida, fecha, id_area, id_responsable) VALUES (2, '2024-02-12', 2, 2);
INSERT INTO "Iona Duarte".salidas_inventario (id_salida, fecha, id_area, id_responsable) VALUES (4, '2025-02-27', 2, 2);


--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 247
-- Name: areas_colegio_id_area_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".areas_colegio_id_area_seq', 4, true);


--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 241
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".categorias_id_categoria_seq', 4, true);


--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 249
-- Name: compras_id_compra_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".compras_id_compra_seq', 17, true);


--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 251
-- Name: detalles_compras_id_detalle_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".detalles_compras_id_detalle_seq', 34, true);


--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 255
-- Name: detalles_salidas_id_detalle_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".detalles_salidas_id_detalle_seq', 5, true);


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 243
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".productos_id_producto_seq', 5, true);


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 245
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".proveedores_id_proveedor_seq', 3, true);


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 308
-- Name: responsable_id_responsable_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".responsable_id_responsable_seq', 4, true);


--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 253
-- Name: salidas_inventario_id_salida_seq; Type: SEQUENCE SET; Schema: Iona Duarte; Owner: Comfe_owner
--

SELECT pg_catalog.setval('"Iona Duarte".salidas_inventario_id_salida_seq', 4, true);


--
-- TOC entry 3455 (class 2606 OID 1638445)
-- Name: areas_colegio areas_colegio_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".areas_colegio
    ADD CONSTRAINT areas_colegio_pkey PRIMARY KEY (id_area);


--
-- TOC entry 3449 (class 2606 OID 1638408)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 3457 (class 2606 OID 1638452)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id_compra);


--
-- TOC entry 3459 (class 2606 OID 1638464)
-- Name: detalles_compras detalles_compras_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_compras
    ADD CONSTRAINT detalles_compras_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 3463 (class 2606 OID 1638493)
-- Name: detalles_salidas detalles_salidas_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_salidas
    ADD CONSTRAINT detalles_salidas_pkey PRIMARY KEY (id_detalle);


--
-- TOC entry 3451 (class 2606 OID 1638426)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 3453 (class 2606 OID 1638438)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- TOC entry 3465 (class 2606 OID 1794135)
-- Name: responsable responsable_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".responsable
    ADD CONSTRAINT responsable_pkey PRIMARY KEY (id_responsable);


--
-- TOC entry 3461 (class 2606 OID 1638481)
-- Name: salidas_inventario salidas_inventario_pkey; Type: CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".salidas_inventario
    ADD CONSTRAINT salidas_inventario_pkey PRIMARY KEY (id_salida);


--
-- TOC entry 3468 (class 2606 OID 1638453)
-- Name: compras compras_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".compras
    ADD CONSTRAINT compras_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES "Iona Duarte".proveedores(id_proveedor);


--
-- TOC entry 3469 (class 2606 OID 1638465)
-- Name: detalles_compras detalles_compras_id_compra_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_compras
    ADD CONSTRAINT detalles_compras_id_compra_fkey FOREIGN KEY (id_compra) REFERENCES "Iona Duarte".compras(id_compra);


--
-- TOC entry 3470 (class 2606 OID 1638470)
-- Name: detalles_compras detalles_compras_id_producto_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_compras
    ADD CONSTRAINT detalles_compras_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES "Iona Duarte".productos(id_producto);


--
-- TOC entry 3473 (class 2606 OID 1638499)
-- Name: detalles_salidas detalles_salidas_id_producto_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_salidas
    ADD CONSTRAINT detalles_salidas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES "Iona Duarte".productos(id_producto);


--
-- TOC entry 3474 (class 2606 OID 1638494)
-- Name: detalles_salidas detalles_salidas_id_salida_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".detalles_salidas
    ADD CONSTRAINT detalles_salidas_id_salida_fkey FOREIGN KEY (id_salida) REFERENCES "Iona Duarte".salidas_inventario(id_salida);


--
-- TOC entry 3467 (class 2606 OID 1794136)
-- Name: areas_colegio fk_responsable_area; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".areas_colegio
    ADD CONSTRAINT fk_responsable_area FOREIGN KEY (id_responsable) REFERENCES "Iona Duarte".responsable(id_responsable);


--
-- TOC entry 3471 (class 2606 OID 1794161)
-- Name: salidas_inventario fk_responsable_salida; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".salidas_inventario
    ADD CONSTRAINT fk_responsable_salida FOREIGN KEY (id_responsable) REFERENCES "Iona Duarte".responsable(id_responsable);


--
-- TOC entry 3466 (class 2606 OID 1638427)
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES "Iona Duarte".categorias(id_categoria);


--
-- TOC entry 3472 (class 2606 OID 1638482)
-- Name: salidas_inventario salidas_inventario_id_area_fkey; Type: FK CONSTRAINT; Schema: Iona Duarte; Owner: Comfe_owner
--

ALTER TABLE ONLY "Iona Duarte".salidas_inventario
    ADD CONSTRAINT salidas_inventario_id_area_fkey FOREIGN KEY (id_area) REFERENCES "Iona Duarte".areas_colegio(id_area);


-- Completed on 2025-03-14 21:07:10

--
-- PostgreSQL database dump complete
--

