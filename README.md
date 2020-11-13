pgsql
=====


<a name="toc">Table of contents</a>
-----------------------------------

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Usage](#usage)
  + [Prompt](#prompt)
  + [Loading files](#load)
  + [Miscellany](#miscellany)


<a name="overview">Overview</a>
-------------------------------

Scripts for running Postgres commands based from Miki configuration.


<a name="dependencies">Dependencies</a>
---------------------------------------

- psql


<a name="usage">Usage</a>
-------------------------

### <a name="prompt">Prompt</a>

To enter the Postgres prompt, run:

    pgsql


### <a name="Loading files"></a>

To load an SQL file, run:

    pgsql -f file.sql


### <a name="miscellany">Miscellany</a>

To display usage summary, run:

    pgsql --help
