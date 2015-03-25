defmodule KafkaEx.Integration.Metadata.Test do
  use ExUnit.Case
  @moduletag :integration

  test "add_topic returns metadata for topic" do
    metadata = KafkaEx.Metadata.new(TestHelper.get_bootstrap_hosts)
    client = KafkaEx.NetworkClient.new("test")
    topic = TestHelper.generate_random_string

    {metadata, client} = KafkaEx.Metadata.add_topic(metadata, client, topic)

    assert Map.has_key?(metadata.topics, topic)
    assert Map.has_key?(metadata, :timestamp)
    assert client.client_id == "test"
    assert client.correlation_id == 1
  end

  test "broker_for_topic returns the correct broker for the topic" do
    metadata = KafkaEx.Metadata.new(TestHelper.get_bootstrap_hosts)
    client = KafkaEx.NetworkClient.new("test")
    topic = TestHelper.generate_random_string

    {metadata, client} = KafkaEx.Metadata.add_topic(metadata, client, topic)

    {metadata, _client} = TestHelper.wait_until_topic_available(metadata, client, topic)

    broker = KafkaEx.Metadata.broker_for_topic(metadata, topic)
    assert broker == metadata.brokers[0]
  end
end
