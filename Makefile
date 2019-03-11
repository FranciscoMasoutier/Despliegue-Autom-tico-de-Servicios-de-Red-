ex1: example1
	mpirun --mca oob_tcp_if_include 10.11.13.0/24 --hostfile machinefile --map-by node -np 20 /shared/ex1
example1:
	mpicc mpiExample1.c -o /shared/ex1

