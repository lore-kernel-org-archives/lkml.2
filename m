Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2IQJXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:23:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60570 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2IQJXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:23:47 -0400
Date: Mon, 17 Sep 2012 19:23:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120917192345.10d3b625a5c104183855658f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_19_23_45_+1000_qJVrCRqe/IKQrCRQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_19_23_45_+1000_qJVrCRqe/IKQrCRQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in drivers/vide=
o/omap2/dss/dispc.c between commit fe6a466283cf ("OMAPDSS: remove unnecessa=
ry includes") from the omap_dss2 tree and commit 7d7e1eba7e92 ("ARM: OMAP2+=
: Prepare for irqs.h removal") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/dss/dispc.c
index d512c38,ee9e296..0000000
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@@ -37,6 -37,9 +37,8 @@@
  #include <linux/platform_device.h>
  #include <linux/pm_runtime.h>
 =20
+ #include <plat/cpu.h>
 -#include <plat/clock.h>
+=20
  #include <video/omapdss.h>
 =20
  #include "dss.h"

--Signature=_Mon__17_Sep_2012_19_23_45_+1000_qJVrCRqe/IKQrCRQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVuwhAAoJEECxmPOUX5FEZBkP/16dRvdaYjwDuU/evwnTFLQI
1MPBM94vaunO9DzmqeAcIt8GSkgrXeifuLCSs19kNA5LamhYOxM10f0xC/cKQdW4
DCqT88UGs6cyLhQQBLNcMKkNoRmQrxPxnXKiRgitvLxhWe0WEz7jFFMZ4j1O7Hjk
nuwlHxfQ0kUO6Dn8fDudqym5n36CK/OwkhsvdXyafHHxfqOFxJHwQzA73di4yAXF
rUrl6pG0iR/WcWnFB4QUSXFpRIZqsUc9kDWhq+RaH0gdBzlXGENz29Jy12jS8D4i
/cq9jjypSdCwhysQh8t202stIdREzJ7OdRXhpMeIuoYJRl/cFhHlB89dZ2PlO8xm
PHt8RFKnzjUWtbDo+/ZbiG9D3NMyBokyiIT+qyS3jIZgThIFwelSQZiqp5cn5IuS
C/tRFT2xLeqm3FWXxQeg+5J+ffecFUCbFibd7KoUgxIgIS2XSCk1Bt39q+KNBCQs
99SXU2H2+Qe6WvIyulmslPUZkJXR1aHtxYUv20csQt11lgP2lmxuievZWyTSau5X
Y60h4/FIUhp9zh7+1bBOJR9qo3ybwXDoaYi/3C1FeSNjYiB63b7Fzq6fNoQdIrAX
J2FbUe0Y+qndJ3B76NQYnDX2WiPljdhY35DjSyDLOmERjgtfDDDKlVMJv29zzIiu
qRgdMMnlvBSpXVkCK3Wd
=YzAa
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_19_23_45_+1000_qJVrCRqe/IKQrCRQ--
