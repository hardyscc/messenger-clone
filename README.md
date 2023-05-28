This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.

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
