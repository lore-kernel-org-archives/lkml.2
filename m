Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2CHEnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:43:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40801 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2CHEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:43:39 -0500
Date: Thu, 8 Mar 2012 15:32:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] powerpc: Remove some of the legacy iSeries specifi
 device drivers
Message-Id: <20120308153252.561addac16eacd76fe48e17e@canb.auug.org.au>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_32_52_+1100_IHBr5=wHRxZ5T=d5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_15_32_52_+1100_IHBr5=wHRxZ5T=d5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

These drivers are specific to the PowerPC legacy iSeries platform and
their Kconfig is specified in arch/powerpc.  Legacy iSeries is being
removed, so these drivers can no longer be selected.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/viodasd.c |  809 ------------------------------------
 drivers/cdrom/viocd.c   |  739 ---------------------------------
 drivers/char/viotape.c  | 1041 -------------------------------------------=
----
 3 files changed, 0 insertions(+), 2589 deletions(-)
 delete mode 100644 drivers/block/viodasd.c
 delete mode 100644 drivers/cdrom/viocd.c
 delete mode 100644 drivers/char/viotape.c

diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
deleted file mode 100644
index 9a5b2a2..0000000
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
deleted file mode 100644
index 7878da8..0000000
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
deleted file mode 100644
index ad6e64a..0000000
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_32_52_+1100_IHBr5=wHRxZ5T=d5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDZ0AAoJEECxmPOUX5FEVccP/jslAEoD1PUqztuzcZCMq+P+
CX2G4Nl3Iu44SEjlNwx/ZrbNNRku0Sb+Gt7fMOZXQgbAMi4bMkbHuThNJKZRINC0
EwDOFp/TKlEdtKd2pBZ/GcFXdNE7/yu7suDSDHJa64JgZylPNiJZfQdcPIzRUUUH
mFR/35qV+5gZgksG7iAGyY3t2zIqRInmxzlkdHve15/1LgqDyZMPGyLLaAp1oK1M
XUwmGfTqnUPoi6ezrkJTYyYS4ju7zfjfvUyqKtWbTgAgxbaHUr/2ift5bRg3Z17+
IquQ6Otumy5YMSl1+wBgSPQzF00wkiVK19k3Y0tCz8O5CXP3y8eZbdhIEegSwUHW
WoKOMgfwfzLxppmHVPci6XAlxlnMUhRgPkqG1qjx42adg+v1GRQCdm2mDXtv7oeL
OcwqBRvZZ/UH5srbZhXgLhoGm1USGlZiP+G4wwS7XbGiNDlO2rj7jsWWlHpUFmDr
ft2poEf2hEOopeQB0wopTjRy7rwX2uhnsv3ZH3Czs0jNanYgl8XLjfgbZKr+6GSS
Tl9WgErZpcuGDg1Ol1tMZAMw+imbpN9WL3nA8cRRFcUCTlZmmWDBjRJyFh/XpFuq
8f22cm5sUr3cq/GrvifhSLl0LX/csOI/cMxcK5jI0/UyFCykRNkOIcMxmAMCMWQu
NhXmfdO7VnoHD3uUWMx7
=PqC1
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_32_52_+1100_IHBr5=wHRxZ5T=d5--
