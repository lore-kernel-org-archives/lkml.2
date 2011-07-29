Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1G2HHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:07:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53047 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab1G2HHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:07:07 -0400
Date: Fri, 29 Jul 2011 17:06:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729170659.91ad989caa407854c5e269a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jul_2011_17_06_59_+1000_F1LlwRw.ET8pA3h="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jul_2011_17_06_59_+1000_F1LlwRw.ET8pA3h=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mmc/host/sdhci-of-esdhc.c:110:1: warning: data definition has no ty=
pe or storage class
drivers/mmc/host/sdhci-of-esdhc.c:110:1: warning: type defaults to 'int' in=
 declaration of 'MODULE_DEVICE_TABLE'
drivers/mmc/host/sdhci-of-esdhc.c:110:1: warning: parameter names (without =
types) in function declaration
drivers/mmc/host/sdhci-of-esdhc.c:115:12: error: 'THIS_MODULE' undeclared h=
ere (not in a function)
drivers/mmc/host/sdhci-of-esdhc.c:138:20: error: expected declaration speci=
fiers or '...' before string constant
drivers/mmc/host/sdhci-of-esdhc.c:138:1: warning: data definition has no ty=
pe or storage class
drivers/mmc/host/sdhci-of-esdhc.c:138:1: warning: type defaults to 'int' in=
 declaration of 'MODULE_DESCRIPTION'
drivers/mmc/host/sdhci-of-esdhc.c:138:20: warning: function declaration isn=
't a prototype
drivers/mmc/host/sdhci-of-esdhc.c:139:15: error: expected declaration speci=
fiers or '...' before string constant
drivers/mmc/host/sdhci-of-esdhc.c:139:1: warning: data definition has no ty=
pe or storage class
drivers/mmc/host/sdhci-of-esdhc.c:139:1: warning: type defaults to 'int' in=
 declaration of 'MODULE_AUTHOR'
drivers/mmc/host/sdhci-of-esdhc.c:139:15: warning: function declaration isn=
't a prototype
drivers/mmc/host/sdhci-of-esdhc.c:141:16: error: expected declaration speci=
fiers or '...' before string constant
drivers/mmc/host/sdhci-of-esdhc.c:141:1: warning: data definition has no ty=
pe or storage class
drivers/mmc/host/sdhci-of-esdhc.c:141:1: warning: type defaults to 'int' in=
 declaration of 'MODULE_LICENSE'
drivers/mmc/host/sdhci-of-esdhc.c:141:16: warning: function declaration isn=
't a prototype
drivers/mmc/host/sdhci-of-hlwd.c:82:1: warning: data definition has no type=
 or storage class
drivers/mmc/host/sdhci-of-hlwd.c:82:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_DEVICE_TABLE'
drivers/mmc/host/sdhci-of-hlwd.c:82:1: warning: parameter names (without ty=
pes) in function declaration
drivers/mmc/host/sdhci-of-hlwd.c:87:12: error: 'THIS_MODULE' undeclared her=
e (not in a function)
drivers/mmc/host/sdhci-of-hlwd.c:110:20: error: expected declaration specif=
iers or '...' before string constant
drivers/mmc/host/sdhci-of-hlwd.c:110:1: warning: data definition has no typ=
e or storage class
drivers/mmc/host/sdhci-of-hlwd.c:110:1: warning: type defaults to 'int' in =
declaration of 'MODULE_DESCRIPTION'
drivers/mmc/host/sdhci-of-hlwd.c:110:20: warning: function declaration isn'=
t a prototype
drivers/mmc/host/sdhci-of-hlwd.c:111:15: error: expected declaration specif=
iers or '...' before string constant
drivers/mmc/host/sdhci-of-hlwd.c:111:1: warning: data definition has no typ=
e or storage class
drivers/mmc/host/sdhci-of-hlwd.c:111:1: warning: type defaults to 'int' in =
declaration of 'MODULE_AUTHOR'
drivers/mmc/host/sdhci-of-hlwd.c:111:15: warning: function declaration isn'=
t a prototype
drivers/mmc/host/sdhci-of-hlwd.c:112:16: error: expected declaration specif=
iers or '...' before string constant
drivers/mmc/host/sdhci-of-hlwd.c:112:1: warning: data definition has no typ=
e or storage class
drivers/mmc/host/sdhci-of-hlwd.c:112:1: warning: type defaults to 'int' in =
declaration of 'MODULE_LICENSE'
drivers/mmc/host/sdhci-of-hlwd.c:112:16: warning: function declaration isn'=
t a prototype
drivers/power/max8997_charger.c:185:12: error: 'THIS_MODULE' undeclared her=
e (not in a function)
drivers/power/max8997_charger.c:204:20: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8997_charger.c:204:1: warning: data definition has no type=
 or storage class
drivers/power/max8997_charger.c:204:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_DESCRIPTION'
drivers/power/max8997_charger.c:204:20: warning: function declaration isn't=
 a prototype
drivers/power/max8997_charger.c:205:15: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8997_charger.c:205:1: warning: data definition has no type=
 or storage class
drivers/power/max8997_charger.c:205:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_AUTHOR'
drivers/power/max8997_charger.c:205:15: warning: function declaration isn't=
 a prototype
drivers/power/max8997_charger.c:206:16: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8997_charger.c:206:1: warning: data definition has no type=
 or storage class
drivers/power/max8997_charger.c:206:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_LICENSE'
drivers/power/max8997_charger.c:206:16: warning: function declaration isn't=
 a prototype
drivers/power/max8998_charger.c:196:12: error: 'THIS_MODULE' undeclared her=
e (not in a function)
drivers/power/max8998_charger.c:215:20: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:215:1: warning: data definition has no type=
 or storage class
drivers/power/max8998_charger.c:215:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_DESCRIPTION'
drivers/power/max8998_charger.c:215:20: warning: function declaration isn't=
 a prototype
drivers/power/max8998_charger.c:216:15: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:216:1: warning: data definition has no type=
 or storage class
drivers/power/max8998_charger.c:216:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_AUTHOR'
drivers/power/max8998_charger.c:216:15: warning: function declaration isn't=
 a prototype
drivers/power/max8998_charger.c:217:16: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:217:1: warning: data definition has no type=
 or storage class
drivers/power/max8998_charger.c:217:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_LICENSE'
drivers/power/max8998_charger.c:217:16: warning: function declaration isn't=
 a prototype
drivers/power/max8998_charger.c:218:14: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:218:1: warning: data definition has no type=
 or storage class
drivers/power/max8998_charger.c:218:1: warning: type defaults to 'int' in d=
eclaration of 'MODULE_ALIAS'
drivers/power/max8998_charger.c:218:14: warning: function declaration isn't=
 a prototype
drivers/regulator/aat2870-regulator.c:145:2: error: 'THIS_MODULE' undeclare=
d here (not in a function)
drivers/regulator/aat2870-regulator.c:212:3: error: initializer element is =
not constant
drivers/regulator/aat2870-regulator.c:212:3: error: (near initialization fo=
r 'aat2870_regulator_driver.driver.owner')
drivers/regulator/aat2870-regulator.c:230:20: error: expected declaration s=
pecifiers or '...' before string constant
drivers/regulator/aat2870-regulator.c:230:1: warning: data definition has n=
o type or storage class
drivers/regulator/aat2870-regulator.c:230:1: warning: type defaults to 'int=
' in declaration of 'MODULE_DESCRIPTION'
drivers/regulator/aat2870-regulator.c:230:20: warning: function declaration=
 isn't a prototype
drivers/regulator/aat2870-regulator.c:231:16: error: expected declaration s=
pecifiers or '...' before string constant
drivers/regulator/aat2870-regulator.c:231:1: warning: data definition has n=
o type or storage class
drivers/regulator/aat2870-regulator.c:231:1: warning: type defaults to 'int=
' in declaration of 'MODULE_LICENSE'
drivers/regulator/aat2870-regulator.c:231:16: warning: function declaration=
 isn't a prototype
drivers/regulator/aat2870-regulator.c:232:15: error: expected declaration s=
pecifiers or '...' before string constant
drivers/regulator/aat2870-regulator.c:232:1: warning: data definition has n=
o type or storage class
drivers/regulator/aat2870-regulator.c:232:1: warning: type defaults to 'int=
' in declaration of 'MODULE_AUTHOR'
drivers/regulator/aat2870-regulator.c:232:15: warning: function declaration=
 isn't a prototype

I have just left these in fixed for now.  Please let me know if some of
them can't be fixed in your tree and I will spin fixes for them in
linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jul_2011_17_06_59_+1000_F1LlwRw.ET8pA3h=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMlwTAAoJEDMEi1NhKgbsiD0H/0ziiMZvLCtJelokGioJ9hxb
wIoHhz6j+DdsGPfsSHkbhYlyGOMWiIYoO5Wp4+san7a2vS5PhQz/ATo6sjyhJ+gS
jS7mcT5L99jAY3+PehGeLJz1S7E5TI8hqRpPPlm41e+lOj1oPc9j6vXeWwrntIxm
otQiuymCMXsbPgIHpCxx+BLQPaIe4qbPM1gx6yyO/RAaYadvx3CcBhm+pcdS8bF6
2vL1OKy+AVurjwHAgyVnD0TKpMijduyMBJNSjkaHYz4RwAqc9sKjfo893gRUlogx
te35kqvDNDacbfvk6iHoQiYl+rfy8Ms8/ygpaM9aoMPZy4zTtkSIxcWLetXhnMU=
=ebyw
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jul_2011_17_06_59_+1000_F1LlwRw.ET8pA3h=--
