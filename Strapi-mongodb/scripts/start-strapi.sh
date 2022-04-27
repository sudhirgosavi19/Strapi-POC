#!/bin/sh

strapiCount=1
count=1
####################START_SERVICES#################################################
while :
do
sleep 5
namespace=${NAMESPACE}
APP_NAME=${APP_NAME}
DATABASE_CLIENT=${DATABASE_CLIENT}
# Kubenrnetes DNS URL for your mongo service: my-svc.my-namespace.svc.cluster-domain.example
DATABASE_HOST=${DATABASE_HOST}
DATABASE_PORT=${DATABASE_PORT}
DATABASE_NAME=${DATABASE_NAME}

if [ ! -f "/persistent/$namespace/${APP_NAME}/package.json" ] && [ ${strapiCount} == 1 ]
then
echo "====> creating project for strapi <===="
mkdir -p /persistent/$namespace/

cd /persistent/$namespace
strapi new ${APP_NAME} --dbclient=${DATABASE_CLIENT} --dbhost=${DATABASE_HOST} --dbport=${DATABASE_PORT} --dbname=${DATABASE_NAME} --dbusername=${DATABASE_USERNAME}   --dbpassword=${DATABASE_PASSWORD}

chown -R  /persistent/$namespace/${APP_NAME}
elif [ ! -d "/persistent/$namespace/${APP_NAME}/node_modules" ]
then
  echo "===> installing node modules in existing strapi project <====="
  npm install --prefix ./$APP_NAME
fi
if [ ${strapiCount} == 1 ]
then
echo "====> starting strapi <===="
cd /persistent/$namespace/${APP_NAME}
npm run build
strapi start &
fi
strapiCount=`expr $strapiCount + 1`
apk add openrc
nginx -g "daemon off;"
cd
sleep 60
done
else
   echo "not valid"
fi

while :
do
sleep 50
done