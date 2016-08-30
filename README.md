Just to keep safe my bash scripts

# install

    git clone https://github.com/sinse/dotbash ~/.bash.d

and add this line at the end of ~/.bashrc

    source ~/.bash.d/load.sh

# help

add your scripts to ~/.bash.d/scripts-available
and use:
    
    bash-enable scriptname
    bash-disable scriptname

to enable or disable them


