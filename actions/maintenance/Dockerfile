FROM ruby:3.2.0

COPY entrypoint.sh /entrypoint.sh

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY main.rb ./

ENTRYPOINT ["/entrypoint.sh"]
