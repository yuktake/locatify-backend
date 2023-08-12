class Api::V1::LocationsController < ApplicationController

    def index
        # mに変換
        lat = params[:lat].to_f
        lng = params[:lng].to_f
        radius = params[:radius].to_i * 1000
        locations = Location.where("ST_DWithin(point, 'SRID=4326;POINT(#{lat} #{lng})'::GEOGRAPHY, #{radius})")

        render json: { status: 200, locations: locations }
    end

    def create
        timestamp = Time.now.gmtime;
        res = ActiveRecord::Base.connection.execute("INSERT INTO locations (uid,mid,point,created_at,updated_at) VALUES ('#{params[:uid]}', '#{params[:mid]}', ST_GeomFromText('SRID=4326;POINT(#{params[:lat]} #{params[:lng]})'), '#{timestamp}', '#{timestamp}')")

        render json: { status: 200 }
    end
end