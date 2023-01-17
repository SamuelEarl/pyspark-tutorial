This project has been created by following this tutorial: [PySpark Tutorial](https://www.youtube.com/watch?v=_C8kWso4ne4)

# How to run PySpark in JupyterLab

This tutorial provides an explanation for why you would want to use PySpark in JupyterLab: [How to set up PySpark for your Jupyter notebook](https://opensource.com/article/18/11/pyspark-jupyter-notebook)

## Using Docker (Recommended)

*Source: [Docker Stacks documentation - Using the Docker CLI](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html#using-the-docker-cli)*

You can launch a local Docker container from the [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) using the Docker command-line interface.

Run this command to start a Docker container with PySpark running inside:

```
docker run -it \
    -v "${PWD}":/home/jovyan/work \
    --user root \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS='-R' \
    -p 8888:8888 \
    --name pyspark-notebook \
    jupyter/pyspark-notebook
```

The above command pulls the `jupyter/pyspark-notebook` image currently tagged `latest` from Docker Hub if it is not already present on the local host. It then starts a container named `pyspark-notebook` running a JupyterLab server and exposes the server on host port `8888`. It also mounts a volume from the location on your computer where you ran this command to the `/home/jovyan/work` directory in the container. This means that any changes that you make (e.g. create files, write or edit code) in the `work` directory of your JupyterLab instance will be saved to your computer at the location where you ran the Docker command.

NOTE: Example 2 from [Using the Docker CLI](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html#using-the-docker-cli) and the following GitHub issue were used to create the `docker run` command above: https://github.com/jupyter/docker-stacks/issues/1187.

After running the above `docker run` command, the server logs appear in the terminal and include a URL to the JupyterLab server, like this:

```
# Entered start.sh with args: jupyter lab

# ...

#     To access the server, open this file in a browser:
#         file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
#     Or copy and paste one of these URLs:
#         http://042fc8ac2b0c:8888/lab?token=f31f2625f13d131f578fced0fc76b81d10f6c629e92c7099
#      or http://127.0.0.1:8888/lab?token=f31f2625f13d131f578fced0fc76b81d10f6c629e92c7099
```

To access the JupyterLab notebook in a browser window you can either hold the `Ctrl` button and click one of the URLs or you can copy and paste one of the URLs into a browser window.

NOTE: You might see `tornado.web.HTTPError` error messages displayed in the terminal, but you do not need to worry about those.

Pressing `Ctrl-C` twice shuts down the notebook server but leaves the container intact on disk for later restart or permanent deletion using commands like the following:

<br>

**Stop the container (from another terminal where your Docker container is not running):**
```
docker stop pyspark-notebook

# pyspark-notebook
```

NOTE: Sometimes a container will not stop running even after you press `Ctrl-C` twice. This command will come in handy in those situations.

<br>

**List all containers (both running and stopped):**
```
docker ps -a

# CONTAINER ID   IMAGE                                      COMMAND                  CREATED          STATUS                      
# PORTS                                                 NAMES
# c1c52f6a6feb   jupyter/pyspark-notebook                   "tini -g -- start-no…"   24 minutes ago   Up 19 minutes (healthy)     
# 4040/tcp, 0.0.0.0:8888->8888/tcp, :::8888->8888/tcp   pyspark-notebook
```

<br>

**Start the stopped container and include log output (with the -a flag):**
```
docker start -a pyspark-notebook

# Entered start.sh with args: jupyter lab
# ...
```

<br>

**Remove the stopped container:**
```
docker rm pyspark-notebook

# pyspark-notebook
```

<br>

### How to use `make` commands to simplify the `docker` commands

If you have the `Make` utility installed on your computer, then you can use the commands in the `Makefile` instead of the longer and difficult-to-remember `docker` commands.

The format for a `make` command is `make <command>`. You simply prefix each command in the `Makefile` with `make`. For example, instead of running 

```
docker run -it \
    -v "${PWD}":/home/jovyan/work \
    --user root \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS='-R' \
    -p 8888:8888 \
    --name pyspark-notebook \
    jupyter/pyspark-notebook
```

...you can simply run this:

```
make run
```

These are the other `make` commands:

* `make stop`
* `make list`
* `make start`
* `make remove`
* `make bash`

<br>

## Manual Setup (Not recommended, but still OK)

Read [How to set up PySpark for your Jupyter notebook](https://opensource.com/article/18/11/pyspark-jupyter-notebook)

<br>

# How to share notebook repos

You can share the repo through [binder](https://mybinder.org/).

<br>

# How to push your code up to a remote Git repo from this Docker container

Access the running container in a new terminal window: `docker container exec -it pyspark-tutorial bash`. Or you can enter `make bash` in a new terminal window.

Once you are in the running container, navigate into the `work` directory: `cd work`

<br>

## Setup the Git repo

1. `git init`
2. `git config --global --add safe.directory /home/jovyan/work`
        1. NOTE: If you try to type `git add -A` without entering the above command, then you will get this error: `fatal: detected dubious ownership in repository at '/home/jovyan/work'. To add an exception for this directory, call: git config --global --add safe.directory /home/jovyan/work`
3. `git config user.email "you@example.com"`
        1. NOTE: Omit `--global` to set the identity only in this repository.
4. `git config user.name "Your Name"`
5. `git branch -M main`
6. `git remote add origin <replace-with-your-ssh-remote-origin>`

<br>

## Set up SSH keys for your Docker container

*Source: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account*

1. Generate a new SSH key: `ssh-keygen -t ed25519 -C "you@example.com"`
2. Add your SSH key to the ssh-agent.
        1. At this prompt `root@c53ff27359fb:~/work#` type this: `sudo -s -H`
        2. Then at this prompt `root@c53ff27359fb:/home/jovyan/work#` type the following: 
                1. `eval "$(ssh-agent -s)"`
                2. `ssh-add ~/.ssh/id_ed25519`
3. Add a new SSH key to your GitHub account:
        1. Copy the SSH public key to your clipboard. At this prompt `root@c53ff27359fb:/home/jovyan/work#` type this: `cat ~/.ssh/id_ed25519.pub` 
                1. Then select and copy the contents of the `id_ed25519.pub` file displayed in the terminal to your clipboard.
        2. Then follow the rest of the instructions on this page: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account.
        3. Once you have added your SSH key to your GitHub account, type `exit` in your terminal to exit the `root@c53ff27359fb:/home/jovyan/work#` prompt and return back to the `root@c53ff27359fb:~/work#` prompt.
        
<br>

## Now you can `add`, `commit`, and `push` like you normally would

1. `git add -A`
2. `git commit -m "First commit"`
3. `git push -u origin main` (or just `git push` after you set your upstream origin with `git push -u origin main`)
