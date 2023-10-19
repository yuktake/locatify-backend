class Api::V1::LocationsController < ApplicationController

    def index
        # mに変換
        lat = params[:lat].to_f
        lng = params[:lng].to_f
        radius = params[:radius].to_i * 1000
        locations = Location
            .select("id, uid, mid, point, thumbnail, preview_url, track_name, artist_name, ST_DWithin(point, 'SRID=4326;POINT(#{lat} #{lng})'::GEOGRAPHY, #{radius}) as distance, created_at, updated_at")
            .where("ST_DWithin(point, 'SRID=4326;POINT(#{lat} #{lng})'::GEOGRAPHY, #{radius})")
            .order('distance')
            .limit(20)

        render json: { 
            status: 200, 
            locations: locations.map do |location| 
                JSON.parse(location.to_json).merge({
                    x: location.point.x,
                    y: location.point.y,
                })
            end
        }
    end

    def create
        timestamp = Time.now.gmtime;
        res = ActiveRecord::Base.connection.execute("
            INSERT INTO locations 
            (uid,mid,point,thumbnail,preview_url,track_name,artist_name,created_at,updated_at) VALUES 
            ('#{params[:uid]}', '#{params[:mid]}', ST_GeomFromText('SRID=4326;POINT(#{params[:lat]} #{params[:lng]})'), '#{params[:thumbnail]}', '#{params[:preview_url]}', '#{params[:track_name]}', '#{params[:artist_name]}', '#{timestamp}', '#{timestamp}')
            on conflict (uid) 
            do update set 
                mid = excluded.mid,
                point = excluded.point,
                thumbnail = excluded.thumbnail,
                preview_url = excluded.preview_url,
                track_name = excluded.track_name,
                artist_name = excluded.artist_name,
                created_at = excluded.created_at,
                updated_at = excluded.updated_at
        ")

        render json: { status: 200 }
    end

    def show
        location = Location.where(uid: params[:id])[0]
        if Location.exists?(uid: params[:id]) then
            render json: { status: 200, location: JSON.parse(location.to_json).merge({
                x: location.point.x,
                y: location.point.y,
            }) }
        else
            render json: { status: 404, location: nil}
        end
    end
end