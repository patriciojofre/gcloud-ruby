 # Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"

describe Gcloud::Pubsub::Message, :mock_pubsub do
  let(:data)       { "rec_message-msg-goes-here" }
  let(:attributes) { { "foo" => "FOO", "bar" => "BAR" } }
  let(:msg)    { Gcloud::Pubsub::Message.new data, attributes }

  it "knows its data" do
    msg.data.must_equal data
  end

  it "knows its attributes" do
    msg.attributes.keys.sort.must_equal   attributes.keys.sort
    msg.attributes.values.sort.must_equal attributes.values.sort
  end

  describe "from gapi" do
    let(:topic_name) { "topic-name-goes-here" }
    let(:topic) { Gcloud::Pubsub::Topic.from_grpc Google::Pubsub::V1::Topic.decode_json(topic_json(topic_name)),
                                                  pubsub.service }
    let(:subscription_name) { "subscription-name-goes-here" }
    let(:subscription_grpc) { Google::Pubsub::V1::Subscription.decode_json(subscription_json(topic_name, subscription_name)) }
    let(:subscription) { Gcloud::Pubsub::Subscription.from_grpc subscription_grpc, pubsub.service }
    let(:rec_message_name) { "rec_message-name-goes-here" }
    let(:rec_message_msg)  { "rec_message-msg-goes-here" }
    let(:rec_message_data)  { JSON.parse(rec_message_json(rec_message_msg)) }
    let(:rec_message_grpc)  { Google::Pubsub::V1::PubsubMessage.decode_json rec_message_data["message"].to_json }
    let(:msg)     { Gcloud::Pubsub::Message.from_grpc rec_message_grpc }

    it "knows its data" do
      msg.data.must_equal rec_message_msg
    end

    it "knows its attributes" do
      msg.attributes.keys.sort.must_equal   rec_message_data["message"]["attributes"].keys.sort
      msg.attributes.values.sort.must_equal rec_message_data["message"]["attributes"].values.sort
    end

    it "knows its message_id" do
      msg.msg_id.must_equal     rec_message_data["message"]["message_id"]
      msg.message_id.must_equal rec_message_data["message"]["message_id"]
    end
  end
end
