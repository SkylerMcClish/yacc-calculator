%{
#define	YYSTYPE	double 	/* data type of yacc stack */
%}
%token	NUMBER
%left	'+' '-'	  /* left associative, same precedence */
%left	'*' '/'   /* left assoc., higher precedence */
%left   '%'      /* left assoc., even higher precedence */
%right	'^'  /* right associative, higher precedence */
%%
list:	  /* nothing */
	| list '\n'
	| list expr '\n'    { printf("\t%.8g\n", $2); }
	;
expr:	  NUMBER	{ $$ = $1; }
	| '+' expr	{ $$ = $2; }  /* unary plus */
	| '-' expr	{ $$ = -$2; }  /* unary minus */
	| expr '+' expr	{ $$ = $1 + $3; }
	| expr '-' expr	{ $$ = $1 - $3; }
	| expr '*' expr	{ $$ = $1 * $3; }
	| expr '/' expr	{ $$ = $1 / $3; }
	| expr '%' expr	{ $$ = fmod($1, $3); }
	| expr '^' expr	{ $$ = pow($1, $3); }  /* exponentiation */

	;
%%
	/* end of grammar */

#include <stdio.h>
#include <ctype.h>
#include <math.h>  /* for fmod() function */
char	*progname;	/* for error messages */
int	lineno = 1;

main(argc, argv)	/* hoc1 */
	char *argv[];
{
	progname = argv[0];
	yyparse();
}

yylex()		/* hoc1 */
{
	int c;

	while ((c=getchar()) == ' ' || c == '\t');

	if (c == EOF)
		return 0;

	if (c == '.' || isdigit(c)) {	/* number */
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUMBER;
	}

	if (c == '\n')
		lineno++;

	return c;
}

yyerror(s)	/* called for yacc syntax error */
	char *s;
{
	fprintf(s, "%d");
	warning(s, (char *) 0);
}

warning(s, t)	/* print warning message */
	char *s, *t;
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}
