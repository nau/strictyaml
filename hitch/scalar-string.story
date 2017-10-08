Scalar str:
  based on: strictyaml
  description: |
    StrictYAML parses to a YAML object, not
    the value directly to give you more flexibility
    and control over what you can do with the YAML.

    This is what that can object can do - in most
    cases if parsed as a string, it will behave in
    the same way.
  preconditions:
    setup: |
      from strictyaml import Str, Map, load
      from ensure import Ensure

      schema = Map({"a": Str(), "b": Str(), "c": Str(), "d": Str()})

      parsed = load(yaml_snippet, schema)
    yaml_snippet: |
      a: 1
      b: yes
      c: â string
      d: |
        multiline string
  variations:
    Parses correctly:
      scenario:
      - Run:
          code: |
            Ensure(parsed).equals(
                {"a": "1", "b": "yes", "c": u"â string", "d": "multiline string\n"}
            )

    Dict lookup cast to string:
      scenario:
      - Run:
          code: Ensure(str(parsed["a"])).equals("1")

    Dict lookup cast to int:
      scenario:
      - Run:
          code: |
            Ensure(int(parsed["a"])).equals(1)

    Dict lookup cast to bool impossible:
      scenario:
      - Run:
          code: bool(parsed["a"])
          raises:
            message: |-
              Cannot cast 'YAML(1)' to bool.
              Use bool(yamlobj.data) or bool(yamlobj.text) instead.

