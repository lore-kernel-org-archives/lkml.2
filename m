Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1JLF2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:28:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51487 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JLF2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:28:11 -0400
Date: Wed, 12 Oct 2011 16:28:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: linux-next: manual merge of the staging tree with the pm tree
Message-Id: <20111012162805.1056a7f7fe3f1140d767a601@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_16_28_05_+1100__5PUE.sc8q_Lnz5_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_16_28_05_+1100__5PUE.sc8q_Lnz5_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/Kconfig between commit a3c98b8b2ede ("PM: Introduce devfreq:
generic DVFS framework with device-specific OPPs") from the pm tree and
commit 46a971913611 ("Staging: hv: move hyperv code out of staging
directory") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Kconfig
index a1efd75,ce3c35f..0000000
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@@ -130,6 -130,6 +130,8 @@@ source "drivers/iommu/Kconfig
 =20
  source "drivers/virt/Kconfig"
 =20
+ source "drivers/hv/Kconfig"
+=20
 +source "drivers/devfreq/Kconfig"
 +
  endmenu

--Signature=_Wed__12_Oct_2011_16_28_05_+1100__5PUE.sc8q_Lnz5_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlSVlAAoJEECxmPOUX5FE/1wP/3N6WHLn9HIwzoRPPOqTgz57
mlGWR9KdRbWkbwXI9/9uGhajXdXoj2ECzftBZUif4T+y+sud0wMNjoCCNu+LYRXI
kAPtfmKG0NqEAr9L8HuWr4xTRRr/GnvWl+GqTu5e9ThBZN46QM3778WsrWi8N0aM
QZgDBzMqX8p3p87U1AxnOtnLo139mNQS6u4nnQtyh2Ed4hIiLokp3OqaZKC+iyvI
wAsf5lwQXgvzx/zSF4As9JBBpKB2Ncw6K8vtayQ5+MitDzEtD98PJn3KDdIK3xVX
nslFwi4cjz7HE81FC2J5N1swKiACmGYvq6yqvFixVIqnvF74AoDF5GAafWTr039C
8mD0f9N4vERIHkTKmNodlj7yn02xkxdgsdD0aXaOqdV5CVlyaKto4kCgo34eGnDr
XRbjM/iWvzCtDSTkjUOtcNdaoMMj+8QA2SH3+QJM1WxAquFV84a1Kq3f7/PX10pM
JSkilhwQgOqKc1mDbbrUuAPHxsJVX7pL/L5ERHLqD6w9XwENpWoKQY4HjEAY3osk
X172TPKg3nCOd95JAhSERReksVsrRyp5UJZxG0RPA1Xf8Gr5s71o6I6JAhPnhjAS
o1qiSbyVzIFEjXnYGsiu2XZqMcZcCHk5IHu46GZDqRw/CsC6lraM5EIH4UYjlbQO
tzlZG0oTiBDFWxQ0LZjy
=9lgE
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_16_28_05_+1100__5PUE.sc8q_Lnz5_--
