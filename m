Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2F2GuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:50:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36847 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2F2GuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:50:01 -0400
Date: Fri, 29 Jun 2012 16:49:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?B?IkVyaWMgQsOpbmFyZCI=?= <eric@eukrea.com>
Subject: linux-next: manual merge of the pwm tree with the s5p tree
Message-Id: <20120629164946.97497f3eb94a5d4fbcc6b448@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_16_49_46_+1000_HZMw9tUeHVd/Q8ui"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_16_49_46_+1000_HZMw9tUeHVd/Q8ui
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
arch/arm/plat-samsung/Makefile between commit 65ab16fd385f ("ARM: EXYNOS:
Remove leftovers of the Samsung specific power domain control") from the
s5p tree and commit 2663e766c56a ("ARM Samsung: Move s3c pwm driver to
pwm framework") from the pwm tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-samsung/Makefile
index 4bb58c2,9685472..0000000
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@@ -59,7 -59,7 +59,3 @@@ obj-$(CONFIG_SAMSUNG_WAKEMASK)	+=3D wakeu
 =20
  obj-$(CONFIG_S5P_PM)		+=3D s5p-pm.o s5p-irq-pm.o
  obj-$(CONFIG_S5P_SLEEP)		+=3D s5p-sleep.o
--
- # PWM support
-=20
- obj-$(CONFIG_HAVE_PWM)		+=3D pwm.o
 -# PD support
 -
 -obj-$(CONFIG_SAMSUNG_PD)	+=3D pd.o

--Signature=_Fri__29_Jun_2012_16_49_46_+1000_HZMw9tUeHVd/Q8ui
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7VAKAAoJEECxmPOUX5FE37kP+wWnu7b8nezreWamBgkxAXlS
IqqWCBYNZaXHICpLZK4SdB+oSRGq4nLC3K9f72nRQbwOspIqob4p6EgPZxUQFJHP
aAAqXN0RUf9OxJx5h2KUlZDSALrLZ4WPTjLIWuMdJAAekcYjCfPeq6mG7xmS3WEw
0nVadLUiTwEr+AUC+5530CWlTThRpnXlWxYu6YxFv+HH/FRn9acZSHpemFnXMeMS
UYwcjsBAvvf3+cj/q4eEVzBnO7XjOcvBcdHXo9w/ku7458ScOOD0fEuNJR2LcUzn
bw8FSWOqApwnVy5G6bTlscH31zFioc4wcIwpfGTrvaBbcWQqBOEeKqty2f0Nw31C
mwrmX69Qo2O3gmaMFX8zxTfTx+E7rO7aEVAo1cIEHvWJaeqRhMkoo/AJas9TdFkZ
Z/tOrhNNa7ilGHiOH6WPyOes8h+kqpB7nWchLh4bh1O23zvAPtTJLU71dYkFT8q+
doxyW5wkgUwW1J5YgoSc0LQKI/8o971B3iX3iZAoPfYXYioHbiXOC2cZ17QTYKKo
brVS8XoWL8J0Jgkx8qtP4e17mKLRQDC4NmKIhyjvaFRgwc+tpTmIHQqpFTxu7QsK
yNlrJuk+AUXlfmOJugquCtQKOE85TrvPa8dlYps9pRDEOcAGjQ8Gi/BIeXHMSyWm
6KYSg5u3sNz3kMO6RmV8
=58CU
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_16_49_46_+1000_HZMw9tUeHVd/Q8ui--
