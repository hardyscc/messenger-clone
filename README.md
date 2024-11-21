## Deploy on Microk8s

```sh
docker build --build-arg http_proxy --build-arg https_proxy --push -t hacdescm/messenger-clone  .

helmfile apply
```

## Generate shadow database and migration script

```sh
brew install postgresql@15
brew service start postgresql@15
export DATABASE_URL="postgresql://$USER@localhost:5432/messenger"
npx prisma migrate dev --name init
```

## Reset shadow database from migration script

```sh
export DATABASE_URL="postgresql://$USER@localhost:5432/messenger"
npx prisma migrate reset
```

## Create production database

```sh
create user "messenger-user" with encrypted password 'User12345';
create database "messenger" with owner "messenger-user";
```

## Initialize production database

```sh
# port forward production database to localhost
export DATABASE_URL="postgresql://messenger-user:User12345@localhost:5432/messenger"
npx prisma migrate deploy
```
