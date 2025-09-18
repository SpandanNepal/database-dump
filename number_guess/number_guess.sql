--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE userdetails;
--
-- Name: userdetails; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE userdetails WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE userdetails OWNER TO freecodecamp;

\connect userdetails

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: gameusers; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.gameusers (
    name character varying(22) NOT NULL,
    user_id integer NOT NULL,
    best_game integer DEFAULT 0,
    game_played integer DEFAULT 0
);


ALTER TABLE public.gameusers OWNER TO freecodecamp;

--
-- Name: gameusers_user_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.gameusers_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gameusers_user_id_seq OWNER TO freecodecamp;

--
-- Name: gameusers_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.gameusers_user_id_seq OWNED BY public.gameusers.user_id;


--
-- Name: gameusers user_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.gameusers ALTER COLUMN user_id SET DEFAULT nextval('public.gameusers_user_id_seq'::regclass);


--
-- Data for Name: gameusers; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.gameusers VALUES ('spandan', 18, 3, 2);
INSERT INTO public.gameusers VALUES ('user_1758234210994', 20, 965, 2);
INSERT INTO public.gameusers VALUES ('user_1758234210995', 19, 941, 5);
INSERT INTO public.gameusers VALUES ('user_1758234255291', 22, 983, 2);
INSERT INTO public.gameusers VALUES ('user_1758234255292', 21, 847, 5);
INSERT INTO public.gameusers VALUES ('user_1758234317971', 24, 481, 2);
INSERT INTO public.gameusers VALUES ('user_1758234317972', 23, 931, 5);


--
-- Name: gameusers_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.gameusers_user_id_seq', 24, true);


--
-- Name: gameusers gameusers_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.gameusers
    ADD CONSTRAINT gameusers_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

