FROM ruby:3.2.0

COPY Gemfile Gemfile.lock /code/
RUN bundle install

COPY lib/ /code/lib
COPY main.rb /code/main.rb

RUN ls

ENTRYPOINT ["ruby", "/code/main.rb"]
