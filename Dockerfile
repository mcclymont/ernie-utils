FROM ruby:2.6.3-alpine

RUN gem update --system

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

EXPOSE 9292/tcp

CMD bundle exec rackup --host 0.0.0.0 -p 9292
