Roundtripped YAML:
  based on: strictyaml
  description: |
    Loaded YAML can be modified and dumped out again with
    comments preserved using .as_yaml().
    
    Note that due to some bugs in the library (ruamel.yaml)
    underlying StrictYAML, while the data parsed should
    be precisely the same, the exact syntax (newlines, comment
    locations, etc.) may not be identical.
  preconditions:
    yaml_snippet: |
      # Some comment
      
      a: â # value comment
      
      # Another comment
      b:
        x: 4
        y: 5
      c:
      - a: 1
      - b: 2
    setup: |
        from strictyaml import Map, MapPattern, Str, Seq, Int, load

        schema = Map({
            "a": Str(),
            "b": Map({"x": Int(), "y": Int()}),
            "c": Seq(MapPattern(Str(), Str())),
        })
  variations: 
    Commented:
      preconditions:
        code: load(yaml_snippet, schema).as_yaml()
      scenario:
        - Should be equal to: yaml_snippet
    Modified:
      preconditions:
        code: |
          to_modify = load(yaml_snippet, schema)
          to_modify['b']['x'] = 2
          to_modify['c'][0]['a'] = '3'
          to_modify['b']['x'] = 'not an integer'
      scenario:
        - Raises exception: found non-integer

    Modified with one variable:
      preconditions:
        setup: |
          from strictyaml import Map, MapPattern, Str, Seq, Int, load

          schema = Map({
              "a": Str(),
              "b": Map({"x": Int(), "y": Int()}),
              "c": Seq(MapPattern(Str(), Str())),
          })
        
          to_modify = load(yaml_snippet, schema)
          to_modify['b']['x'] = 2
          to_modify['c'][0]['a'] = '3'
        code: |
          to_modify.as_yaml()
        modified_yaml_snippet: |
          # Some comment
          
          a: â # value comment
          
          # Another comment
          b:
            y: 5
            x: 2
          c:
          - a: 3
          - b: 2
      scenario:
        - Should be equal to: modified_yaml_snippet

    Text across lines:
      preconditions:
        setup: |
          from strictyaml import Map, MapPattern, Str, Seq, Int, load

          schema = Map({
              "a": Str(),
              "b": Map({"x": Int(), "y": Int()}),
              "c": Seq(MapPattern(Str(), Str())),
          })
        
          to_modify = load(yaml_snippet, schema)

          to_modify['c'][0]['a'] = "text\nacross\nlines"
        modified_yaml_snippet: |
          # Some comment
          
          a: â # value comment
          
          # Another comment
          b:
            x: 4
            y: 5
          c:
          - a: |-
              text
              across
              lines
          - b: 2
        code: to_modify.as_yaml()
      scenario:
        - Should be equal to: modified_yaml_snippet
