--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

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

--
-- Name: gentoo_riscv_ci; Type: DATABASE; Schema: -; Owner: buildbot
--

CREATE DATABASE "gentoo_riscv_ci" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE "gentoo_riscv_ci" OWNER TO buildbot;

\connect -reuse-previous=on "dbname='gentoo_riscv_ci'"

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

--
-- Name: projects_builds_status; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_builds_status AS ENUM (
    'failed',
    'completed',
    'in-progress',
    'waiting',
    'warning'
);


ALTER TYPE public.projects_builds_status OWNER TO buildbot;

--
-- Name: projects_pattern_search_type; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_pattern_search_type AS ENUM (
    'in',
    'startswith',
    'endswith',
    'search'
);


ALTER TYPE public.projects_pattern_search_type OWNER TO buildbot;

--
-- Name: projects_pattern_status; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_pattern_status AS ENUM (
    'info',
    'warning',
    'error',
    'ignore'
);


ALTER TYPE public.projects_pattern_status OWNER TO buildbot;

--
-- Name: projects_pattern_type; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_pattern_type AS ENUM (
    'info',
    'qa',
    'compile',
    'configure',
    'install',
    'postinst',
    'prepare',
    'setup',
    'test',
    'unpack',
    'ignore',
    'issues',
    'misc',
    'elog',
    'pretend'
);


ALTER TYPE public.projects_pattern_type OWNER TO buildbot;

--
-- Name: projects_portage_directorys; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_portage_directorys AS ENUM (
    'make.profile',
    'repos.conf'
);


ALTER TYPE public.projects_portage_directorys OWNER TO buildbot;

--
-- Name: projects_portage_package_directorys; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_portage_package_directorys AS ENUM (
    'use',
    'accept_keywords',
    'exclude',
    'env'
);


ALTER TYPE public.projects_portage_package_directorys OWNER TO buildbot;

--
-- Name: projects_repositorys_pkgcheck; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_repositorys_pkgcheck AS ENUM (
    'package',
    'full',
    'none'
);


ALTER TYPE public.projects_repositorys_pkgcheck OWNER TO buildbot;

--
-- Name: projects_status; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.projects_status AS ENUM (
    'stable',
    'all',
    'unstable'
);


ALTER TYPE public.projects_status OWNER TO buildbot;

--
-- Name: repositorys_type; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.repositorys_type AS ENUM (
    'gitpuller'
);


ALTER TYPE public.repositorys_type OWNER TO buildbot;

--
-- Name: versions_keywords_status; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.versions_keywords_status AS ENUM (
    'stable',
    'unstable',
    'negative',
    'all'
);


ALTER TYPE public.versions_keywords_status OWNER TO buildbot;

--
-- Name: versions_metadata_type; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.versions_metadata_type AS ENUM (
    'iuse',
    'properties',
    'required use',
    'restrict',
    'keyword'
);


ALTER TYPE public.versions_metadata_type OWNER TO buildbot;

--
-- Name: workers_type; Type: TYPE; Schema: public; Owner: buildbot
--

CREATE TYPE public.workers_type AS ENUM (
    'default',
    'local',
    'latent'
);


ALTER TYPE public.workers_type OWNER TO buildbot;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categorys; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.categorys (
    uuid character varying(36) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.categorys OWNER TO buildbot;

--
-- Name: keywords; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.keywords (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.keywords OWNER TO buildbot;

--
-- Name: migrate_version; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.migrate_version (
    repository_id character varying(250) NOT NULL,
    repository_path text,
    version integer
);


ALTER TABLE public.migrate_version OWNER TO buildbot;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.packages (
    name character varying(100) NOT NULL,
    category_uuid character varying(36),
    repository_uuid character varying(36),
    deleted boolean,
    deleted_at integer,
    uuid character varying(36) NOT NULL
);


ALTER TABLE public.packages OWNER TO buildbot;

--
-- Name: portages_makeconf; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.portages_makeconf (
    id integer NOT NULL,
    variable character varying(50) NOT NULL
);


ALTER TABLE public.portages_makeconf OWNER TO buildbot;

--
-- Name: portages_makeconf_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.portages_makeconf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portages_makeconf_id_seq OWNER TO buildbot;

--
-- Name: portages_makeconf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.portages_makeconf_id_seq OWNED BY public.portages_makeconf.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects (
    uuid character varying(36) NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    profile character varying(255) NOT NULL,
    profile_repository_uuid character varying(36) NOT NULL,
    keyword_id integer,
    status public.projects_status,
    auto boolean,
    enabled boolean,
    created_by integer NOT NULL,
    use_default boolean
);


ALTER TABLE public.projects OWNER TO buildbot;

--
-- Name: projects_builds; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_builds (
    id integer NOT NULL,
    project_uuid character varying(36),
    version_uuid character varying(36),
    build_id integer NOT NULL,
    buildbot_build_id integer DEFAULT 0,
    status public.projects_builds_status,
    requested boolean,
    created_at integer,
    updated_at integer,
    deleted_at integer,
    deleted boolean
);


ALTER TABLE public.projects_builds OWNER TO buildbot;

--
-- Name: projects_builds_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_builds_id_seq OWNER TO buildbot;

--
-- Name: projects_builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_builds_id_seq OWNED BY public.projects_builds.id;


--
-- Name: projects_emerge_options; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_emerge_options (
    id integer NOT NULL,
    project_uuid character varying(36),
    oneshot boolean,
    depclean boolean,
    preserved_libs boolean
);


ALTER TABLE public.projects_emerge_options OWNER TO buildbot;

--
-- Name: projects_emerge_options_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_emerge_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_emerge_options_id_seq OWNER TO buildbot;

--
-- Name: projects_emerge_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_emerge_options_id_seq OWNED BY public.projects_emerge_options.id;


--
-- Name: projects_pattern; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_pattern (
    id integer NOT NULL,
    project_uuid character varying(36),
    search character varying(100) NOT NULL,
    start integer,
    "end" integer,
    type public.projects_pattern_type,
    status public.projects_pattern_status,
    search_type public.projects_pattern_search_type
);


ALTER TABLE public.projects_pattern OWNER TO buildbot;

--
-- Name: projects_pattern_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_pattern_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_pattern_id_seq OWNER TO buildbot;

--
-- Name: projects_pattern_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_pattern_id_seq OWNED BY public.projects_pattern.id;


--
-- Name: projects_portage; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_portage (
    id integer NOT NULL,
    project_uuid character varying(36),
    directorys public.projects_portage_directorys,
    value character varying(255) NOT NULL
);


ALTER TABLE public.projects_portage OWNER TO buildbot;

--
-- Name: projects_portage_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_portage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_portage_id_seq OWNER TO buildbot;

--
-- Name: projects_portage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_portage_id_seq OWNED BY public.projects_portage.id;


--
-- Name: projects_portages_env; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_portages_env (
    id integer NOT NULL,
    project_uuid character varying(36),
    makeconf_id integer,
    name character varying(50) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.projects_portages_env OWNER TO buildbot;

--
-- Name: projects_portages_env_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_portages_env_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_portages_env_id_seq OWNER TO buildbot;

--
-- Name: projects_portages_env_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_portages_env_id_seq OWNED BY public.projects_portages_env.id;


--
-- Name: projects_portages_makeconf; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_portages_makeconf (
    id integer NOT NULL,
    project_uuid character varying(36),
    makeconf_id integer,
    value character varying(255) NOT NULL
);


ALTER TABLE public.projects_portages_makeconf OWNER TO buildbot;

--
-- Name: projects_portages_makeconf_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_portages_makeconf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_portages_makeconf_id_seq OWNER TO buildbot;

--
-- Name: projects_portages_makeconf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_portages_makeconf_id_seq OWNED BY public.projects_portages_makeconf.id;


--
-- Name: projects_portages_package; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_portages_package (
    id bigint NOT NULL,
    project_uuid character varying(36),
    directory public.projects_portage_package_directorys,
    package character varying(50),
    value character varying(10)
);


ALTER TABLE public.projects_portages_package OWNER TO buildbot;

--
-- Name: projects_repositorys; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_repositorys (
    id integer NOT NULL,
    project_uuid character varying(36),
    repository_uuid character varying(36),
    auto boolean,
    pkgcheck public.projects_repositorys_pkgcheck,
    build boolean,
    test boolean
);


ALTER TABLE public.projects_repositorys OWNER TO buildbot;

--
-- Name: projects_repositorys_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.projects_repositorys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_repositorys_id_seq OWNER TO buildbot;

--
-- Name: projects_repositorys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.projects_repositorys_id_seq OWNED BY public.projects_repositorys.id;


--
-- Name: projects_workers; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.projects_workers (
    id bigint NOT NULL,
    project_uuid character varying(36),
    worker_uuid character varying(36)
);


ALTER TABLE public.projects_workers OWNER TO buildbot;

--
-- Name: repositorys; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.repositorys (
    name character varying(255) NOT NULL,
    description text,
    url character varying(255),
    auto boolean,
    enabled boolean,
    ebuild boolean,
    type public.repositorys_type,
    uuid character varying(36) NOT NULL
);


ALTER TABLE public.repositorys OWNER TO buildbot;

--
-- Name: repositorys_gitpullers; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.repositorys_gitpullers (
    id integer NOT NULL,
    repository_uuid character varying(36),
    project character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    branches character varying(255) NOT NULL,
    poll_interval integer NOT NULL,
    poll_random_delay_min integer NOT NULL,
    poll_random_delay_max integer NOT NULL,
    updated_at integer DEFAULT 0
);


ALTER TABLE public.repositorys_gitpullers OWNER TO buildbot;

--
-- Name: repositorys_gitpullers_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.repositorys_gitpullers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repositorys_gitpullers_id_seq OWNER TO buildbot;

--
-- Name: repositorys_gitpullers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.repositorys_gitpullers_id_seq OWNED BY public.repositorys_gitpullers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.users (
    uid integer NOT NULL,
    email character varying(255) NOT NULL,
    bb_username character varying(128) DEFAULT NULL::character varying,
    bb_password character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public.users OWNER TO buildbot;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.users_uid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO buildbot;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: buildbot
--

ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.versions (
    uuid character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    package_uuid character varying(36),
    file_hash character varying(255) NOT NULL,
    commit_id character varying(255) NOT NULL,
    deleted boolean,
    deleted_at integer
);


ALTER TABLE public.versions OWNER TO buildbot;

--
-- Name: versions_keywords; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.versions_keywords (
    uuid character varying(36) NOT NULL,
    keyword_id integer NOT NULL,
    version_uuid character varying(36),
    status public.versions_keywords_status
);


ALTER TABLE public.versions_keywords OWNER TO buildbot;

--
-- Name: versions_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: buildbot
--

CREATE SEQUENCE public.versions_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.versions_metadata_id_seq OWNER TO buildbot;

--
-- Name: versions_metadata; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.versions_metadata (
    version_uuid character varying(36),
    metadata public.versions_metadata_type,
    value character varying(255),
    id integer DEFAULT nextval('public.versions_metadata_id_seq'::regclass) NOT NULL
);


ALTER TABLE public.versions_metadata OWNER TO buildbot;

--
-- Name: workers; Type: TABLE; Schema: public; Owner: buildbot
--

CREATE TABLE public.workers (
    uuid character varying(36),
    enable boolean,
    type public.workers_type
);


ALTER TABLE public.workers OWNER TO buildbot;

--
-- Name: portages_makeconf id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.portages_makeconf ALTER COLUMN id SET DEFAULT nextval('public.portages_makeconf_id_seq'::regclass);


--
-- Name: projects_builds id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_builds ALTER COLUMN id SET DEFAULT nextval('public.projects_builds_id_seq'::regclass);


--
-- Name: projects_emerge_options id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_emerge_options ALTER COLUMN id SET DEFAULT nextval('public.projects_emerge_options_id_seq'::regclass);


--
-- Name: projects_pattern id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_pattern ALTER COLUMN id SET DEFAULT nextval('public.projects_pattern_id_seq'::regclass);


--
-- Name: projects_portage id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portage ALTER COLUMN id SET DEFAULT nextval('public.projects_portage_id_seq'::regclass);


--
-- Name: projects_portages_env id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_env ALTER COLUMN id SET DEFAULT nextval('public.projects_portages_env_id_seq'::regclass);


--
-- Name: projects_portages_makeconf id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_makeconf ALTER COLUMN id SET DEFAULT nextval('public.projects_portages_makeconf_id_seq'::regclass);


--
-- Name: projects_repositorys id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_repositorys ALTER COLUMN id SET DEFAULT nextval('public.projects_repositorys_id_seq'::regclass);


--
-- Name: repositorys_gitpullers id; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys_gitpullers ALTER COLUMN id SET DEFAULT nextval('public.repositorys_gitpullers_id_seq'::regclass);


--
-- Name: users uid; Type: DEFAULT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);


--
-- Data for Name: categorys; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.categorys (uuid, name) FROM stdin;
75d87269-95b7-48ba-8847-6ecb6c8b0c88	dev-python
5bc8446d-aef4-4bc6-9354-fd6a42239ee7	dev-lang
e5de84ef-0eb8-447b-b70c-f8e46dabb68c	net-proxy
59e21fda-4a73-4636-9c29-cc39dc8a9dda	dev-util
42494578-5c7f-4a6c-a00d-84d932a735c8	media-libs
cc4d09dc-45a5-4e56-9bac-64601ba202a1	app-emulation
eb0d9ebd-d051-41b7-8626-92455757d59d	dev-ruby
64669bb5-8248-43ab-b794-8359c334a5c4	net-vpn
006793b6-fba0-4e25-aab0-c86e559f6bb6	acct-user
ff46f8dc-62c3-4e20-9282-da0f76b6dffc	x11-terms
d3de94ff-8daf-4076-8009-b99837f339f8	app-admin
2995bd0d-a3e8-4e1d-9e7a-ed26331e5fec	media-sound
0055cf05-7d41-49b4-a7b9-4c0ba2226496	net-mail
bb08d30e-eb18-444a-b8f0-6521f2a27329	xfce-base
fed00771-c9cd-416a-a2fc-2f642b8a27d3	app-emacs
8632a067-a0e4-4734-b08c-02bc60fb9a14	net-p2p
943b9245-1507-422e-9e02-f0a044b38fce	media-gfx
a008cff5-d10b-4fa0-92c0-51c825bf9a25	app-crypt
d5e83b4c-e314-48eb-89c3-8ec21db85edf	x11-wm
78e08409-fd99-4de7-ae48-2acd598c1f06	x11-misc
87c903c0-7ca9-4efb-ad0d-d879d25143f9	media-plugins
c5474d4b-3f14-4d52-b9d4-f9169106223c	sys-auth
7d05a9a2-3c67-42d1-96d8-641186fa74fc	net-analyzer
984634c6-7c4c-4797-a4cc-83299e327b31	mail-mta
aafe58e4-f76a-45db-bb73-284e5e2c0a51	net-wireless
cbe2acfb-0292-4133-b407-55fb61b49077	sci-chemistry
deaf6698-e383-4bca-9547-4d387a930bea	sys-kernel
1b9bc702-9f9d-43e6-8a74-80d3e11921e7	games-emulation
ec0b8a2b-3d2d-4e5a-87ed-b24d862e160e	mail-client
73991eec-c792-4fa8-ad26-4128ee4dfb55	app-dicts
967989b4-e090-472b-b655-bead1ddb9855	dev-vcs
9db9d6f5-319a-4212-a44b-a8d041015561	dev-ml
d9500f40-480b-4883-a082-7dd4d045e273	dev-libs
072ba7b4-9361-4b9a-9ab0-0a5ae4dbc9bc	media-video
e8bd6dfc-999f-4981-8bf7-1d3f0a250b33	app-text
f9853fea-42a4-4c5b-a267-0dbc2233080a	dev-db
2f511523-7d7d-40bb-b035-7425862f47d0	app-misc
64735c4a-330a-4107-92e0-c50208a3853c	sci-mathematics
54ad5dac-d7db-4aea-8b09-f5fe8e02a17e	sci-biology
a573f9f8-bae1-42b1-bc8e-7dbbcd27a111	games-engines
bb774dff-5deb-400e-a122-474157512b0c	net-libs
b50e4391-d748-423a-8b0f-3b6534fd8c96	gnome-extra
f4bb3174-d08b-46a5-a05d-d1aef2a846c5	app-editors
f86efc4b-3543-4dd9-93b3-7cf909695cd0	lxde-base
f9740190-a939-4701-b1ff-0ed1f6598b6e	app-portage
0308f280-f325-4e4c-a0d7-cbe6ad97767d	dev-haskell
9bd6667f-8912-49b3-8ed6-9b75b35acc51	x11-themes
3ef6a04d-a0b5-446e-989d-225d21ec35b3	media-fonts
73cbee99-3ed0-432e-900d-945e8820f832	app-arch
6ccdcf0a-a90f-4cb8-8e5c-59476aa58591	x11-libs
804494d0-9559-4de0-bc1f-a6849e6e3021	app-metrics
093b3058-3c0d-4b7a-a2eb-6fa9bcf10282	x11-drivers
11a011b4-4e79-4263-a04f-ed44aefcf36b	net-misc
838c48fb-c30a-49c8-9e1f-ca67ade605da	net-firewall
14bf8191-4637-438d-832e-6c7e8e83aebb	sci-libs
7d3b76cb-11d2-4e67-8796-0912e0a3cd4f	sys-boot
984d7721-2346-4def-9a7a-a5b430bb0bab	net-printeger
f13f3439-85ce-4447-b072-a4b6f37f4960	sys-block
6131886f-5efa-4b35-9ad1-58bf680820e7	net-dns
633d8f41-c53f-4520-b357-9738dc05f6b1	games-util
8426b431-4d2b-4915-8b41-dd383f3b11bb	app-shells
c9671d80-caac-4a3d-a7a3-070ee81a4865	sys-apps
18423760-77bb-441e-98d5-64f693c57f32	sys-cluster
aedf1397-2c45-4f83-8c07-cd11d3c18ffe	dev-java
c307f5ac-db63-4481-a617-b37c4aac5691	app-mobilephone
a91517d7-e5a2-46df-8c12-06806cb7a99c	dev-scheme
8c8b20b9-49fc-400b-abbd-a5b1eca99224	sci-physics
d228e621-69f2-40fc-b962-6aa43a1e8529	sci-geosciences
e9506084-eb58-43ea-9890-784c205c6aff	dev-php
76152c5e-909d-48e1-b443-46bf0e59d7bd	net-im
5c03408f-59a3-467d-b4f7-397829046020	www-apps
ac7ed6ec-0563-4a3a-a882-53358b4d4271	gnome-base
f5c0d334-04cf-46f8-91bd-fb0b296133b8	sys-process
aebbd0af-6320-4ac9-b429-178621985050	dev-cpp
46eceac7-2ce2-43ed-8906-d899dde626cd	sys-fs
5cb874a4-70dc-452f-a109-5005e6156607	net-ftp
ee282335-ee39-409a-9df8-155c9627efd3	sys-devel
faa2aae2-dbd2-4181-a927-5221515ec460	gui-libs
cc5b7d8e-04ec-4f0f-bf59-82bfd9e7ef7b	www-client
757d0a41-7c01-497e-8ec7-4d0f03191bd8	app-vim
06c509c9-4996-4e80-b420-22691a3d7bed	dev-perl
287e38a8-5ba3-49b0-a993-c0965b934181	app-backup
606039a5-a4bb-442b-b45a-777fa105394b	sys-libs
c2176517-0078-469d-9eb9-8fbac39c8269	net-irc
6c431c6f-ff42-4108-8b0c-132ba6c18ab3	xfce-extra
981a8c8a-c66f-435d-a500-b74bebaad4c2	www-plugins
51177961-26f5-4b4e-bacc-5adabb331ae3	dev-qt
98176369-2d0a-44b5-a2af-736780605af0	virtual
669413d8-88be-4c83-a9fa-f2c10d0ef662	media-radio
8b8c2c89-cc94-49fa-a71b-cbd93d52a032	mail-filter
f1d954cb-eb1c-4220-a35f-14523fd29f58	net-fs
86ecd3e7-64f2-4ba6-8ba7-290a39713b98	net-nds
5be9ac25-3c9f-40f3-9e7e-3e77f448a719	games-simulation
69df5af0-6a9b-486e-b4c7-dcc219c84f84	gui-wm
3a8929c1-69a3-4dcf-80ad-4fbf9f393db2	games-board
6de09052-d880-4e10-ab3c-c1e5b81c44b4	app-benchmarks
8b775181-516e-48de-8ce6-5c49158a07ce	dev-tcltk
8bfce850-aa11-4a21-b319-c037e185350c	app-i18n
b6674f60-00ac-43ee-91c3-01199059b731	www-servers
26ff7bf8-467f-4e72-bf63-759dd912348a	acct-group
d950112d-d8df-4570-9fdd-d5ad6e5f5043	app-laptop
b69b3519-34d1-416f-a880-9f6e8c159b79	sci-electronics
d8e7043c-98fc-45d1-b469-918499cd037e	dev-lisp
4c136608-6f08-4179-b35a-eb955077ae88	app-office
67216091-16fd-40cc-9a23-beb4e259a513	games-puzzle
279e0374-9e18-4f57-8172-0075d84d6daa	net-dialup
fff1aa8d-f1e3-4220-bf24-177cac8c3bf7	x11-plugins
02b755c9-8726-463f-85cd-a52f80631393	dev-lua
06d956b2-65de-47cd-9e20-1e6eb1ec5d68	media-tv
c711efcf-9f8f-4fc7-902f-2e790bf10100	net-voip
30328b52-128f-479c-b986-2fa89dc25ed5	app-eselect
51ed29e2-1bba-431c-ac8e-ab1a1fe88920	games-strategy
fb9ab672-3214-4b32-acc4-2bd87ce6a9ad	dev-ros
b7a0e9e6-c1b5-459f-a2e6-ceaa8760fb19	dev-games
fee08b2f-a30d-442a-928e-f6829f195a34	sci-visualization
98e8e4cc-6112-485f-8dbe-aef230f679ab	app-forensics
fe39f5c7-c466-4e44-a4b9-5d84eb9d35bf	app-accessibility
c7c44a9d-c70e-4152-abd0-f77694c5f0ad	dev-tex
0b836d6b-d7be-48f8-a8f5-025f0fa925f5	www-apache
cfef4e2f-c465-4e29-a1b8-ecc1f421237d	www-misc
fd81103e-ab50-417b-afd6-c3ea50041651	app-cdr
b7edb223-0a8e-4549-8ac5-fc0b0437cf9b	games-arcade
a65f3b64-b5a6-4cfb-97db-ccbaccc21f54	games-fps
5e9d7b3d-185b-4c60-885b-87e302e22e39	games-action
b6209bf5-9849-4198-ad3f-7821ed7c043f	dev-texlive
4dfa2022-a8d0-457a-9efe-07f7e3a017ba	games-misc
c610ddb0-d539-4564-95ca-65f198e4dc0f	kde-frameworks
4f0b8d20-edbf-4146-9961-e9785723fbd5	kde-apps
a6788379-d868-477e-b2f6-303266397acd	kde-plasma
65a5fa8e-c384-4f10-ae4f-eea4938ca0e9	app-doc
6bd59f0a-0a5f-4336-a2ef-47fde7ca2dce	sci-astronomy
aa01d2e0-0fa7-403d-8de2-43d5fc42239b	dev-embedded
f24d92bb-1d44-4898-8bc8-917314c01199	sci-misc
350acdb0-74b7-43ea-98d9-4c3907de52e3	gui-apps
795eb61e-7763-475e-ad8e-5968e5f76872	games-roguelike
b956ccde-c49d-4ff7-9c19-488862785625	sys-firmware
891340a7-b2c0-426d-ba2f-b061dce8da82	x11-apps
af03c490-128c-4f61-b914-277ba1fc487d	mate-base
2b31aad3-3c46-42e9-88f2-9b06777b2531	ros-meta
3beffd83-a877-4a04-988a-7e6fddfb852b	kde-misc
85b542d0-8b64-4289-a67c-e5f86fcb73f5	perl-core
acce056e-d0dd-463f-8e5f-94e00558e6cb	sci-calculators
46dd76c0-16e8-42f3-8526-c0e9b1abaeed	x11-base
9c2ee466-e51c-457b-b8ca-999dcc7314c4	games-mud
5f20c4b5-5358-4f59-b80b-4c11650f791a	games-rpg
c2571651-1494-4e64-aca9-0226fab82cbd	games-sports
e15d9f90-eebb-4569-b927-be72e34cb26a	sys-fabric
1aed347d-5f97-4f77-af7a-5b8efb2c75c0	app-antivirus
49c054a5-bca2-418c-ba22-943f4992cc1f	games-server
bdc81442-110f-4ceb-a7b3-abd1ee5e1ca8	dev-ada
e179034e-7e22-4925-ba5a-6920c54d1b75	mate-extra
827a4523-104e-4e1f-8b6c-9914d4582548	gnustep-base
2676457b-a2ff-4990-bedd-7236109c30ec	net-news
f86c6039-8c81-4967-92f3-ae76ad650c09	net-print
51e46568-f7cb-4ce3-86b0-9408c61875e3	dev-dotnet
554524ec-5d4e-41b0-a09f-630466715f9c	dev-go
dc2e1f83-1877-4fb3-bf2b-6ee88e3c8942	games-kids
a9b623eb-026e-4d57-8dc2-9701b41d83d7	gnustep-libs
5caf19d2-7bd9-46cd-aec0-a3749e658c3b	net-nntp
aae288d1-f1a6-4ff4-9f02-32322400cda9	lxqt-base
e5924fa1-9f98-41ae-b6f9-10e059ecd8f5	app-pda
b0ff5450-696f-4743-a6ba-b18c4d23a51d	gnustep-apps
75c7a2d3-6cc1-47f2-a2d9-1f6d2a8428bf	sys-power
aa7dc37f-fae6-4814-b1b4-a6938a073fa0	sec-policy
d94f440b-a0a0-4d9d-a4c2-9a1a52a72536	dev-erlang
2fde80c3-da32-42b5-ab5e-dcef3231b842	app-officeext
3e22d695-7391-4b80-aec0-c38495be775d	app-xemacs
3c14f428-88c8-4477-accc-3a5cbfcc4e53	java-virtuals
8d407bf2-74b3-4abf-9935-c5919c704bf3	sec-keys
1a891ebb-2cd9-46bb-b348-de606574d5e6	app-containers
\.


--
-- Data for Name: keywords; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.keywords (id, name) FROM stdin;
1	amd64
2	alpha
3	arm
4	arm64
5	hppa
6	ia64
7	m68k
8	mips
9	ppc
10	ppc64
11	riscv
12	s390
13	sparc
14	x86
15	x64-macos
16	x64-cygwin
17	amd64-linux
18	x86-linux
19	ppc-macos
20	sparc-solaris
21	sparc64-solaris
22	x64-solaris
23	x86-solaris
30	*
38	x86-winnt
39	arm64-linux
40	ppc64-linux
41	arm-linux
\.


--
-- Data for Name: migrate_version; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.migrate_version (repository_id, repository_path, version) FROM stdin;
GentooCi	.	0
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.packages (name, category_uuid, repository_uuid, deleted, deleted_at, uuid) FROM stdin;
\.


--
-- Data for Name: portages_makeconf; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.portages_makeconf (id, variable) FROM stdin;
1	CFLAGS
2	FCFLAGS
3	EMERGE_DEFAULT_OPTS
4	FEATURES
5	CXXFLAGS
6	FFLAGS
7	ACCEPT_PROPERTIES
8	ACCEPT_RESTRICT
9	ACCEPT_LICENSE
10	PYTHON_TARGETS
11	RUBY_TARGETS
12	ABI_X86
13	CHOST
14	USE
15	LINGUAS
16	L10N
17	GENTOO_MIRRORS
18	DISTDIR
19	PORTAGE_TMPDIR
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects (uuid, name, description, profile, profile_repository_uuid, keyword_id, status, auto, enabled, created_by, use_default) FROM stdin;
e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	gosbstest	Gentoo Ci test project	profiles/default/linux/amd64	e89c2c1a-46e0-4ded-81dd-c51afeb7fcbb	1	unstable	t	t	1	t
e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gosbsbase	Gentoo Ci base project	profiles/default/linux/amd64	e89c2c1a-46e0-4ded-81dd-c51afeb7fcbb	1	all	t	t	1	f
e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	defamd6417_1unstable	Default amd64 17.1 Unstable	profiles/default/linux/amd64/17.1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcbb	1	unstable	t	t	1	t
\.


--
-- Data for Name: projects_builds; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_builds (id, project_uuid, version_uuid, build_id, buildbot_build_id, status, requested, created_at, updated_at, deleted_at, deleted) FROM stdin;
\.


--
-- Data for Name: projects_emerge_options; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_emerge_options (id, project_uuid, oneshot, depclean, preserved_libs) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	t	t	t
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	t	t	t
\.


--
-- Data for Name: projects_pattern; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_pattern (id, project_uuid, search, start, "end", type, status, search_type) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	FileNotFoundError:	0	0	issues	error	search
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	dial tcp: lookup proxy.golang.org	0	0	issues	error	search
3	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go:.* read: connection refused	0	0	issues	error	search
4	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Fetched file: .* VERIFY FAILED!	0	0	issues	error	search
5	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:Reason: Filesize does not match recorded size	0	0	issues	error	search
6	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Couldn't download .* Aborting.	0	0	issues	error	search
7	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Fetch failed for	0	0	issues	error	search
8	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* multilib-strict check failed!	0	0	issues	error	search
9	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The ebuild phase .* has exited unexpectedly. This type of	0	0	issues	error	search
10	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ecompress-file failed	0	0	issues	error	search
11	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unsupported EAPI	0	0	issues	error	search
12	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Files matching a file type that is not allowed:	0	0	issues	error	search
13	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ninja: build stopped:	0	0	issues	error	search
14	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\* ERROR: .* failed:	0	0	issues	error	search
15	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: No such file or directory.  Stop.	0	0	issues	error	search
16	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ln: failed to create symbolic link .*: File exists	0	0	issues	error	search
17	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Segmentation fault	0	0	issues	error	search
18	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^Error:	0	0	issues	error	search
19	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: error:	0	0	issues	error	search
20	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed:.*expression.*unknown option	0	0	issues	error	search
21	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed.*failed	0	0	issues	error	search
22	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^ERROR:	0	0	issues	error	search
23	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.:.*: Error:	0	0	issues	error	search
24	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: .	0	0	issues	error	search
25	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please fix the ebuild to use correct FHS/Gentoo policy paths	0	0	issues	error	search
26	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^ERROR	0	0	issues	error	search
27	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error .	0	0	issues	error	search
28	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   .* failed	0	0	issues	error	search
29	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unsupported kernel version!	0	0	issues	error	search
30	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* ERROR:	0	0	issues	error	search
50	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The futex facility returned an unexpected error code.	0	0	compile	error	search
51	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	asciidoctor.*cannot load	0	0	compile	error	search
52	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gems.*asciidocter.*LoadError	0	0	compile	error	search
53	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is not a compiled interface for this version of OCaml	0	0	compile	error	search
54	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: multiple definition of.*: first defined here	0	0	compile	error	search
55	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.atal error:	0	0	compile	error	search
56	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: internal compiler error:	0	0	compile	error	search
57	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	undefined reference to	0	0	compile	error	search
58	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't read	0	0	compile	error	search
59	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	class file .* not found	0	0	compile	error	search
60	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: redefinition of	0	0	compile	error	search
61	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	has incomplete type	0	0	compile	error	search
62	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	undefined symbol:	0	0	compile	error	search
63	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	exited with code: 1.	0	0	compile	error	search
64	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	I can't find the format file	0	0	compile	error	search
65	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	; recompile with -fPIC	0	0	compile	error	search
66	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	must be installed to use	0	0	compile	error	search
67	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Non type-variable argument	0	0	compile	error	search
68	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	too few arguments to function	0	0	compile	error	search
69	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: redefining predefined macro	0	0	compile	error	search
70	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Line indented less than expected	0	0	compile	error	search
71	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	final link failed: Nonrepresentable section on output	0	0	compile	error	search
72	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ld: cannot find	0	0	compile	error	search
73	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	file cannot create directory:	0	0	compile	error	search
74	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Not in scope:	0	0	compile	error	search
75	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ld: -r and -pie may not be used together	0	0	compile	error	search
76	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.so: error adding symbols:	0	0	compile	error	search
77	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	recompile with -fPIE	0	0	compile	error	search
78	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: syntax error in	0	0	compile	error	search
79	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: error adding symbol	0	0	compile	error	search
80	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Parse error .	0	0	compile	error	search
81	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	object has no attribute	0	0	compile	error	search
82	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*.texinfo:.*: unknown command	0	0	compile	error	search
83	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	reference to Parameter is ambiguous	0	0	compile	error	search
84	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unknown M68KMAKE directive	0	0	compile	error	search
85	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ModuleNotFoundError: No module named	0	0	compile	error	search
86	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Invalid C declaration:	0	0	compile	error	search
87	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: undefined method	0	0	compile	error	search
88	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make inconsistent assumptions over	0	0	compile	error	search
89	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	file was not found	0	0	compile	error	search
90	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cannot specify link libraries for target .* which is not built	0	0	compile	error	search
91	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	include called with wrong number of arguments	0	0	compile	error	search
92	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: fatal error: .*	0	0	compile	error	search
93	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	internal error in relocate	0	0	compile	error	search
94	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failure:	0	0	compile	error	search
95	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 A duplicate ELSE command was found inside an IF block.	0	0	compile	error	search
96	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed to load interface for	0	0	compile	error	search
97	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ImportError:	0	0	compile	error	search
98	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The .* distribution was not found and is required by	0	0	compile	error	search
99	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	stack smashing detected	0	0	compile	error	search
100	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Errors in .* projects	0	0	compile	error	search
101	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: undefined reference	0	0	compile	error	search
102	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CSC: error .*:	0	0	compile	error	search
103	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: error adding symbols:	0	0	compile	error	search
104	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error: No implementations provided for the following modules:	0	0	compile	error	search
105	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LoadError	0	0	compile	error	search
106	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cannot find symbol	0	0	compile	error	search
107	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	bad class file:	0	0	compile	error	search
108	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Compile failed; see the compiler error	0	0	compile	error	search
109	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Patch:	0	0	compile	error	search
110	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	can't get .* relocation type	0	0	compile	error	search
111	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	texi2info failed	0	0	compile	error	search
112	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is not a function name	0	0	compile	error	search
113	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to find program	0	0	compile	error	search
114	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	javac: invalid source release	0	0	compile	error	search
115	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unknown channel	0	0	compile	error	search
116	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	bad option	0	0	compile	error	search
117	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Assertion .* failed	0	0	compile	error	search
118	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	dereferencing pointer to	0	0	compile	error	search
119	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error getting	0	0	compile	error	search
120	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error on line	0	0	compile	error	search
121	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is not on the classpath.	0	0	compile	error	search
122	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Running automake	0	0	compile	error	search
123	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error while loading shared libraries	0	0	compile	error	search
124	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mv: cannot stat	0	0	compile	error	search
125	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	No CommonLisp implementation found	0	0	compile	error	search
126	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not link test program to Python	0	0	compile	error	search
127	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is banned in EAPI=	0	0	compile	error	search
128	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	exceeds the 32 bit address space	0	0	compile	error	search
129	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please upgrade your Go installation.	0	0	compile	error	search
130	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please install go.* or later.	0	0	compile	error	search
131	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make:.* Stop.	0	0	compile	error	search
132	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error adding symbols:	0	0	compile	error	search
133	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pdflatex failed	0	0	compile	error	search
134	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	An exception has occurred in the compiler	0	0	compile	error	search
135	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error in .* command	0	0	compile	error	search
136	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't locate .* in @INC	0	0	compile	error	search
137	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: expected expression before	0	0	compile	error	search
138	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 error: narrowing conversion of	0	0	compile	error	search
139	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 error: implicit declaration of	0	0	compile	error	search
140	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 failed: .*glib-genmarshal	0	0	compile	error	search
141	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: signals-marshal.h: No such file or directory	0	0	compile	error	search
142	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error:.*command not found	0	0	compile	error	search
143	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gck-marshal.list: Permission denied	0	0	compile	error	search
144	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This expression has type .* but an expression	0	0	compile	error	search
145	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mmap: wanted .* bytes at .*, actually mapped at .*	0	0	compile	error	search
146	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pushd.*No such file or directory	0	0	compile	error	search
147	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to set SELinux security labels	0	0	compile	error	search
148	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	patch .* failed with	0	0	compile	error	search
149	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	csc: invalid option	0	0	compile	error	search
150	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unknown module(s) in QT	0	0	compile	error	search
151	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LaTeX Error:	0	0	compile	error	search
152	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error producing PDF from TeX source	0	0	compile	error	search
153	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error .*GCING.* in	0	0	compile	error	search
154	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Warning as Error:	0	0	compile	error	search
155	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pdfetex exited with bad status	0	0	compile	error	search
156	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SyntaxError: invalid syntax	0	0	compile	error	search
157	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SyntaxError: Missing parentheses in call to	0	0	compile	error	search
158	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	AppArmor parser error for	0	0	compile	error	search
159	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/usr/bin/install: will not overwrite just-created	0	0	compile	error	search
160	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gettext infrastructure mismatch	0	0	compile	error	search
161	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	missing binary operator before token	0	0	compile	error	search
162	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	are incompatible when linking	0	0	compile	error	search
163	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	POD document had syntax errors	0	0	compile	error	search
164	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	No supported Python implementation	0	0	compile	error	search
165	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Ambiguous occurrence	0	0	compile	error	search
166	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Compilation failed in require at	0	0	compile	error	search
167	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	failed to load "	0	0	compile	error	search
168	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Type of arg .* to shift must be array	0	0	compile	error	search
169	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	java.lang.NoSuchMethodError:	0	0	compile	error	search
170	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Document .* does not validate	0	0	compile	error	search
171	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	not enough memory for initialization	0	0	compile	error	search
172	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	dblatex or fop must be installed to use	0	0	compile	error	search
173	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	could not be found, but is required.	0	0	compile	error	search
174	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The library 'System.Xml.dll' could not be found.	0	0	compile	error	search
175	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mktextfm:.*failed to make	0	0	compile	error	search
176	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Running autopoint	0	0	compile	error	search
177	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/sh: .* No such file or directory	0	0	compile	error	search
178	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	requires support for 32-bit executables.	0	0	compile	error	search
179	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed setting classpath from Ant task	0	0	compile	error	search
180	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Option .* requires an argument	0	0	compile	error	search
181	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: .* undeclared	0	0	compile	error	search
182	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	parser error : .* not defined	0	0	compile	error	search
183	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 invalid option	0	0	compile	error	search
184	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This BEAM file was compiled for a later version of the run-time system than	0	0	compile	error	search
185	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Uncaught error in	0	0	compile	error	search
186	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Project ERROR: .* package not found	0	0	compile	error	search
187	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*:.*:.*: error:	0	0	compile	error	search
188	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Error:	0	0	compile	error	search
189	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	recipe for target .* failed	0	0	compile	error	search
190	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	backend requires .* - aborting	0	0	compile	error	search
191	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	convert: no	0	0	compile	error	search
192	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	syntax error	0	0	compile	error	search
193	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	record .* undefined	0	0	compile	error	search
194	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	E: Failure	0	0	compile	error	search
195	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	terminated with error code	0	0	compile	error	search
196	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	setup.py:.*: UserWarning: .* must be installed to build	0	0	compile	error	search
197	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Function .* not defined	0	0	compile	error	search
198	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	extra arguments no longer supported; please file a bug	0	0	compile	error	search
199	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Buildfile: .* does not exist!	0	0	compile	error	search
200	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	E: Cannot find external tool	0	0	compile	error	search
201	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pushd: too many arguments	0	0	compile	error	search
202	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	are banned in EAPI	0	0	compile	error	search
203	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gmcs: No such file or directory	0	0	compile	error	search
204	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	python_export called without a python implementation and EPYTHON is unset	0	0	compile	error	search
205	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Discovering .* failed	0	0	compile	error	search
206	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Usage: mmc	0	0	compile	error	search
207	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make.*Command not found	0	0	compile	error	search
208	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 (OTHER_FAULT)	0	0	compile	error	search
209	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Errors while running	0	0	compile	error	search
210	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Not supported in your configuration: ocamlopt	0	0	compile	error	search
211	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Analysis failed with error:	0	0	compile	error	search
212	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: expected	0	0	compile	error	search
213	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	env.*No such file or directory	0	0	compile	error	search
214	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	RuntimeError: failed to run:	0	0	compile	error	search
215	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: static declaration of	0	0	compile	error	search
216	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Not in scope:	0	0	compile	error	search
217	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error\\[.*\\]:	0	0	compile	error	search
218	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sh: .* No such file or directory	0	0	compile	error	search
219	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/sh: .* Not a directory	0	0	compile	error	search
220	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 (RuntimeError)	0	0	compile	error	search
221	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 API requires the .* utility to be installed	0	0	compile	error	search
222	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	  unbound variable:	0	0	compile	error	search
224	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rm: cannot remove 'libsrtp.a': No such file or directory	0	0	compile	error	search
225	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	OTP release .* does not match required regex	0	0	compile	error	search
226	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't open heap image file	0	0	compile	error	search
227	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\[ERROR\\]	0	0	compile	error	search
228	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Relocatable linking .* is not supported	0	0	compile	error	search
229	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Makefile.* Terminated	0	0	compile	error	search
230	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	asciidoc: Command not found	0	0	compile	error	search
231	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	PermissionError:	0	0	compile	error	search
232	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	missing separator.  Stop.	0	0	compile	error	search
234	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is illegal here	0	0	compile	error	search
235	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	fatal error: .*: No such file or directory	0	0	compile	error	search
236	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	IOError: Unable to	0	0	compile	error	search
237	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	OSError:	0	0	compile	error	search
238	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error: Could not find suitable distribution for Requirement	0	0	compile	error	search
239	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	TypeError:	0	0	compile	error	search
240	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	moc: could not find a Qt installation	0	0	compile	error	search
241	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	lrelease: could not exec	0	0	compile	error	search
242	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	loadable library and perl binaries are mismatched	0	0	compile	error	search
243	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ModuleNotFoundError: No module named	0	0	compile	error	search
244	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed to get connection to xfconfd:	0	0	compile	error	search
245	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	setup: can't find source for	0	0	compile	error	search
246	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:Error:	0	0	compile	error	search
247	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	RuntimeError: maximum recursion depth exceeded while calling a Python object	0	0	compile	error	search
248	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to access the X Display, is $DISPLAY set properly?	0	0	compile	error	search
249	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The variable KERN_DIR must be a kernel build folder	0	0	compile	error	search
251	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Compiling .*.erl failed:	0	0	compile	error	search
252	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Need to define GLIB_MKENUMS	0	0	compile	error	search
253	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mkdir /root/cache: permission denied	0	0	compile	error	search
254	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^IOError:	0	0	compile	error	search
255	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not find servlet-api.jar in	0	0	compile	error	search
256	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.xml:.*Execute failed:	0	0	compile	error	search
257	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Fatal Error:	0	0	compile	error	search
258	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 relocation target .* not defined	0	0	compile	error	search
259	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	tput: unknown terminal	0	0	compile	error	search
260	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	marshal.list: Permission denied	0	0	compile	error	search
261	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please port gnulib .* to your platform	0	0	compile	error	search
262	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	no required module provides	0	0	compile	error	search
263	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^command failed:	0	0	compile	error	search
264	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	NameError:	0	0	compile	error	search
265	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	build cache is disabled by GOCACHE=off, but required as of Go	0	0	compile	error	search
266	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error while opening .* for reading: No such file or directory	0	0	compile	error	search
267	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Bad file descriptor, skipping file,	0	0	compile	error	search
268	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: file not recognized: File format not recognized	0	0	compile	error	search
269	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^Cannot open assembly	0	0	compile	error	search
270	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^Makefile:.*.* does not exist.	0	0	compile	error	search
271	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ValueError: Only strings are accepted for the license field, files are not accepted	0	0	compile	error	search
272	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go: cannot find GOROOT directory:	0	0	compile	error	search
273	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Metadata file .* could not be found	0	0	compile	error	search
274	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rl:.*: .* undefined	0	0	compile	error	search
275	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This crate is only compatible with	0	0	compile	error	search
276	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 error:.*:	0	0	compile	error	search
277	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Abnormal terminated	0	0	compile	error	search
278	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.go:.*:.*: undefined:	0	0	compile	error	search
279	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: cannot open linker script	0	0	compile	error	search
280	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go: error loading module requirements	0	0	compile	error	search
281	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	utf8 .* does not map to Unicode	0	0	compile	error	search
282	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	flag provided but not defined	0	0	compile	error	search
283	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	build flag .* only valid when using modules	0	0	compile	error	search
284	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Exception: ERROR: cannot find a valid pkg-config entry	0	0	compile	error	search
285	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	unlink: .* Permission denied	0	0	compile	error	search
483	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^fatal: not a git repository	0	0	configure	error	search
250	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^fatal: (?!not a git)	0	0	compile	error	search
286	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	RuntimeError: ERROR: Your setuptools version is too old	0	0	compile	error	search
287	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	python.*: can't open file .*] No such file or directory	0	0	compile	error	search
288	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Variable .* not found in the output	0	0	compile	error	search
289	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ocamlfind: Package .* not found	0	0	compile	error	search
290	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This expression has type .* but an expression was expected	0	0	compile	error	search
291	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Makefile.* is required .*.*Stop	0	0	compile	error	search
292	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ghc: unrecognised flag:	0	0	compile	error	search
293	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	trying to run .* on Elixir .* but	0	0	compile	error	search
294	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This .* might be unmatched	0	0	compile	error	search
295	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	iconv:.*Invalid argument	0	0	compile	error	search
296	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: fatal error:.*No such file or directory	0	0	compile	error	search
297	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please install it manually.(pip .*	0	0	compile	error	search
298	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: invalid integral value	0	0	compile	error	search
299	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	DISTUTILS_USE_SETUPTOOLS value is probably incorrect	0	0	compile	error	search
300	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ragel:	0	0	compile	error	search
301	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Execution failed for task	0	0	compile	error	search
302	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*: No such file or directory	0	0	compile	error	search
303	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	AssertionError: Need at least	0	0	compile	error	search
304	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	AttributeError:	0	0	compile	error	search
305	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ValueError:	0	0	compile	error	search
306	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	No rule to make target	0	0	compile	error	search
307	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	RuntimeError: Could not find qmake executable	0	0	compile	error	search
308	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed to determine Qt version	0	0	compile	error	search
309	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cannot find file	0	0	compile	error	search
310	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go: cannot find main module	0	0	compile	error	search
311	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go install: version is required	0	0	compile	error	search
312	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ModuleNotFoundError:	0	0	compile	error	search
313	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	libtool: error	0	0	compile	error	search
314	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	./shtool:Error:	0	0	compile	error	search
315	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ld: cannot use executable	0	0	compile	error	search
316	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ar: libdeps specified more than once	0	0	compile	error	search
317	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Fatal error	0	0	compile	error	search
318	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	uh-oh! RDoc had a problem:	0	0	compile	error	search
319	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Makefile:.* Stop.	0	0	compile	error	search
320	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cannot build with randomized sbrk.	0	0	compile	error	search
321	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^\\[error\\]	0	0	compile	error	search
322	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	UnicodeEncodeError:	0	0	compile	error	search
323	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Package .* was not found in the .* path.	0	0	compile	error	search
324	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ld: i386 architecture of input file	0	0	compile	error	search
325	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	final link failed:	0	0	compile	error	search
326	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ld returned .* exit status	0	0	compile	error	search
327	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	a: malformed archive	0	0	compile	error	search
328	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rdlibtool: command not found	0	0	compile	error	search
329	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: cannot create regular file	0	0	compile	error	search
330	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Couldn't open	0	0	compile	error	search
331	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	gdbm_fetch: Item not found	0	0	compile	error	search
332	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 Illegal qualifier	0	0	compile	error	search
333	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: cannot find package	0	0	compile	error	search
334	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   .* not found,	0	0	compile	error	search
335	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*: no input file given	0	0	compile	error	search
336	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Configuration error:	0	0	compile	error	search
337	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* not found in the JDK being used for compilation	0	0	compile	error	search
338	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cc1: some warnings being treated as errors	0	0	compile	error	search
339	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rdlibtool: error	0	0	compile	error	search
340	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	installed package .* is broken due to missing package	0	0	compile	error	search
341	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mkdir: cannot create directory	0	0	compile	error	search
342	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	root file .* not found	0	0	compile	error	search
343	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	go: updates to .* needed,	0	0	compile	error	search
344	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Symbol .* at .* has no .* type.	0	0	compile	error	search
345	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pkg_resources.UnknownExtra:	0	0	compile	error	search
346	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	can.t write to file	0	0	compile	error	search
347	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^No module named	0	0	compile	error	search
348	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/usr/bin/python.*: No module named	0	0	compile	error	search
349	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	pyglet.canvas.xlib.NoSuchDisplayException:	0	0	compile	error	search
350	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: no input files	0	0	compile	error	search
351	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Internal or unrecoverable error in:	0	0	compile	error	search
352	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Got signal before environment was installed on our thread	0	0	compile	error	search
400	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The futex facility returned an unexpected error code.	0	0	configure	error	search
401	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unknown CMake command	0	0	configure	error	search
402	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CMake will not be able to correctly generate this project.	0	0	configure	error	search
403	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	required internal CMake variable not set	0	0	configure	error	search
404	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Running autoconf	0	0	configure	error	search
405	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Running aclocal	0	0	configure	error	search
406	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	no configure script found	0	0	configure	error	search
407	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You do not have the SDL/SDL_rotozoom.h headers installed. Exiting.	0	0	configure	error	search
408	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not run psql test program, checking why...	0	0	configure	error	search
409	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	PostgreSQL slot must be set to one of:	0	0	configure	error	search
410	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   PostgreSQL slot is not set to .* or higher.	0	0	configure	error	search
411	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* library not found, but required for .* module.	0	0	configure	error	search
412	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: Fortran 77 compiler	0	0	configure	error	search
413	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: fortran compiler does not work	0	0	configure	error	search
414	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CMake will exit	0	0	configure	error	search
415	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You need build codec to run the tests	0	0	configure	error	search
416	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not find a package configuration file provided by	0	0	configure	error	search
417	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Project .rostime. tried to find library .-lpthread.	0	0	configure	error	search
418	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cannot execute 32-bit applications	0	0	configure	error	search
419	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to find clang libraries	0	0	configure	error	search
420	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	extconf.rb:.* (RuntimeError)	0	0	configure	error	search
421	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The .* version in .* must be updated.	0	0	configure	error	search
422	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	bad option:	0	0	configure	error	search
423	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Meson encountered an error	0	0	configure	error	search
424	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Invalid option:	0	0	configure	error	search
425	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Project ERROR:	0	0	configure	error	search
426	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unrecognized option	0	0	configure	error	search
427	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't locate .* in @INC	0	0	configure	error	search
428	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SyntaxError: invalid syntax	0	0	configure	error	search
429	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This version of Camlp4 is for OCaml	0	0	configure	error	search
430	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: uninitialized constant	0	0	configure	error	search
431	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	meson.build.*ERROR:.*	0	0	configure	error	search
432	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	USE Flag .* not in IUSE for	0	0	configure	error	search
433	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	configure in /.* failed	0	0	configure	error	search
434	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This expression has type .* but an expression was	0	0	configure	error	search
435	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please, run .haskell-updater	0	0	configure	error	search
436	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Detected broken packages:	0	0	configure	error	search
437	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: unsupported	0	0	configure	error	search
438	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: setupterm:	0	0	configure	error	search
439	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	bison: .* cannot open: Permission denied	0	0	configure	error	search
440	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	meson_options.txt:.* Option name debug is reserved.	0	0	configure	error	search
441	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	glib-mk.* not found	0	0	configure	error	search
442	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	glib-genmarshal needs to be installed	0	0	configure	error	search
443	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	glib-genmarshal: command not found	0	0	configure	error	search
444	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You must install glib-genmarshal	0	0	configure	error	search
445	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\-\\-.*: command not found	0	0	configure	error	search
446	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	./configure: line .*: syntax error near unexpected	0	0	configure	error	search
447	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You do not have the SDL/SDL_.* headers installed.	0	0	configure	error	search
448	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cargo package manager not found	0	0	configure	error	search
449	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The Motif libraries are not installed.	0	0	configure	error	search
450	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	flex: could not	0	0	configure	error	search
451	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	asciidoctor:.*cannot load such file	0	0	configure	error	search
453	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ERROR: unable to find	0	0	configure	error	search
454	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* requires .* install the dependency	0	0	configure	error	search
455	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SyntaxError:	0	0	configure	error	search
456	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	but please install the FUSE libraries and headers to build this module	0	0	configure	error	search
457	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: fatal error:.*No such file or directory	0	0	configure	error	search
458	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	C compiler cannot create executables	0	0	configure	error	search
459	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to find Qt	0	0	configure	error	search
460	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Package dependency requirement '.* could not be satisfied.	0	0	configure	error	search
461	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	A required package was not found	0	0	configure	error	search
462	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: No such file or directory	0	0	configure	error	search
463	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* will not be built.	0	0	configure	error	search
464	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 was not found.	0	0	configure	error	search
465	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed:	0	0	configure	error	search
466	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The version of your compiler is not supported at this time	0	0	configure	error	search
467	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not create Makefile due to some reason	0	0	configure	error	search
468	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	environment: .*: command not found	0	0	configure	error	search
469	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*: Required feature .* not found	0	0	configure	error	search
470	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 .CONFIG_	0	0	configure	error	search
471	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	checking version of x86_64-pc-linux-gnu-gcc ... .* - old version, at least .* required!	0	0	configure	error	search
472	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	  Flow control statements are not properly nested.	0	0	configure	error	search
473	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 error: Unable to find	0	0	configure	error	search
474	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The following variables are used in this project, but they are set to NOTFOUND.	0	0	configure	error	search
475	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could NOT find .* (missing:	0	0	configure	error	search
476	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	configure: error:	0	0	configure	error	search
477	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CMake Error at	0	0	configure	error	search
478	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CMake Error:	0	0	configure	error	search
479	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Configuring incomplete	0	0	configure	error	search
480	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cmake failed	0	0	configure	error	search
481	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Failed to find configuration	0	0	configure	error	search
482	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Reason: UndefinedError	0	0	configure	error	search
500	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't locate Locale/gettext.pm in @INC	0	0	install	error	search
501	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	newinitd:.* does not exist	0	0	install	error	search
502	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* .* is not a valid file/directory	0	0	install	error	search
503	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 !!! .* does not exist	0	0	install	error	search
504	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	!!! doexe:	0	0	install	error	search
505	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	chown: invalid user	0	0	install	error	search
506	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	chown: invalid group:	0	0	install	error	search
507	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ERROR:root	0	0	install	error	search
508	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	install: cannot stat .*: No such file or directory	0	0	install	error	search
509	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: fatal error:	0	0	install	error	search
510	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/sh: .* cd: .*: Not a directory	0	0	install	error	search
511	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make.* No rule to make target .* needed by .* Stop.	0	0	install	error	search
512	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unhandled exception:	0	0	install	error	search
513	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rm: .* No such file or directory	0	0	install	error	search
514	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	! LaTeX Error:	0	0	install	error	search
515	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: cannot stat.*: No such file or directory	0	0	install	error	search
516	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: target .* is not a directory	0	0	install	error	search
517	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: cannot create regular file	0	0	install	error	search
518	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed: .*: No such file or directory	0	0	install	error	search
519	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: .* Not a directory:	0	0	install	error	search
520	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/usr/bin/install: will not overwrite	0	0	install	error	search
521	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	File Finder Failed for	0	0	install	error	search
522	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/sed: symbol lookup error:	0	0	install	error	search
523	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: static declaration of	0	0	install	error	search
524	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/usr/bin/install crash	0	0	install	error	search
525	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	install: cannot create regular file	0	0	install	error	search
526	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	environment: line .*: cd: .* No such file or directory	0	0	install	error	search
527	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mv: cannot stat .* No such file or directory	0	0	install	error	search
528	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	java.lang.NoSuchMethodError:	0	0	install	error	search
529	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: No such file	0	0	install	error	search
530	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed to set XATTR_PAX markings	0	0	install	error	search
531	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Fatal error .	0	0	install	error	search
532	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	glib-mkenums: command not found	0	0	install	error	search
533	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	AttributeError:	0	0	install	error	search
534	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: unknown target	0	0	install	error	search
535	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error: The .* plugin is not installed	0	0	install	error	search
536	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Permission denied	0	0	install	error	search
537	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 note: each undeclared identifier is reported only once for each function it appears in	0	0	install	error	search
538	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 undefined reference to	0	0	install	error	search
539	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mkdir: cannot create directory	0	0	install	error	search
540	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	install: .* does not exist	0	0	install	error	search
541	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	convert: no	0	0	install	error	search
542	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: multiple definition of.*: first defined here	0	0	install	error	search
543	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Header checksum mismatch, aborting.	0	0	install	error	search
544	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* Ebuild author forgot an entry	0	0	install	error	search
545	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ModuleNotFoundError:	0	0	install	error	search
570	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	chown: cannot	0	0	postinst	error	search
571	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: cannot	0	0	postinst	error	search
572	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: command not found	0	0	postinst	error	search
600	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	patch .* failed with	0	0	prepare	error	search
601	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Cannot find \\$EPATCH_SOURCE!	0	0	prepare	error	search
602	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	you need to fix the relative paths in patch	0	0	prepare	error	search
603	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	must be called in src_prepare	0	0	prepare	error	search
604	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed Running libtoolize	0	0	prepare	error	search
605	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	eapply: no files specified	0	0	prepare	error	search
606	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The source directory .* doesn.t exist	0	0	prepare	error	search
607	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rm: cannot remove .*: No such file or directory	0	0	prepare	error	search
608	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: cannot stat	0	0	prepare	error	search
609	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed: can't read requirements.txt: No such file or directory	0	0	prepare	error	search
610	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please disable .* support in your kernel config and recompile your kernel	0	0	prepare	error	search
611	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: No such file or directory	0	0	prepare	error	search
612	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	possibly undefined macro:	0	0	prepare	error	search
613	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not find gem	0	0	prepare	error	search
614	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sed: .* unterminated .* command	0	0	prepare	error	search
615	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	can't find file to patch at input	0	0	prepare	error	search
616	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LoadError:	0	0	prepare	error	search
617	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*: command not found	0	0	prepare	error	search
618	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Project ERROR: Unknown module	0	0	prepare	error	search
619	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	iconv: unrecognized option:	0	0	prepare	error	search
620	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Bad system call	0	0	prepare	error	search
621	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: not writing through	0	0	prepare	error	search
622	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	convert:	0	0	prepare	error	search
623	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   .* not found	0	0	prepare	error	search
640	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please switch to a gcc version built with USE=	0	0	pretend	error	search
641	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Space constraints set in the ebuild were not met	0	0	pretend	error	search
642	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Unsupported version of Rust selected	0	0	pretend	error	search
643	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* Please check to make sure these options are set correctly.	0	0	pretend	error	search
644	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Kernel not configured; no .config found in	0	0	pretend	error	search
650	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You need package	0	0	setup	error	search
651	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please specify at least one package name on the command line.	0	0	setup	error	search
652	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not find a package configuration file provided by	0	0	setup	error	search
653	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	You have to install development tools first.	0	0	setup	error	search
654	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error in setup command	0	0	setup	error	search
655	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Could not find	0	0	setup	error	search
656	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Requires at least PyQ.*	0	0	setup	error	search
657	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	The Motif libraries are not installed.	0	0	setup	error	search
658	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	setup: At least the following dependencies are missing:	0	0	setup	error	search
659	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This ebuild will need the	0	0	setup	error	search
660	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This package will need access to .* cds.	0	0	setup	error	search
670	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	These fortunes have offensive content. Enable offensive USE Flag	0	0	setup	error	search
671	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	PYTHON needs to be set for	0	0	setup	error	search
672	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Add .* to DEPEND	0	0	setup	error	search
673	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cannot find package	0	0	setup	error	search
674	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Ebuild author forgot an entry	0	0	setup	error	search
675	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Please install required programs:	0	0	setup	error	search
676	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Invalid use of .*.eclass	0	0	setup	error	search
677	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	EPYTHON unset	0	0	setup	error	search
678	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	One of the following USE flags is needed:	0	0	setup	error	search
679	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	python_pkg_setup() not called	0	0	setup	error	search
680	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Missing USE flags in	0	0	setup	error	search
681	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is banned in EAPI	0	0	setup	error	search
682	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Select exactly one database type out of these: mysql oracle postgres sqlite	0	0	setup	error	search
683	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unable to find version .* of package	0	0	setup	error	search
684	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	No Python implementation set	0	0	setup	error	search
685	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*.*CONFIG_.*is not set when it should be	0	0	setup	error	search
686	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   .* requires .* (CONFIG_.*) to be	0	0	setup	error	search
687	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Kernel not configured;	0	0	setup	error	search
688	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	USE=modules and in-kernel ipset support detected.	0	0	setup	error	search
689	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   Linux .* is the latest supported version	0	0	setup	error	search
690	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* WireGuard has been merged upstream into this kernel. Therefore	0	0	setup	error	search
691	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*   One of the postgres_targets_postgresSL_OT use flags must be enabled	0	0	setup	error	search
700	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\<internal:/	0	0	test	info	search
701	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^ValueError:	0	0	test	info	search
702	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	E   ImportError:	0	0	test	info	search
703	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	____ ERROR coll	0	0	test	info	search
704	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	argparse.ArgumentError:	0	0	test	info	search
705	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^E       .*	0	0	test	info	search
706	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ImportError:	0	0	test	info	search
707	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Need FEATURES=.* to run this testsuite	0	0	test	info	search
708	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^E: Failure	0	0	test	info	search
709	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\.\\.\\. FAILED	0	0	test	info	search
710	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: FAILED (.*:.*)	0	0	test	info	search
711	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* failed unexpectedly.	0	0	test	info	search
712	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^ERROR:.*test	0	0	test	info	search
713	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failing test(s):	0	0	test	info	search
714	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 (Failed)	0	0	test	info	search
715	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	#   Failed test	0	0	test	info	search
716	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\.\\.\\. ERROR	0	0	test	info	search
717	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	FAILED: .*	0	0	test	info	search
718	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	FAILED .*test	0	0	test	info	search
719	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed tests:	0	0	test	info	search
720	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAIL .*	0	0	test	info	search
721	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAIL\\t.*	0	0	test	info	search
722	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAIL: .*	0	0	test	info	search
723	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^Failure:	0	0	test	info	search
724	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 FAIL .*	0	0	test	info	search
725	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: FAIL	0	0	test	info	search
726	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*\\*\\*Failed	0	0	test	info	search
727	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\*\\*\\*Exception:	0	0	test	info	search
728	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: FAILED:	0	0	test	info	search
729	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAILED	0	0	test	info	search
730	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed .* tests, .*% okay, .* tests skipped.	0	0	test	info	search
731	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	testsuite: .* failed	0	0	test	info	search
732	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Test .* from suite .* failed.	0	0	test	info	search
733	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Test suite test-threads: FAIL	0	0	test	info	search
734	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* tests executed, .* failures	0	0	test	info	search
735	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ERROR: test(s) failed in	0	0	test	info	search
736	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed test	0	0	test	info	search
737	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\.\\.\\. FAILED	0	0	test	info	search
738	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ERROR: ld.so: object	0	0	test	info	search
739	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	sudo: no tty present and no askpass program specified	0	0	test	info	search
740	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/sh: cppcheck: command not found	0	0	test	info	search
741	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Line .* failed	0	0	test	info	search
742	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\-\\- FAIL:	0	0	test	info	search
743	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\[  FAILED  \\]	0	0	test	info	search
744	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.*:.*: exit status 1	0	0	test	info	search
745	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	missing separator	0	0	test	info	search
746	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can.t locate .* in @INC	0	0	test	info	search
747	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAIL!	0	0	test	info	search
748	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	QFATAL :	0	0	test	info	search
749	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LoadError:	0	0	test	info	search
750	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rake aborted!	0	0	test	info	search
751	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error decrypting signature:	0	0	test	info	search
752	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	syntax error near	0	0	test	info	search
753	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: undefined reference to	0	0	test	info	search
754	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Fatal Error by .*	0	0	test	info	search
755	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: error:	0	0	test	info	search
756	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: fatal error:	0	0	test	info	search
757	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make.* Command not found	0	0	test	info	search
758	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	test.*NOT ok	0	0	test	info	search
759	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	CMake Error at	0	0	test	info	search
760	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: exit status 1	0	0	test	info	search
761	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	fatal: making test-suite.log:	0	0	test	info	search
762	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Programs failed: .	0	0	test	info	search
763	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Assertion failure	0	0	test	info	search
764	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Failed .* tests	0	0	test	info	search
765	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error: .*:test	0	0	test	info	search
766	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	No such file or directory	0	0	test	info	search
767	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: cannot execute binary file	0	0	test	info	search
768	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	AssertionError	0	0	test	info	search
769	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make.* No rule to make target	0	0	test	info	search
770	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Command not found	0	0	test	info	search
771	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	assertion .* failed	0	0	test	info	search
772	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 NOT ok	0	0	test	info	search
773	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ocamlc: unknown option	0	0	test	info	search
774	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	failed conch	0	0	test	info	search
775	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAILED: .	0	0	test	info	search
776	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SyntaxError: .	0	0	test	info	search
777	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Resolve library did not return a fully qualified domain name.	0	0	test	info	search
778	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.* Tests in .* Category Failed	0	0	test	info	search
779	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	  *FAILED  ess	0	0	test	info	search
780	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:Error:	0	0	test	info	search
782	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	test in .* failed	0	0	test	info	search
783	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/bin/bash: docker: command not found	0	0	test	info	search
784	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	\\.\\.\\.\\.\\.\\.\\. no	0	0	test	info	search
785	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\.\\. Failed .* subtests	0	0	test	info	search
786	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	==== Testing .* failed	0	0	test	info	search
787	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	t/.*.t.* module .* not found:	0	0	test	info	search
788	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	t/.*.t.* Dubious,	0	0	test	info	search
789	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unescaped left brace in regex is illegal here	0	0	test	info	search
790	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.. \\[fail\\]	0	0	test	info	search
791	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Error: This expression has type .* but an expression was expected	0	0	test	info	search
792	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^\\?: .*	0	0	test	info	search
793	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Test .* failed:	0	0	test	info	search
794	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ModuleNotFoundError:	0	0	test	info	search
795	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 FAILED (.*)	0	0	test	info	search
796	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 FAILED .*	0	0	test	info	search
797	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Missing /	0	0	test	info	search
798	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Some packages may not be found	0	0	test	info	search
799	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 failed: Cannot create directory	0	0	test	info	search
800	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	UnicodeEncodeError:	0	0	test	info	search
801	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	PluginValidationError:	0	0	test	info	search
802	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	git: command not found	0	0	test	info	search
803	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	ests failed .* python	0	0	test	info	search
804	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	INTERNALERROR. AttributeError:	0	0	test	info	search
805	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	INTERNALERROR	0	0	test	info	search
806	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: The .* command requires the .* package	0	0	test	info	search
807	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LLVM ERROR:	0	0	test	info	search
808	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	distutils.errors.	0	0	test	info	search
809	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Couldn't resolve host	0	0	test	info	search
810	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	PermissionError: .* Permission denied	0	0	test	info	search
811	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: Errorf call has arguments but no formatting directives	0	0	test	info	search
812	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: py.test: command not found	0	0	test	info	search
813	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mkdir /root/cache: permission denied	0	0	test	info	search
814	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	RuntimeError:	0	0	test	info	search
815	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	error: invalid command	0	0	test	info	search
816	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Can't use 'defined	0	0	test	info	search
817	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	FAILED (.*)	0	0	test	info	search
818	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^vet: .*	0	0	test	info	search
819	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	FAIL.* \\[.*\\]	0	0	test	info	search
820	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Errors while running CTest	0	0	test	info	search
821	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make:.* test	0	0	test	info	search
822	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	can't load package:	0	0	test	info	search
823	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: cannot find package	0	0	test	info	search
824	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 command not found	0	0	test	info	search
850	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	/usr/bin/rpm2tar: line .*:	0	0	unpack	error	search
851	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unsupported type of integrity check	0	0	unpack	error	search
852	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	tar: This does not look like a tar archive	0	0	unpack	error	search
853	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	tar: Exiting with failure status due to previous errors	0	0	unpack	error	search
353	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	^FAILED: .	0	0	compile	error	search
854	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cp: .* No such file or directory	0	0	unpack	error	search
855	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rm: cannot remove	0	0	unpack	error	search
856	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	mv: cannot stat	0	0	unpack	error	search
857	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	asciidoctor	0	0	unpack	error	search
858	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	failure unpacking	0	0	unpack	error	search
859	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	unpack: .* does not exist	0	0	unpack	error	search
900	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	.automake. called by src_prepare	0	0	qa	warning	search
901	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Automake "maintainer mode" detected:	0	0	qa	warning	search
902	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	broken .png files found	0	0	qa	warning	search
903	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cmake-utils_src_prepare has not been run	0	0	qa	warning	search
904	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	dosym target omits basename:	0	0	qa	warning	search
905	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	econf called in .* instead of	0	0	qa	warning	search
906	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	function is deprecated	0	0	qa	warning	search
907	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	inherited illegally	0	0	qa	warning	search
908	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	is deprecated, use .* instead	0	0	qa	warning	search
909	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	One or more CMake variables were not used by the project	0	0	qa	warning	search
911	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	python_.*_all() didn't call	0	0	qa	warning	search
912	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	running automake in configure phase	0	0	qa	warning	search
913	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	This ebuild installs into	0	0	qa	warning	search
914	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	Unrecognized configure options:	0	0	qa	warning	search
915	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	USE Flag .* not in IUSE for	0	0	qa	warning	search
916	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	warning: python_fix_shebang	0	0	qa	warning	search
917	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SetuptoolsDeprecationWarning: 2to3	0	0	qa	warning	search
918	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	SetuptoolsDeprecationWarning: setup.py install	0	0	qa	warning	search
919	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 * QA Notice:	0	0	qa	warning	startswith
31	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	cmake failed	0	0	issues	error	search
223	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	fatal: Not a git repository (or any parent up to mount point /var/tmp)	0	0	compile	info	search
355	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	: undefined reference to	0	0	compile	error	search
356	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:\\d+:\\d+: note: 	1	0	compile	info	search
357	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:\\d+:\\d+: warning: 	1	0	compile	info	search
354	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	:\\d+:\\d+: error: 	1	0	compile	error	search
624	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	 \\* Failed running	0	0	prepare	error	search
32	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	rake aborted!	0	0	issues	error	search
358	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	LoadError:	0	0	compile	error	search
\.


--
-- Data for Name: projects_portage; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_portage (id, project_uuid, directorys, value) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	make.profile	default/linux/amd64/17.1/no-multilib
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	repos.conf	gentoo
3	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	make.profile	default/linux/amd64/17.1/no-multilib
4	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	repos.conf	gentoo
5	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	make.profile	default/linux/amd64/17.1
6	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	repos.conf	gentoo
\.


--
-- Data for Name: projects_portages_env; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_portages_env (id, project_uuid, makeconf_id, name, value) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	4	test	test test-fail-continue
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	4	notest	-test
3	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	4	test	test test-fail-continue
\.


--
-- Data for Name: projects_portages_makeconf; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_portages_makeconf (id, project_uuid, makeconf_id, value) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	12	64
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	13	x86_64-pc-linux-gnu
3	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	X
4	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	caps
5	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	xattr
6	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	seccomp
7	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	4	xattr
8	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	4	sandbox
9	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	10	python3_8
10	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	10	python3_9
11	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	elogind
12	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	14	-systemd
13	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	9	*
15	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	11	ruby26
16	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	11	ruby27
17	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	11	ruby30
18	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	10	python3_10
19	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	4	cgroup
20	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	4	-news
21	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	4	-collision-protect
22	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	4	split-log
23	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	4	compress-build-logs
24	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--buildpkg=y
26	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--rebuild-if-new-rev=y
27	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--rebuilt-binaries=y
28	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--usepkg=y
29	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--binpkg-respect-use=y
30	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--binpkg-changed-deps=y
31	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--nospinner
32	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--color=n
33	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--ask=n
34	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--quiet-build=y
35	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	3	--quiet-fail=y
36	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	7	-interactive
37	e89c2c1a-46e0-4ded-81dd-c51afeb7fcff	8	-fetch
38	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	4	-ipc-sandbox
39	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	4	-network-sandbox
50	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	4	-cgroup
40	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	4	-pid-sandbox
41	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	14	X
42	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	14	elogind
51	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	10	python3_10
52	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	10	python3_9
53	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	10	python3_8
\.


--
-- Data for Name: projects_portages_package; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_portages_package (id, project_uuid, directory, package, value) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	www-client/chromium	
2	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	www-client/chromium	
3	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	www-client/microsoft-edge-dev	
4	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	www-client/microsoft-edge-dev	
5	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	www-client/microsoft-edge-beta	
6	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	www-client/microsoft-edge-beta	
7	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	www-client/firefox	
8	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	www-client/firefox	
9	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	dev-qt/qtwebengine	
10	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	dev-qt/qtwebengine	
11	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	sci-libs/tensorflow	
12	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	sci-libs/tensorflow	
13	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	exclude	app-office/libreoffice	
14	e89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	exclude	app-office/libreoffice	
\.


--
-- Data for Name: projects_repositorys; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_repositorys (id, project_uuid, repository_uuid, auto, pkgcheck, build, test) FROM stdin;
\.


--
-- Data for Name: projects_workers; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.projects_workers (id, project_uuid, worker_uuid) FROM stdin;
\.


--
-- Data for Name: repositorys; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.repositorys (name, description, url, auto, enabled, ebuild, type, uuid) FROM stdin;
gentoo	Gentoo main repo	https://github.com/gentoo/gentoo.git	t	t	t	gitpuller	e89c2c1a-46e0-4ded-81dd-c51afeb7fcbb
\.


--
-- Data for Name: repositorys_gitpullers; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.repositorys_gitpullers (id, repository_uuid, project, url, branches, poll_interval, poll_random_delay_min, poll_random_delay_max, updated_at) FROM stdin;
1	e89c2c1a-46e0-4ded-81dd-c51afeb7fcbb	gentoo	https://github.com/gentoo/gentoo.git	all	240	60	120	1634918051
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.users (uid, email, bb_username, bb_password) FROM stdin;
\.


--
-- Data for Name: versions; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.versions (uuid, name, package_uuid, file_hash, commit_id, deleted, deleted_at) FROM stdin;
\.


--
-- Data for Name: versions_keywords; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.versions_keywords (uuid, keyword_id, version_uuid, status) FROM stdin;
\.


--
-- Data for Name: versions_metadata; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.versions_metadata (version_uuid, metadata, value, id) FROM stdin;
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: public; Owner: buildbot
--

COPY public.workers (uuid, enable, type) FROM stdin;
a89c2c1a-46e0-4ded-81dd-c51afeb7fcfd	t	default
a89c2c1a-46e0-4ded-81dd-c51afeb7fcfa	t	default
\.


--
-- Name: portages_makeconf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.portages_makeconf_id_seq', 1, false);


--
-- Name: projects_builds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_builds_id_seq', 1, false);


--
-- Name: projects_emerge_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_emerge_options_id_seq', 1, false);


--
-- Name: projects_pattern_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_pattern_id_seq', 453, true);


--
-- Name: projects_portage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_portage_id_seq', 1, false);


--
-- Name: projects_portages_env_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_portages_env_id_seq', 1, false);


--
-- Name: projects_portages_makeconf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_portages_makeconf_id_seq', 18, true);


--
-- Name: projects_repositorys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.projects_repositorys_id_seq', 1, false);


--
-- Name: repositorys_gitpullers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.repositorys_gitpullers_id_seq', 1, false);


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.users_uid_seq', 1, false);


--
-- Name: versions_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buildbot
--

SELECT pg_catalog.setval('public.versions_metadata_id_seq', 1, false);


--
-- Name: categorys categorys_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.categorys
    ADD CONSTRAINT categorys_pkey PRIMARY KEY (uuid);


--
-- Name: categorys categorys_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.categorys
    ADD CONSTRAINT categorys_unique UNIQUE (uuid);


--
-- Name: keywords keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.keywords
    ADD CONSTRAINT keywords_pkey PRIMARY KEY (id);


--
-- Name: keywords keywords_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.keywords
    ADD CONSTRAINT keywords_unique UNIQUE (id);


--
-- Name: migrate_version migrate_version_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.migrate_version
    ADD CONSTRAINT migrate_version_pkey PRIMARY KEY (repository_id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (uuid);


--
-- Name: packages packages_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_unique UNIQUE (uuid);


--
-- Name: portages_makeconf portages_makeconf_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.portages_makeconf
    ADD CONSTRAINT portages_makeconf_pkey PRIMARY KEY (id);


--
-- Name: portages_makeconf portages_makeconf_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.portages_makeconf
    ADD CONSTRAINT portages_makeconf_unique UNIQUE (id);


--
-- Name: projects_builds projects_builds_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_builds
    ADD CONSTRAINT projects_builds_pkey PRIMARY KEY (id);


--
-- Name: projects_builds projects_builds_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_builds
    ADD CONSTRAINT projects_builds_unique UNIQUE (id);


--
-- Name: projects_emerge_options projects_emerge_options_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_emerge_options
    ADD CONSTRAINT projects_emerge_options_pkey PRIMARY KEY (id);


--
-- Name: projects_emerge_options projects_emerge_options_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_emerge_options
    ADD CONSTRAINT projects_emerge_options_unique UNIQUE (id);


--
-- Name: projects_pattern projects_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_pattern
    ADD CONSTRAINT projects_pattern_pkey PRIMARY KEY (id);


--
-- Name: projects_pattern projects_pattern_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_pattern
    ADD CONSTRAINT projects_pattern_unique UNIQUE (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (uuid);


--
-- Name: projects_portages_package projects_portage_package_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_package
    ADD CONSTRAINT projects_portage_package_pkey PRIMARY KEY (id);


--
-- Name: projects_portage projects_portage_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portage
    ADD CONSTRAINT projects_portage_pkey PRIMARY KEY (id);


--
-- Name: projects_portage projects_portage_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portage
    ADD CONSTRAINT projects_portage_unique UNIQUE (id);


--
-- Name: projects_portages_env projects_portages_env_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_env
    ADD CONSTRAINT projects_portages_env_pkey PRIMARY KEY (id);


--
-- Name: projects_portages_env projects_portages_env_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_env
    ADD CONSTRAINT projects_portages_env_unique UNIQUE (id);


--
-- Name: projects_portages_makeconf projects_portages_makeconf_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_makeconf
    ADD CONSTRAINT projects_portages_makeconf_pkey PRIMARY KEY (id);


--
-- Name: projects_portages_makeconf projects_portages_makeconf_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_makeconf
    ADD CONSTRAINT projects_portages_makeconf_unique UNIQUE (id);


--
-- Name: projects_repositorys projects_repositorys_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_repositorys
    ADD CONSTRAINT projects_repositorys_pkey PRIMARY KEY (id);


--
-- Name: projects_repositorys projects_repositorys_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_repositorys
    ADD CONSTRAINT projects_repositorys_unique UNIQUE (id);


--
-- Name: projects projects_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_unique UNIQUE (uuid);


--
-- Name: projects_workers projects_workers_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_workers
    ADD CONSTRAINT projects_workers_pkey PRIMARY KEY (id);


--
-- Name: repositorys_gitpullers repositorys_gitpullers_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys_gitpullers
    ADD CONSTRAINT repositorys_gitpullers_pkey PRIMARY KEY (id);


--
-- Name: repositorys_gitpullers repositorys_gitpullers_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys_gitpullers
    ADD CONSTRAINT repositorys_gitpullers_unique UNIQUE (id);


--
-- Name: repositorys repositorys_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys
    ADD CONSTRAINT repositorys_pkey PRIMARY KEY (uuid);


--
-- Name: repositorys repositorys_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys
    ADD CONSTRAINT repositorys_unique UNIQUE (uuid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: users users_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_unique UNIQUE (uid);


--
-- Name: versions_keywords versions_keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_keywords
    ADD CONSTRAINT versions_keywords_pkey PRIMARY KEY (uuid);


--
-- Name: versions_keywords versions_keywords_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_keywords
    ADD CONSTRAINT versions_keywords_unique UNIQUE (uuid);


--
-- Name: versions_metadata versions_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_metadata
    ADD CONSTRAINT versions_metadata_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (uuid);


--
-- Name: versions versions_unique; Type: CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_unique UNIQUE (uuid);


--
-- Name: packages category_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT category_uuid_fk FOREIGN KEY (category_uuid) REFERENCES public.categorys(uuid) NOT VALID;


--
-- Name: projects keywords_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT keywords_fkey FOREIGN KEY (keyword_id) REFERENCES public.keywords(id) NOT VALID;


--
-- Name: versions_keywords keywords_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_keywords
    ADD CONSTRAINT keywords_fkey FOREIGN KEY (keyword_id) REFERENCES public.keywords(id) NOT VALID;


--
-- Name: projects_portages_env makeconf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_env
    ADD CONSTRAINT makeconf_fkey FOREIGN KEY (makeconf_id) REFERENCES public.portages_makeconf(id) NOT VALID;


--
-- Name: projects_portages_makeconf makeconf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_makeconf
    ADD CONSTRAINT makeconf_fkey FOREIGN KEY (makeconf_id) REFERENCES public.portages_makeconf(id) NOT VALID;


--
-- Name: versions packages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT packages_fkey FOREIGN KEY (package_uuid) REFERENCES public.packages(uuid) NOT VALID;


--
-- Name: projects profile_repositorys_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT profile_repositorys_uuid_fkey FOREIGN KEY (profile_repository_uuid) REFERENCES public.repositorys(uuid) NOT VALID;


--
-- Name: projects_portages_package project_portage_package_pkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_package
    ADD CONSTRAINT project_portage_package_pkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_builds projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_builds
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_emerge_options projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_emerge_options
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_pattern projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_pattern
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_portage projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portage
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_portages_env projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_env
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_portages_makeconf projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_portages_makeconf
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_repositorys projects_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_repositorys
    ADD CONSTRAINT projects_fkey FOREIGN KEY (project_uuid) REFERENCES public.projects(uuid) NOT VALID;


--
-- Name: projects_repositorys repositorys_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_repositorys
    ADD CONSTRAINT repositorys_fkey FOREIGN KEY (repository_uuid) REFERENCES public.repositorys(uuid) NOT VALID;


--
-- Name: repositorys_gitpullers repositorys_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.repositorys_gitpullers
    ADD CONSTRAINT repositorys_fkey FOREIGN KEY (repository_uuid) REFERENCES public.repositorys(uuid) NOT VALID;


--
-- Name: packages repositorys_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT repositorys_uuid_fkey FOREIGN KEY (repository_uuid) REFERENCES public.repositorys(uuid) NOT VALID;


--
-- Name: projects_builds versions_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.projects_builds
    ADD CONSTRAINT versions_fkey FOREIGN KEY (version_uuid) REFERENCES public.versions(uuid) NOT VALID;


--
-- Name: versions_keywords versions_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_keywords
    ADD CONSTRAINT versions_fkey FOREIGN KEY (version_uuid) REFERENCES public.versions(uuid) NOT VALID;


--
-- Name: versions_metadata versions_metadata_version_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: buildbot
--

ALTER TABLE ONLY public.versions_metadata
    ADD CONSTRAINT versions_metadata_version_uuid_fkey FOREIGN KEY (version_uuid) REFERENCES public.versions(uuid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO buildbot;


--
-- PostgreSQL database dump complete
--

