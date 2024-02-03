#!/bin/bash
base_python_interpreter=""
project_domain=""
project_path=`pwd`

read -p "Python interpreter: " base_python_interpreter
read -p "Your domain without protocol (for example, google.com): " project_domain
`$base_python_interpreter -m venv env`
source env/bin/activate
pip install -U pip
pip install -r requirements.txt

sed -i "s~dbms_template_path~$project_path~g" nginx/site.conf systemd/gunicorn.service
sed -i "s~dbms_template_domain~$project_domain~g" nginx/site.conf src/config/settings.py

ln -s $project_path/nginx/site.conf /etc/nginx/sites-enabled/
ln -s $project_path/systemd/gunicorn.service /etc/systemd/system/

systemctl daemon-reload
systemctl start gunicorn
systemctl enable gunicorn
service nginx restart
