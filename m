Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2KMESB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:18:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44218 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2KMER7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:17:59 -0500
Date: Tue, 13 Nov 2012 15:17:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20121113151754.98aa6471baaf062826c3b133@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_15_17_54_+1100_w/iT1K0R3_0ungCk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_15_17_54_+1100_w/iT1K0R3_0ungCk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/tty/serial/atmel_serial.c between commit 784557decc48 ("tty:
atmel_serial: add pinctrl support") from the pinctrl tree and commit
bcd2360c1ff9 ("arm: at91: move platfarm_data to
include/linux/platform_data/atmel.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/atmel_serial.c
index 65f891b,5660ec2..0000000
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@@ -39,7 -39,7 +39,8 @@@
  #include <linux/atmel_pdc.h>
  #include <linux/atmel_serial.h>
  #include <linux/uaccess.h>
 +#include <linux/pinctrl/consumer.h>
+ #include <linux/platform_data/atmel.h>
 =20
  #include <asm/io.h>
  #include <asm/ioctls.h>

--Signature=_Tue__13_Nov_2012_15_17_54_+1100_w/iT1K0R3_0ungCk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQocnyAAoJEECxmPOUX5FEC3IP/jvKz1beRn0mFG8purTPK/PL
j9raT9nXFNKZuhL6eLmGTpT43l0HcMUhSCEBTm84REgpTcO7Ngs8TDG64O3mPGlB
PA5Y4pQoboFazyLvbo66NYuxjK/CXDazNdXvMb5EOGFuMwgLt+zEjVUv/wLHJqEe
Q11vOaUG+iEVVwNFabEHm+GLOVraRav2RlHaVTdufSU0gjErT2w5D/8+XLJeWRA7
8J7UiMCMebmEJhCZTDbo7o4+Xbjtg3gOmz1DiumLnm8CBOah6UsKpkZeMifcAJne
FvetEdTFdNBZu0JQQRA7tV/nGXrMz0A7+UlD3vkqEahmfX6khQhAKY7otLNLba9K
HCdTqgWEPN0P+ByKnYz1v4V1R6dUsl59JpnmRdiV0cNS1WbOQsL4VKel6AeLpUO6
vb3GbyxHYgMte3sWR47sEs345gaSdMRuTGm6yDhHixBmWiQBDJ9jf2wcq85hbFSJ
gKT/fN3EU6Uq/p3OAcCfxoLSlwTLAw96+TB7zFLs5nyFXKoD67blsHyG1M9naYrY
uPL/nW266YXluE96NAFvewbkPmNmzEXyWL36vhLJlZuQCxjK9i93lQ0PqKkeH74/
pbpiisEMZqeAE4kPpi4jNLzSvJcSYGuY0W7RX08wNwHFRdCntwwirpe4r7fj9LxR
ozez2344ZLnP9/qumEjh
=d8VQ
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_15_17_54_+1100_w/iT1K0R3_0ungCk--
