Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2CHEoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:44:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40985 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2CHEnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:43:42 -0500
Date: Thu, 8 Mar 2012 15:37:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] tty: powerpc: remove hvc_iseries
Message-Id: <20120308153740.10af6806d245c1240a1a633a@canb.auug.org.au>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_37_40_+1100_oph5+/tFUGr8c9mp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_15_37_40_+1100_oph5+/tFUGr8c9mp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The PowerPC legacy iSeries platform is being removed, so this code is no
longer needed.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/tty/hvc/Kconfig       |   10 -
 drivers/tty/hvc/Makefile      |    1 -
 drivers/tty/hvc/hvc_iseries.c |  599 -------------------------------------=
----
 3 files changed, 0 insertions(+), 610 deletions(-)
 delete mode 100644 drivers/tty/hvc/hvc_iseries.c

diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 4222035..8ea7f07 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -24,16 +24,6 @@ config HVC_OLD_HVSI
 	depends on HVC_CONSOLE
 	default n
=20
-config HVC_ISERIES
-	bool "iSeries Hypervisor Virtual Console support"
-	depends on PPC_ISERIES
-	default y
-	select HVC_DRIVER
-	select HVC_IRQ
-	select VIOPATH
-	help
-	  iSeries machines support a hypervisor virtual console.
-
 config HVC_OPAL
 	bool "OPAL Console support"
 	depends on PPC_POWERNV
diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
index 89abf40b..4ca3723 100644
--- a/drivers/tty/hvc/Makefile
+++ b/drivers/tty/hvc/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_HVC_CONSOLE)	+=3D hvc_vio.o hvsi_lib.o
 obj-$(CONFIG_HVC_OPAL)		+=3D hvc_opal.o hvsi_lib.o
 obj-$(CONFIG_HVC_OLD_HVSI)	+=3D hvsi.o
-obj-$(CONFIG_HVC_ISERIES)	+=3D hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+=3D hvc_rtas.o
 obj-$(CONFIG_HVC_TILE)		+=3D hvc_tile.o
 obj-$(CONFIG_HVC_DCC)		+=3D hvc_dcc.o
diff --git a/drivers/tty/hvc/hvc_iseries.c b/drivers/tty/hvc/hvc_iseries.c
deleted file mode 100644
index 3f4a897..0000000
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_37_40_+1100_oph5+/tFUGr8c9mp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDeUAAoJEECxmPOUX5FE+AIP/ig1svU5sv6uQsi8FvEj9+sa
pO4URJ9M/PAr1GSxmHGGwmSrmbACOYhsoTWYEdMY/4sb/gXwlNTPSV3n7nQ1Hees
zrHCQIsMRy2dJvYdlxsWUbOzgOZnW7rI9D3HakVTVCg3tO+sDyhoINZHb7lR+3Zd
uYV8SlbDbpEUppHE+PluBZRKEJC3/NNdYOZRgVKdhQeJ7GQIy5f6qnIhBczS//nZ
xDUm/048UcTJydrcgQhdAN0Dz+ifYi2UdNUxBMjIDdHdZWhZ8cFb79XI3kakbsDK
/9Oq36pzIm6D/JL9MnlXLtF3jjac/2rGZCBM2YZIRwDuDiWtexhIxQp5CdZBD10p
/uPmWo5RpjMScOx+iV6bPEMfcdAGwbElWZyQj6rrM+VfMO8coO0skUwjzFhMn3V1
QJVxMTJGK1XDLs0pz7ULSDuvm7KNGQ6r0e+93Kf8lfwJkupIOkeUoyWyV2Jau1X2
qEmlijQ7c3OQuzw+k1r7ZkKmy0m9QIcd923cHGTip2twZIgSoiCCbzEmgo36zkQX
sCAe2LvDyhdStkaqbrXbzM134ffqsA+/Ws5veGdQd4PlfB48y5QvgvNvCIe30Z7T
SOCkpX3q/XZgHKAlIczldjWn7jZO5uj6c6faa5husm5kxQxf7l8TPb+Gc0ZiBfsd
Jw9MIDn96U7JPYIYsaEm
=dg+2
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_37_40_+1100_oph5+/tFUGr8c9mp--
