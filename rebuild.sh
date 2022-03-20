#!/bin/bash
echo -e "\trebuilding the image, creating 'jupyter_notebook' container, configuring systemd and starting it."
#stop on error
set -e
#verbosee commands
set -o xtrace

#podman build -t jupyter_notebook . --no-cache
podman build -t jupyter_notebook .

#podman run --replace --name jupyter_notebook --env-file .env -v ./notebooks:/usr/src/notebooks:Z -p 3999:3999 jupyter_notebook
podman create --replace --name jupyter_notebook --env-file .env -v ./notebooks:/usr/src/notebooks:Z -p 3999:3999 jupyter_notebook

podman generate systemd --name jupyter_notebook > jupyter_notebook.service

cp -Z jupyter_notebook.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable --now jupyter_notebook.service

echo -e "\tdone rebuilding and creating 'jupyter_notebook' container."
