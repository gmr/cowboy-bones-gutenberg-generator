cowboy-bones-gutenberg-generator
================================

A Gutenberg generator for creating a Cowboy (2.0.0 pre1) application with
templating, i18n, logging, JSON support, and an example page using Bootstrap
for UI formatting.

The request handler will respect the ``Accept`` header for both ``text/html``
and ``application/json`` values. Additionally, the HTML view will demonstrate
how to use translations with the ``Accept-Language`` header. There are two
translations out of the box, one for English (the default and ``en``) the
other is Spanish (``es``).

Application Dependencies
------------------------
The following applications are expected to be installed in a global scope prior
to installing via ``gutenberg``.

- GNU gettext, with bin files (``xgettext``, ``msgen``, etc) in ``$PATH``
- bower
