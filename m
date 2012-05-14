Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2ENIry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:47:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45705 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ENIrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:47:53 -0400
Date: Mon, 14 May 2012 18:47:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20120514184746.3eef413d8e27a6b874e5cd1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_47_46_+1000_PKWcr.Fw/XEtXk3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_47_46_+1000_PKWcr.Fw/XEtXk3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mtd/nand/gpmi-nand/gpmi-nand.c between commit 2890c63138a4 ("mtd:
gpmi: add device tree support to gpmi-nand") from the l2-mtd tree and
commit 39febc018bd2 ("mtd: nand: gpmi: adopt pinctrl support") from the
arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 95f2af8,8478fd9..0000000
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@@ -24,8 -24,7 +24,9 @@@
  #include <linux/module.h>
  #include <linux/mtd/gpmi-nand.h>
  #include <linux/mtd/partitions.h>
 +#include <linux/of.h>
 +#include <linux/of_device.h>
+ #include <linux/pinctrl/consumer.h>
  #include "gpmi-nand.h"
 =20
  /* add our owner bbt descriptor */

--Signature=_Mon__14_May_2012_18_47_46_+1000_PKWcr.Fw/XEtXk3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMayAAoJEECxmPOUX5FEVeIP/RBte0MZl9nuDrOB2puaEgoY
sWBAH98nyEyET4AfIAxUkDIXwIGjucf0mHd+WrTrGofGmTNAibhab2h9UB7U2Hks
II0qWsPdB+bNkrmBrhT0IrV/6h4ML/qP/v4aJdCLMhuO7VGgtUhmRU/w7rkgYtMt
reFBFSaD4DPb/KCY8OyOaygJ590f+htWYYyRXgiuakJq/uDBBdVFvzWdqVGtSPyO
mJHLB8pq9JuzzTfCXagSmKNSF2J4XcQLZoVg5Hu7uS8cXTgta0JB8nyDRsgs0ZuV
t1iMLWvlMf9teU+7wC4ohpLHc4PFny6VtaVRnn8Ha7lflVChMsFbqkuHGLwlfpLy
hU9agW/wuRCIUL8wr8LpgwETeUZuBJkyw9PlJnARw5dqEMBYDpeDB+GyM3UjBYWl
h4rFUDjJAvGLIujFhvAF36Llc3Ag0t6nE6xX69ji6S/27c7qA18RTixXR5rNQ8ab
UcShGzd54LCrhLXd0QQ5ppiCaUoM3RLZBzzN65c42vsdow+UoGaQoqiQLNd/syAj
Y/WrSN3dn/iIrDgxcBAqRwivZE0U6ws5ByoWDXppWN0aQ3/rxix+CjXACVycB+e/
wthUricqxbgfwX4aEE0QgQ+e8Vw08raTmF2p6E3nVjeOXytEwKLNbcRTQfa4i7ij
Z/8a/5GR0xjPBIKbfZUh
=3Vdn
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_47_46_+1000_PKWcr.Fw/XEtXk3.--
