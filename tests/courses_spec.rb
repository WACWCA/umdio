# TODO: implement controller tests and API endpoint tests
# TODO: make extensive tests

require_relative '../tests/spec_helper'
require 'json'

describe 'Courses Endpoint' do  # Probably should be moved higher up the test ladder. For now!
  url = '/v0/courses'
    
  shared_examples_for 'good status' do |url|
    before {head url}
    it 'has a good response' do
      expect(last_response.status).to be == 200
    end
  end

  shared_examples_for 'bad status' do |url|
    before {head url}
    it 'responds with 4xx' do
      expect(last_response.status).to be > 399
      expect(last_response.status).to be < 500
    end
  end

  describe 'Listing courses' do

    describe 'GET /courses' do #this test takes most of the time in our test suite right now (80%)
      before { get url }
      it_has_behavior 'good status', url
      it 'returns a list of courses' do
        res = JSON.parse(last_response.body)
        expect(res.length).to be > 4000
        expect(res[5000]).to be == nil 
      end
    end

  end

  describe 'GET /courses/<course_id>' do
    shared_examples_for "gets enes100" do |url|
      before {get url}
      it 'returns enes100 course object' do
        # To Fix
      end
    end

    describe 'returns correct object' do
      it_has_behavior "gets enes100", url + '/ENES100' 
    end

    describe 'returns error on misformed urls' do
      it_has_behavior 'bad status', url + '/ene12'
      it_has_behavior 'bad status', url + '/enes13'
      it_has_behavior 'bad status', url + '/enes100-0101'
      it_has_behavior 'bad status', url + '/enes100,enes132,BMGT22'
    end

    #tests for case insensitivity can just check status (so long as bad tests give bad status!)
    describe 'Case insensitive' do
      it_has_behavior "good status", url + '/ENES100' 
      it_has_behavior "good status", url + '/enes100'
      it_has_behavior "good status", url + '/Enes100'
      it_has_behavior "good status", url + '/cmsc132h'
    end

    describe 'get multiple courses' do
      it_has_behavior 'good status', url + '/ENES100,ENES102' #doesn't check return, could very well make a good corner case
      it_has_behavior 'good status', url + '/ENES100,ENES102,bmgt220'
    end

    describe 'expand query argument' do
      it 'can expand section objects' do
        get url + '/ENES100?expand=sections'
        obj = JSON.parse(last_response.body)
        expect(obj['sections'][0].kind_of?(Hash)).to be(true) 
      end
    end
  end

  describe 'GET /courses/<course_id>/sections' do
    shared_examples_for 'gets enes100 sections' do |url|
      before { get url }
      it 'returns array of section objects' do
        # To Fix
      end
    end
    
    it_has_behavior 'gets enes100 sections', url + '/enes100/sections'

    describe 'Case insensitive to course_id' do
      it_has_behavior 'good status', url + '/ENES100/sections'
      it_has_behavior 'good status', url + '/enes100/sections'
      it_has_behavior 'good status', url + '/Enes100/sections'
    end
      
    describe 'returns error on misformed urls' do
      it_has_behavior 'bad status', url + '/ene12/sections'
      it_has_behavior 'bad status', url + '/enes1000/sections'
    end

  end

  describe 'GET /courses/<course_id>/sections/<section_id>' do
    
    describe 'returns section properly' do
      before {get url + '/enes100/sections/0101'}
      it 'returns the correct section' do
        # TO Fix
      end
    end

    describe 'Case insensitive to course_id' do
      it_has_behavior 'good status', url + '/ENES100/sections/0101'
      it_has_behavior 'good status', url + '/Enes100/sections/0101'
      it_has_behavior 'good status', url + '/enes100/sections/0101'
    end

    describe 'handles multiple arguments' do
      before {get url + '/enes100/sections/0101,0201,0202,0301,0302,0401,0501,0502,0601,0602,0801'}
      it 'returns multiple sections to request' do
        # To Fix
      end
    end

    describe 'returns error on misformed urls' do
      it_has_behavior 'bad status', url + '/ene12/sections/0101'
      it_has_behavior 'bad status', url + '/enes13/sections/01'
      it_has_behavior 'bad status', url + '/enes13/sections/01011'
      it_has_behavior 'bad status', url + '/enes100/sections/enes100-0101'
      it_has_behavior 'bad status', url + '/enes100/sections/0101,0102,02'
    end

  end

  describe 'GET /courses/sections/<section_id>' do
    describe 'returns section properly' do
      before { get url + '/sections/ENES100-0101'}
      it 'returns the right section' do
          # To fix       
      end
    end

    describe 'Case insensitive' do
      it_has_behavior 'good status', url + '/sections/ENES100-0101'
      it_has_behavior 'good status', url + '/sections/enes100-0101'
      it_has_behavior 'good status', url + '/sections/Enes100-0101'
    end

    describe 'handles multiple arguments' do
      before {get url + '/sections/ENES100-0101,ENES100-0201,ENES100-0202,ENES100-0301,ENES100-0302,ENES100-0401,ENES100-0501,ENES100-0502,ENES100-0601,ENES100-0602,ENES100-0801'}
      it 'returns multiple sections on request' do
        #TO Fix
      end          
    end

    describe 'returns error on misformed urls' do
      it_has_behavior 'bad status', url + '/sections/enes100'
      it_has_behavior 'bad status', url + '/sections/enes100-010'
      it_has_behavior 'bad status', url + '/sections/enes1000101'
      it_has_behavior 'bad status', url + '/sections/enes10-0101'
      it_has_behavior 'bad status', url + '/sections/ene100-0101'
      it_has_behavior 'bad status', url + '/sections/enes100-0101,enes102-010'
    end
  end
end
