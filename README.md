# 8085memTest64K
For testing 64K of memory.
When running at 4mhz, it will output a 'P' or 'F' for every pass or fail out of the 8085's built in serial port at 1200baud. It will also count up starting at '0' on 
port 240 the number of passes and resets to '0' if there is a failure. The program needs to be loaded at address 0x0000 and there needs to be 64K of ram.
