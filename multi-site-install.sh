#!/bin/bash

echo "


			Welcome to the

PPPPPPPPPPPPPPPPP                                         ZZZZZZZZZZZZZZZZZZZ                                                       
P::::::::::::::::P                                        Z:::::::::::::::::Z                                                       
P::::::PPPPPP:::::P                                       Z:::::::::::::::::Z                                                       
PP:::::P     P:::::P                                      Z:::ZZZZZZZZ:::::Z                                                        
  P::::P     P:::::Paaaaaaaaaaaaayyyyyyy           yyyyyyyZZZZZ     Z:::::Z    aaaaaaaaaaaaa  nnnn  nnnnnnnn       ggggggggg   ggggg
  P::::P     P:::::Pa::::::::::::ay:::::y         y:::::y         Z:::::Z      a::::::::::::a n:::nn::::::::nn    g:::::::::ggg::::g
  P::::PPPPPP:::::P aaaaaaaaa:::::ay:::::y       y:::::y         Z:::::Z       aaaaaaaaa:::::an::::::::::::::nn  g:::::::::::::::::g
  P:::::::::::::PP           a::::a y:::::y     y:::::y         Z:::::Z                 a::::ann:::::::::::::::ng::::::ggggg::::::gg
  P::::PPPPPPPPP      aaaaaaa:::::a  y:::::y   y:::::y         Z:::::Z           aaaaaaa:::::a  n:::::nnnn:::::ng:::::g     g:::::g 
  P::::P            aa::::::::::::a   y:::::y y:::::y         Z:::::Z          aa::::::::::::a  n::::n    n::::ng:::::g     g:::::g 
  P::::P           a::::aaaa::::::a    y:::::y:::::y         Z:::::Z          a::::aaaa::::::a  n::::n    n::::ng:::::g     g:::::g 
  P::::P          a::::a    a:::::a     y:::::::::y       ZZZ:::::Z     ZZZZZa::::a    a:::::a  n::::n    n::::ng::::::g    g:::::g 
PP::::::PP        a::::a    a:::::a      y:::::::y        Z::::::ZZZZZZZZ:::Za::::a    a:::::a  n::::n    n::::ng:::::::ggggg:::::g 
P::::::::P        a:::::aaaa::::::a       y:::::y         Z:::::::::::::::::Za:::::aaaa::::::a  n::::n    n::::n g::::::::::::::::g 
P::::::::P         a::::::::::aa:::a     y:::::y          Z:::::::::::::::::Z a::::::::::aa:::a n::::n    n::::n  gg::::::::::::::g 
PPPPPPPPPP          aaaaaaaaaa  aaaa    y:::::y           ZZZZZZZZZZZZZZZZZZZ  aaaaaaaaaa  aaaa nnnnnn    nnnnnn    gggggggg::::::g 
                                       y:::::y                                                                              g:::::g 
                                      y:::::y                                                                   gggggg      g:::::g 
                                     y:::::y                                                                    g:::::gg   gg:::::g 
                                    y:::::y                                                                      g::::::ggg:::::::g 
                                   yyyyyyy                                                                        gg:::::::::::::g  
                                                                                                                    ggg::::::ggg    
                                                                                                                       gggggg    
			Installer for CiviCRM on Drupal
                        For new account setup or reporting issues please call: 1-800-838-8651


"


echo -n "Checking root status..."
if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
  echo "failed!

Error: You must be root to run this script.

"
  exit 1
fi
echo "Success!";

echo -n "
Please, enter the path to your 'new' SiteRoot (i.e. /var/www/yoursite/sites/site2.example.com): "
read SITEROOT
lastchr=${SITEROOT#${SITEROOT%?}}
if [ "$lastchr" == "/" ]; then
	SITEROOT=${SITEROOT%?} 	
fi
if [ ! -d "$SITEROOT" ]; then
  "
Error: The directory does not exist.

"
  exit 1
fi
echo "SiteRoot is: $SITEROOT
"
echo -n "Please, enter the user name for the apache process: "
read USERNAME
echo -n "
Please, enter the group name for the apache process: "
read GROUPNAME

CUSTOMPATH=$SITEROOT/sites/default/files/civicrm
echo "Copying directories php, and templates to $CUSTOMPATH/custom"
cp -r ./custom $CUSTOMPATH 
chown -R $USERNAME:$GROUPNAME $CUSTOMPATH/custom/
echo "Copying custom extension com.payzang.payment.pzpayments to $CUSTOMPATH/custom_ext"
cp -r ./custom_ext $CUSTOMPATH
chown -R $USERNAME:$GROUPNAME $CUSTOMPATH/custom_ext/
