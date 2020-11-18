vim-ipythonsend
=====

**vim-ipythonsend** is a tiny plugin that allows you to send lines of python code to an ipython shell running in a terminal buffer.


Installation
------------

### Vundle

Add to your .vimrc

`Plugin 'varung/vim-ipythonsend'`

then open VIM, install

`:PluginInstall`


Usage
-----

Open a terminal buffer containing ipython:
:terminal ipython

Switch buffers. <C-w><C-w>

Select some python code
Type <Leader>ei 
(e.g., \ei) if your <Leader> is \

The code will be sent and executed in the ipython buffer using %cpaste
If you want to send the code as if you typed it, use <Leader>ex.


Configuration
-------------
By default it will use the terminal buffer with the highest buffer number. You can override the target terminal by
:let g:terminal_buffer=X
where X is the id of the buffer.

Type :buffers to see all the buffers and their ids.

This plugin uses :py3
Type :py3 print("hello world")
If you don't see hello world, this plugin will not work.

License
-------
BSD
