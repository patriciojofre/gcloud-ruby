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

describe Gcloud::Pubsub::Topic, :lazy, :mock_pubsub do
  let(:topic_name) { "topic-name-goes-here" }
  let(:topic) { Gcloud::Pubsub::Topic.from_grpc Google::Pubsub::V1::Topic.decode_json(topic_json(topic_name)),
                                                pubsub.service }

  it "is not lazy when created with an HTTP method" do
    topic.wont_be :lazy?
  end

  describe "lazy topic with default autocreate" do
    let(:topic) { Gcloud::Pubsub::Topic.new_lazy topic_name,
                                                 pubsub.service }

    it "will autocreate when created lazily" do
      topic.must_be :lazy?
    end
  end

  describe "lazy topic with explicit autocreate" do
    let(:topic) { Gcloud::Pubsub::Topic.new_lazy topic_name,
                                                 pubsub.service,
                                                 autocreate: true }

    it "will autocreate when created lazily" do
      topic.must_be :lazy?
    end
  end

  describe "lazy topic without autocomplete" do
    let(:topic) { Gcloud::Pubsub::Topic.new_lazy topic_name,
                                                 pubsub.service,
                                                 autocreate: false }

    it "knows if it will create a topic on the Pub/Sub service" do
      topic.must_be :lazy?
    end
  end
end
