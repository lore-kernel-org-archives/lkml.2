Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2IXJ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:28:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59023 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2IXJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:28:48 -0400
Date: Mon, 24 Sep 2012 19:28:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20120924192844.51a4fa2f92ba220b1fec68d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_28_44_+1000_7zOAGsx=Ab1FI+cS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_28_44_+1000_7zOAGsx=Ab1FI+cS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/dma/mmp_tdma.c between commit f1a7757008b8 ("dmaengine: mmp_tdma:
add dt support") from the slave-dma tree and commit 293b2da1b611 ("ARM:
pxa: move platform_data definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/mmp_tdma.c
index b93d73c,07fa486..0000000
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@@ -19,8 -19,7 +19,8 @@@
  #include <linux/platform_device.h>
  #include <linux/device.h>
  #include <mach/regs-icu.h>
- #include <mach/sram.h>
 +#include <linux/of_device.h>
+ #include <linux/platform_data/dma-mmp_tdma.h>
 =20
  #include "dmaengine.h"
 =20

--Signature=_Mon__24_Sep_2012_19_28_44_+1000_7zOAGsx=Ab1FI+cS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCfMAAoJEECxmPOUX5FEjOcP/A0XlxVkJQavUgyhTzwVASwc
OORm4or9cJBefkSLH6NmmZocKhgY3/gP0jjDuBEtR8O08p0QOh/9U5RflWykfkzb
NVNiXxGi+gGS+9Rx1FOb+3vMIe1s3m6uCRqVnG0U8ObZ5t0hlwCefBtuLtpZHMag
V01FR+ZYXN4C3ywZTAOyULvwIVvA9pcMDOKmkzsPM7higQVZscZPfo2WMPd7Swys
j3Ao9+i0wml8VDnjNYiVVli5W07eO3mBgQCFYapPRa0EPQ74hqhKceWj1cohUKGa
d6VBe334OYUrviGgU7Jze8NZFl7HTFO0nBNgnSe4RebyfO78cCElvMW/iePa8XCK
G38kY2Og+9U8Fn7+5E5EXU/mcQSvHFn0jdPOEud679Bwno7N5rCIWzk+BB2BcVjQ
7j4aDcPDOeKm935V91huaPKXb5sY0IJ6JlTxze6dXAJLmqTxdVxDOEhcZ8FAx98B
ySBq4PnfzXHVphBGvo8JKDcAFlc3S7BCHHmSbk+i8xBiEiH55RzusPUqdbHP4G00
U4GskJ1KlNNm1DrK0knX74sPBESzxgewtHW8MTJGeJOLGtFujF2r+SLBZGhEqHsB
rp0a1f3L5khG0Bu2IZVKSngwYY864Y42ZW38bzmKUmsX79sJpCHGFy86oqfC+fSW
WDqssGvJQaDVpLtajFi8
=/ELv
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_28_44_+1000_7zOAGsx=Ab1FI+cS--
