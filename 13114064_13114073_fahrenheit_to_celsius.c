#include <stdio.h>

int main() {
	float fahren;
	printf("Please enter the temperature in fahrenheit\n");
	scanf("%f", &fahren);
	float cel=(fahren-32);
	cel*=5.0;
	cel/=9.0;
	printf("Converted temp in celsius is : %f",cel );
	return 0;
}

