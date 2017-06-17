require 'spec_helper'

describe 'Yt::HTTPRequest#run' do
  context 'given a valid GET request to a YouTube JSON API' do
    path = '/discovery/v1/apis/youtube/v3/rest'
    headers = {'User-Agent' => 'Yt::HTTPRequest'}
    params = {verbose: 1}
    request = Yt::HTTPRequest.new path: path, headers: headers, params: params

    it 'returns the HTTP response with the JSON-parsed body' do
      response = request.run
      expect(response).to be_a Net::HTTPOK
      expect(response.body).to be_a Hash
    end
  end

  context 'given a invalid GET request to a YouTube JSON API' do
    path = '/discovery/v1/apis/youtube/v3/unknown-endpoint'
    body = {token: :unknown}
    request = Yt::HTTPRequest.new path: path, method: :post, body: body

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Yt::HTTPError, 'Error: Not Found'
    end
  end

  context 'given a request that causes a connection/server error' do
    host = 'g00gl3ap1s.com'
    request = Yt::HTTPRequest.new host: host

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Yt::ConnectionError
    end
  end

  context 'given that YouTube API raises an error' do
    context 'only once' do
      path = '/discovery/v1/apis/youtube/v3/rest'
      headers = {'User-Agent' => 'Yt::HTTPRequest'}
      params = {verbose: 1}
      let(:request) { Yt::HTTPRequest.new path: path, headers: headers, params: params }
      let(:retry_response) { Net::HTTPSuccess.new '1.0', '200', 'OK' }
      before { expect(Net::HTTP).to receive(:start).at_least(:once).and_return retry_response }
      it 'returns the HTTP response with the JSON-parsed body' do
        allow(retry_response).to receive(:body).and_return('{"fake": "body"}')
        expect { request.run }.not_to raise_error
      end
    end
  end
end
