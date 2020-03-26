# frozen_string_literal: true

require 'json'
require 'api/utils/wx_biz_data_crypt'

module API
  module V1
    class Topic < Grape::API
      include Default

      format :json
      content_type :json, 'application/json'

      version 'v1', using: :path

      before do
        auth_user
      end

      helpers do
        params :uuid_latitude_longitude do
          requires :uuid, type: String, desc: '请传入uuid'
          requires :latitude, type: String, desc: 'latitude'
          requires :longitude, type: String, desc: 'longitude'
        end
      end

      desc '发布帖子'
      params do
        use :uuid_latitude_longitude
        requires :content, type: String, desc: '帖子内容'
        requires :topic_type, type: String, values: %w[need_help provide_help reprot_safe], desc: '帖子类型'
      end
      post '/topic/create' do
        topic = ::Topic.create(
          content: params[:content],
          topic_type: params[:topic_type],
          latitude: params[:latitude],
          longitude: params[:longitude],
          customer_id: current_user.id
        )

        present topic: (present topic, with: Entities::Topic),
                response: success_response
      end

      desc '查询离我一定距离内的话题列表'
      params do
        use :uuid_latitude_longitude
        requires :distance, type: String, desc: '距离'
      end
      post '/topic/list' do
        topics = ::Topic.with_latitude_longitude(params[:latitude], params[:longitude])

        present topics: (present topics, with: Entities::Topic),
                response: success_response
      end

    end
  end
end
