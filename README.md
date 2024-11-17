# Docker Multi-PHP Development Environment

A complete Docker development environment featuring multiple PHP versions (7.4 and 8.2), Apache with HTTPS support, MySQL, and phpMyAdmin.

## Features

- Multiple PHP versions (7.4 and 8.2)
- Apache web server with SSL/HTTPS support
- MySQL 8.0
- phpMyAdmin
- Composer included in PHP containers
- Support for multiple projects
- HTTPS with trusted local certificates

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/) (included in Docker Desktop)
- [mkcert](https://github.com/FiloSottile/mkcert) for SSL certificates

## Directory Structure

```
.
├── docker-compose.yml
├── .env
├── certs/
│   ├── cert.pem
│   └── key.pem
├── config/
│   ├── apache/
│   │   └── vhost.conf
│   ├── php74/
│   │   └── php.ini
│   └── php82/
│       └── php.ini
├── docker/
│   ├── apache.Dockerfile
│   ├── php74.Dockerfile
│   └── php82.Dockerfile
└── www/
    └── index.php
```

## Installation

1. Clone the repository:

```bash
git clone https://github.com/oubihis/docker-multi-php.git
cd docker-multi-php
```

2. Install mkcert and create SSL certificates:

```bash
# Windows (using chocolatey)
choco install mkcert

# Mac
brew install mkcert

# Linux
sudo apt install libnss3-tools
sudo apt install mkcert

# Install local CA
mkcert -install

# Create certificates
mkdir certs
mkcert -key-file certs/key.pem -cert-file certs/cert.pem localhost 127.0.0.1 ::1
```

3. Create environment file:

```bash
cp .env.example .env
```

4. Update the .env file with your desired settings:

```env
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=your_database
MYSQL_USER=your_user
MYSQL_PASSWORD=your_password
```

5. Build and start the containers:

```bash
docker-compose build --no-cache
docker-compose up -d
```

## Usage

### Accessing Services

- Website:
  - HTTP: `http://localhost`
  - HTTPS: `https://localhost`
- phpMyAdmin: `http://localhost:8080`
- MySQL:
  - Host: `localhost`
  - Port: `3306`

### PHP Versions

To switch between PHP versions, modify the Apache virtual host configuration in `config/apache/vhost.conf`:

For PHP 7.4:

```apache
ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php74:9000/var/www/html/$1
```

For PHP 8.2:

```apache
ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php82:9000/var/www/html/$1
```

After changing the PHP version, restart the containers:

```bash
docker-compose restart
```

### Working with Projects

Place your project files in the `www` directory. This directory is mounted in both PHP containers and the Apache container.

### Database Connection

Use these settings in your application's database configuration:

- Host: `mysql`
- Database: value from `MYSQL_DATABASE` in .env
- Username: value from `MYSQL_USER` in .env
- Password: value from `MYSQL_PASSWORD` in .env

### Docker Commands

Start containers:

```bash
docker-compose up -d
```

Stop containers:

```bash
docker-compose down
```

View logs:

```bash
docker-compose logs
# For specific service
docker-compose logs [service_name]
```

Rebuild containers:

```bash
docker-compose build --no-cache
```

### Adding Custom PHP Extensions

1. Edit the appropriate Dockerfile (`docker/php74.Dockerfile` or `docker/php82.Dockerfile`)
2. Add required extensions using `docker-php-ext-install`
3. Rebuild the containers

Example:

```dockerfile
# Install additional PHP extensions
RUN docker-php-ext-install gd pdo_mysql mysqli
```

## Customization

### PHP Configuration

Modify PHP settings in:

- `config/php74/php.ini` for PHP 7.4
- `config/php82/php.ini` for PHP 8.2

### Apache Configuration

Modify Apache settings in:

- `config/apache/vhost.conf`

### MySQL Configuration

MySQL settings can be modified through environment variables in the `.env` file.

## Security Notes

- Default passwords in `.env.example` are for demonstration only. Change them in your `.env` file.
- Generated SSL certificates are for local development only.
- Don't use this configuration in production without proper security hardening.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
