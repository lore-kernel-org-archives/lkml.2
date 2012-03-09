Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2CIHSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:18:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60170 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2CIHSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:18:02 -0500
Date: Fri, 9 Mar 2012 18:17:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkhlaWtvIFN0w7xibmVyIg==?= <heiko@sntech.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the regulator
 tree
Message-Id: <20120309181755.256b898808bd14726de0e977@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_18_17_55_+1100_9OB_I=WObLQD6rJ4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_18_17_55_+1100_9OB_I=WObLQD6rJ4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/regulator/Makefile between commit 8aa1ab9219e7 ("regulator: Sort
Kconfig and Makefile entries") from the regulator tree and commit
8a16a701ad78 ("regulator: Remove bq24022 regulator driver") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/regulator/Makefile
index 2b09c81,f53cf80..0000000
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@@ -10,17 -10,7 +10,16 @@@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER
  obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) +=3D userspace-consumer.o
 =20
  obj-$(CONFIG_REGULATOR_GPIO) +=3D gpio-regulator.o
 +obj-$(CONFIG_REGULATOR_88PM8607) +=3D 88pm8607.o
 +obj-$(CONFIG_REGULATOR_AAT2870) +=3D aat2870-regulator.o
 +obj-$(CONFIG_REGULATOR_AB3100) +=3D ab3100.o
 +obj-$(CONFIG_REGULATOR_AB8500)	+=3D ab8500.o
  obj-$(CONFIG_REGULATOR_AD5398) +=3D ad5398.o
- obj-$(CONFIG_REGULATOR_BQ24022) +=3D bq24022.o
 +obj-$(CONFIG_REGULATOR_DA903X)	+=3D da903x.o
 +obj-$(CONFIG_REGULATOR_DA9052)	+=3D da9052-regulator.o
 +obj-$(CONFIG_REGULATOR_DBX500_PRCMU) +=3D dbx500-prcmu.o
 +obj-$(CONFIG_REGULATOR_DB8500_PRCMU) +=3D db8500-prcmu.o
 +obj-$(CONFIG_REGULATOR_ISL6271A) +=3D isl6271a-regulator.o
  obj-$(CONFIG_REGULATOR_LP3971) +=3D lp3971.o
  obj-$(CONFIG_REGULATOR_LP3972) +=3D lp3972.o
  obj-$(CONFIG_REGULATOR_MAX1586) +=3D max1586.o

--Signature=_Fri__9_Mar_2012_18_17_55_+1100_9OB_I=WObLQD6rJ4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWa6jAAoJEECxmPOUX5FETOYP/2NwA1zwSCisshf/WCbfpXAT
yNEPVmqRk8qRF8P8fFk7WUKT+A3ItdSnqm4BMYdfFCSFBX9ETJL2jvXRkzDefZp0
USf00jFfaIPB4S6k3UYWWPKwm+u/A/B2qOs6OflyfxpB+dspseimmZgAwXv2DPmB
G8hk9NcprbhmX5VVq8xCWbTg1qN1qd5Ctu9wSGWw/qPKabIhsbXYMg0vr/PyDCzs
dtj9L6+wxlBjZKEmnNUdotrqeGNe19Dutv6h7xzmW9qnQvIJKpf7TBHsoFN/fT25
BmWEhtYwsQGtTkKmzglOv5m9TeKYMUtzi8AG6+ZKPmLzrfGVwduempXLUYr/ebqJ
4XzpLFKEjH5HtEbZtNLG5nDLgnuFYd0TFpbyucN10Zjs2hnFhoozo51pB0giV/Km
JCTkpMxJCQ6w+xP4Xhfu51kw2URHGkeL8BInqizXuD4ydi6sJFcYE+2msQppHSax
mXbJw1re9/hfB6kkMr2aD3p/z1QSCR38TT7hQZu0EPbkaH6jUgwjE5tGJlWo6f9R
OoaWzx+kPEWLpNyK5fcnVDHmsLofgalS2YA2p/EdQMTAnw5Z66Pxzkf6EdmiZ5tf
ujE/SEOoE/NHVcrFaFtGcYJ/TokViPlwqtvImayqXEcjW63lsOhhInEO+gL26Uvk
/KL/OzdMIjnsPXskxTzy
=NRbP
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_18_17_55_+1100_9OB_I=WObLQD6rJ4--
