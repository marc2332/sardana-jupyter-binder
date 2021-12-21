# sardana-jupyter
Sardana integration into the Jupyter ecosystem.

This is still a WIP. For a list of missing features/ideas see TODO.md.

## Docker demo
Create the image:
```shell
docker build --label jupysar-demo --tag jupysar-demo -f ./docker/Dockerfile .
```

Run the container:
```shell
sudo docker run -dp 8888:8888 --name jupysar-demo jupysar-demo
```

Wait some seconds, open  [localhost:8888](http://localhost:8888) and select the `Sardana Kernel` Notebook.

## Manual installation

You can install the necessary dependencies using conda. 
Prior to that, edit the `environment.yml` file to point to your
local taurus and sardana clones.

```shell
conda env create -f environment.yml
conda activate sardana-jupyter
./scripts/setup.bash
```

## Start the Jupyter Lab

Currently the Jupyter extension only instantiate the MacroServer part. 
You can still use it on its own but it may be not so interesting...

In order to use the full Sardana system you will need to run your Pool
instance as a Tango device server and point to it in the configuration file
(see the "Configuration" section below).

Then to start the Jupter Lab you just need:

```shell
jupyter lab examples/example_macros.ipynb
```

And then select the `Sardana Kernel` Notebook.

## Configuration

sardana-jupyter can be configured using a YAML file.
The file location must be set using the `SARDANA_JUPYTER_CONF` environment variable.
You can use the example configuration file as a template.

```shell
cp ./examples/sardana-jupyter.yml $HOME/sardana-jupyter.yml
export SARDANA_JUPYTER_CONF=$HOME/sardana-jupyter.yml
```

In the file you can set the following keys:

- `name` - name of your jupyter macroserver instance e.g. "test", "dummy", etc.
- `poolNames` - pool(s) you would like to connect to e.g. ["Pool_test_1"]
- `macroPath` - path(s) to your macros e.g. ["<install-dir>/sardana/macroserver/macros/examples"]
- `recorderPath` = path(s) to your recorders e.g. ["<install-dir>/sardana/macroserver/recorders/examples"]
