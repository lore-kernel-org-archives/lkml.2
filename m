Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1JKFle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:41:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52313 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JKFlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:41:31 -0400
Date: Tue, 11 Oct 2011 16:41:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlBoaWxpcHBlIFLDqXRvcm5heiI=?= 
	<philippe.retornaz@epfl.ch>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the mfd tree with the arm-soc tree
Message-Id: <20111011164122.709419a813e96d88a0bc070c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_16_41_22_+1100_0Lhwf/uU/+LSt.sm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_16_41_22_+1100_0Lhwf/uU/+LSt.sm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-imx/mach-mx31moboard.c between commit 40d97b89bd3c
("mx31moboard: Add poweroff support") from the arm-soc tree and commit
1ab50c862862 ("ARM: imx/mx31moboard: Add mc13783 power button support")
from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-mx31moboard.c
index fff7791,f7e302d..0000000
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@@ -28,9 -28,7 +28,10 @@@
  #include <linux/spi/spi.h>
  #include <linux/types.h>
  #include <linux/memblock.h>
 +#include <linux/clk.h>
 +#include <linux/io.h>
 +#include <linux/err.h>
+ #include <linux/input.h>
 =20
  #include <linux/usb/otg.h>
  #include <linux/usb/ulpi.h>

--Signature=_Tue__11_Oct_2011_16_41_22_+1100_0Lhwf/uU/+LSt.sm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk9cCAAoJEECxmPOUX5FEAaMP/Ru/MTpuhL2WcMMdUwKN7erx
MR1/4xg0r10A7H6J+IXU8DlhWLofkRvfwb5i459ktN0kXFhgnRi0vYxAwdV7bCVp
cXbL2aY7UCSpUYjHkhnSpH940AwFakH/3+lZxfO6224l9iNcaNehgQMfwq73kTXL
xn+R0AUNLFNaTSJxQ9Uf1LDNOc/9EzeU3GsB9hVu5JeeWBOtaCAKj7zb0dCzg/Tn
ad8eMFsxDmlK7Bnj+E8o1MjKdN2F8HnKTHq19wzFudlWaYLJ5wP0r4LRkvAbdr+m
/wJAzYiHtP7hHadVlVxERZifc1pOIyhuArumoe5c09rA3sZngod4W5dcQMFeDkol
wbg02UMBYrZXkNg/8wfMZU2zxPvXfUy+wpT+oNs2r6ouhpnODChKyMT+FQKBZGtV
Gy/5G89rrXxFfLsoYMXorlVoEghuyb95GPYyjYC0Egw2Zu8gTmqxGmuXFquz26NH
tLAYs51Z/HQj3et0rRfNOegNGu+QEtLLOstB23o/YoXVrWJaw3fuGkD5TcD1sVVn
zhr5JgKFcpOjiOY/xjzUatMi/9LWHin7QpZaOBLVZiFmo5+9g5Lmrqsy/dbJNIa/
imo67IgT4BJqaF1kFFLHLOztZ0wha5fStlRWfSC7ZdtDnjS+GZpw2zAedQGxa1Y1
5hutZF82oLRkkV4HDh/E
=jrBZ
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_16_41_22_+1100_0Lhwf/uU/+LSt.sm--
