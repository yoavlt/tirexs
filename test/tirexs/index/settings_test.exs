Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.SettingsTest do
  use ExUnit.Case
  import Tirexs.Index.Settings

  test :simple_index_settings do
    index = [name: "bear_test"]

    settings do

      analysis do
      end

      blocks []

      translog []

      cache []

    end
    assert index[:settings] == [index: [cache: [filter: []], translog: [], blocks: []], analysis: []]
  end

  test :set_settings do
    index = [name: "bear_test"]

    settings do
      set number_of_replicas: 3,
          auto_expand_replicas: 5
    end

    assert index[:settings] == [index: [number_of_replicas: 3, auto_expand_replicas: 5]]
  end

  test :real_settings do
    index = [name: "bear_test"]

    settings do
      analysis do
        analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
        analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
        filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
        tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
      end

      cache max_size: -1

      translog disable_flush: false

      set number_of_replicas: 3
      blocks write: true
    end

    assert index[:settings] == [index: [blocks: [write: true], translog: [disable_flush: false], cache: [filter: [max_size: -1]], number_of_replicas: 3], analysis: [tokenizer: ["dot-tokenizer": [type: "path_hierarchy", delimiter: "."]], filter: [substring: [type: "nGram", min_gram: 2, max_gram: 32]], analyzer: [msg_search_analyzer: [tokenizer: "keyword", filter: ["lowercase"]], msg_index_analyzer: [tokenizer: "keyword", filter: ["lowercase","substring"]]]]]

  end

end
