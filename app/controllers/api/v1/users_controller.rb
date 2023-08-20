class Api::V1::UsersController < ApplicationController
    def create
        timestamp = Time.now.gmtime;
        res = User.create(
            uid: params[:uid],
            email: params[:email],
            created_at: timestamp,
            updated_at: timestamp,
        )

        render json: { status: 200 }
    end

    def show
        if User.exists?(uid: params[:id]) then
            render json: { status: 200 }
        else
            render json: { status: 404 }
        end
    end
end