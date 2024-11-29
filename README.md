# Docker Multi-PHP Development Environment

A complete Docker development environment featuring multiple PHP versions (7.4 and 8.2), Apache with HTTPS support, MySQL, and phpMyAdmin.

## Features

- Multiple PHP versions (7.4 and 8.2)
- Apache web server with SSL/HTTPS support
- MySQL 8.0
- phpMyAdmin
- Composer included in PHP containers
- Support for multiple projects
- HTTPS with trusted local certificates using mkcert

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/) (included in Docker Desktop)
- [mkcert](https://github.com/FiloSottile/mkcert) for SSL certificates

## Quick Start

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

#if update dont forget
chmod 644 certs/cert.pem certs/key.pem
```

3. Create and configure environment file:

```bash
cp .env.example .env
```

4. Update the `.env` file with these recommended development settings:

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydatabase
MYSQL_USER=admin
MYSQL_PASSWORD=admin
```

5. Build and start the containers:

```bash
docker-compose build --no-cache
docker-compose up -d
```

## Accessing Services

### Web Server

- HTTP: `http://localhost`
- HTTPS: `https://localhost`

### phpMyAdmin

- URL: `http://localhost:8080`
- Default credentials:
  ```
  Server: mysql
  Username: root
  Password: root
  ```
  or use the custom user:
  ```
  Server: mysql
  Username: admin (or MYSQL_USER from .env)
  Password: admin (or MYSQL_PASSWORD from .env)
  ```

### MySQL

- Host: `localhost` (from host machine) or `mysql` (from containers)
- Port: `3306`
- Root credentials:
  ```
  Username: root
  Password: root
  ```
- User credentials:
  ```
  Database: mydatabase (or MYSQL_DATABASE from .env)
  Username: admin (or MYSQL_USER from .env)
  Password: admin (or MYSQL_PASSWORD from .env)
  ```

## PHP Versions

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

## Adding New PHP Versions

This project supports multiple PHP versions, and you can easily add more versions based on your needs.

Currently supported versions:

- PHP 7.4
- PHP 8.2

Need another PHP version? Check out our detailed guide:
[How to Add New PHP Versions](https://github.com/oubihis/docker-multi-php/wiki/How-to-Add-New-PHP-Versions)

Example supported paths:

```
http://localhost/        # Default (PHP 7.4)
http://localhost/php74/  # PHP 7.4
http://localhost/php82/  # PHP 8.2
```

To add a new PHP version:

1. Follow the guide in the Wiki
2. Create issue if you need help
3. Share your success with the community

💡 Tip: The Wiki guide includes complete instructions, troubleshooting tips, and best practices for adding new PHP versions.

## Project Structure

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

## Common Commands

Start environment:

```bash
docker-compose up -d
```

Stop environment:

```bash
docker-compose down
```

View logs:

```bash
# All containers
docker-compose logs

# Specific container
docker-compose logs [container_name]
```

Restart services:

```bash
docker-compose restart
```

Rebuild containers:

```bash
docker-compose build --no-cache
```

## Troubleshooting

### Cannot access phpMyAdmin

1. Check if containers are running:

```bash
docker-compose ps
```

2. Check phpMyAdmin logs:

```bash
docker-compose logs phpmyadmin
```

3. Verify MySQL is running:

```bash
docker-compose logs mysql
```

### MySQL Connection Issues

1. Verify credentials in `.env` file
2. Check MySQL container status:

```bash
docker-compose ps mysql
```

3. Try connecting directly to MySQL:

```bash
docker-compose exec mysql mysql -u root -proot
```

### SSL Certificate Issues

1. Regenerate certificates using mkcert:

```bash
mkcert -install
mkcert -key-file certs/key.pem -cert-file certs/cert.pem localhost 127.0.0.1 ::1
```

2. Restart containers:

```bash
docker-compose restart
```

## Customization

### PHP Configuration

- PHP 7.4: `config/php74/php.ini`
- PHP 8.2: `config/php82/php.ini`

### Apache Configuration

- Virtual Hosts: `config/apache/vhost.conf`

### MySQL Configuration

- Environment variables in `.env`
- Custom configuration can be added to `config/mysql/my.cnf`

## Security Notes

- These credentials are for development only
- Change all passwords in production
- SSL certificates are for local development only
- Don't use this configuration in production without security hardening

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues or need help, please:

1. Check the troubleshooting section
2. Look through existing issues
3. Create a new issue with detailed information about your problem
