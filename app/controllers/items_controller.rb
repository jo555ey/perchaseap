class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @items = []

    @keyword = params[:keyword]
    if @keyword
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })

      results.each do |result|
        # 扱い易いように Item としてインスタンスを作成する（保存はしない）
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @keep_users = @item.keep_users
  end

  private

  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
    detail = result['itemdetail']

    return {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
      detail: detail,
    }
  end
end
