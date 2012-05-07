Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2EGDp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:45:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58567 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2EGDp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:45:27 -0400
Date: Mon, 7 May 2012 13:45:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120507134513.bffe9dbda0fac21e472215b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_13_45_13_+1000_wy93F7ilMicfe33N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_13_45_13_+1000_wy93F7ilMicfe33N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit 074b5e1a99fb
("drm/i915: Do not read non-existent DPLL registers on PCH hardware")
from Linus' tree and I have no idea which commits from the drm tree.

I fixed it up (I think), but, again, the merge diff is way to log to
post ...

Again, Dave, can you cherry-pick or merge the commits that affect the drm
tree from Linus' tree, please?  Surely those fixes are needed in the drm
tree as well - or if they are not, then let me know and I will just use
the drm tree's version of this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_13_45_13_+1000_wy93F7ilMicfe33N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp0VJAAoJEECxmPOUX5FE0LcP/R5m5cDq6gTP2b97x8c01XwU
2TBjw9lp+9FhELVQayYdX0Hxj5y0yKMht8cQSVRNm9+tsV6qrC+RSW2e8sZGZZG+
wTc1Fp9K/DTOGQY0EafN+5BOj2ipfUpZB0swe1a9iqb+G3QX8ZgBS6myN7jkiDPb
2c/fPHcQrH1TPgvKosP19nlEMVG0ahB7MGUsBFXNMyb+x0+DCkPq1adRe+BZVn53
SjhuvZ6jlQKaRK2mew+iFS6aMnjdOFxI/bERIrRvJ2a/cIAoPE64EuxeHbZhXV/u
3sC9nvU3SixkDBL8Jxi5va4gAErfbV8nHadIDKPpLsrIiaAb3Y2ZaKnQIMDmEf1p
6ZfGSGhnCjXZXCUkVcFU0jKKxbCgtsJP+IGSR/+4Z1QW3Yhcmf2nj3iHYZki4SZr
EmEDk8xTVgaxkLSIs/ierH4Fc+iQe7zVgyufBQk+xjtg2GV7fElRzk1P2dfeF1uD
QX6MY75Q1dr9V0y/wP+bbKBD4DeNXmNUHnTTXbuV4lhExAv3UzW0ZTE2jloLfw5R
r0FsGySTClOxJy6A13udssVLC3Di4b28scbdENlZ9Htwp2nqKa6GNz7CM4mIGled
h80OnN26r+4VKONBplXd/58GLZlDCjk3b/IhJnvPZnncBTxGOf5vl605jZUSs4Nv
6G5B7D3UCEmbqLITery/
=cLZo
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_13_45_13_+1000_wy93F7ilMicfe33N--
