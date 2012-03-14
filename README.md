# Monsieur Touriste

**Monsieur Touriste is not up yet – I am still working on some design issues.**

Monsieur Touriste is a toy project and a Sinatra experiment that came to life
while I was visiting Europe. The basic idea is to look very tourist-ish and/or
dumb with well known locations in the background. Hopefully the number of
pictures will grow fast.

Thanks to @LP_Cloutier for his input, pictures and good laughs.

## Running the project

Monsieur Touriste runs on top of Unicorn, Sinatra and pretty much any
databsase supported by DataMapper.

### Running locally
    gem install bundler
    cp config/development{.default,}.yml
    bundle install
    rackup

### Deploy
**Setup deploy (first time only)**

    # Edit configs in config/deploy.rb
    cap deploy:setup
    # ssh to your server and copy config/production.default.yml to shared/config/production.yml
    # and edit as needed

**Deploy:**

    cap deploy
