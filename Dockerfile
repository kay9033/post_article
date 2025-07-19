FROM ruby:3.3.4

# Install Node.js 20 (LTS) and system dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y \
    nodejs \
    build-essential \
    default-libmysqlclient-dev \
    libvips \
    libyaml-dev \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN npm install -g yarn

RUN mkdir /app
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile /app/Gemfile
RUN bundle install

# Copy application code
COPY . /app

# Expose port
EXPOSE 3000

# Start server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
