What is wrong with flow style?
------------------------------

Flow style is a feature of YAML that uses curly brackets - {, } and looks a little like embedded JSON.

.. code-block:: yaml

    a: 1
    b: {c: 3, d: 4}

This use of JSONesque { and } is also ugly and hampers readability - *especially* when { and } are used for other purposes (e.g. templating) and the human reader/writer of YAML has to give themselves a headache figuring out what *kind* of curly bracket it is.

The *first* question in the FAQ of pyyaml actually subtly indicates that this feature wasn't a good idea - see "`why does my YAML look wrong? <http://pyyaml.org/wiki/PyYAMLDocumentation#Dictionarieswithoutnestedcollectionsarenotdumpedcorrectly>`_".

To take a real life example, use of flow style in `this saltstack YAML definition <https://github.com/saltstack-formulas/mysql-formula/blob/master/mysql/server.sls#L27>`_ blurs the distinction between flow style and jinja2,
confusing the reader.
