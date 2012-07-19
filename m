Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2GSExN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:53:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54682 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab2GSExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:53:09 -0400
Date: Thu, 19 Jul 2012 14:53:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: linux-next: manual merge of the staging tree with the target-merge
 tree
Message-Id: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jul_2012_14_53_01_+1000_l.Lq/clWLO.lwVcv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jul_2012_14_53_01_+1000_l.Lq/clWLO.lwVcv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/Kconfig between commit d0146d396bfa ("tcm_vhost: Initial
merge for vhost level target fabric driver") from the target-merge tree
and commit 15a4bc17b7f4 ("Staging: add CSR Wifi "os helper" module") from
the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/Kconfig
index 67ec9fe,e3402d5..0000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -132,6 -132,8 +132,10 @@@ source "drivers/staging/ipack/Kconfig
 =20
  source "drivers/staging/gdm72xx/Kconfig"
 =20
+ source "drivers/staging/csr/Kconfig"
+=20
+ source "drivers/staging/omap-thermal/Kconfig"
+=20
 +source "drivers/vhost/Kconfig.tcm"
 +
  endif # STAGING

--Signature=_Thu__19_Jul_2012_14_53_01_+1000_l.Lq/clWLO.lwVcv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQB5KtAAoJEECxmPOUX5FEXi0P/1zHn13N/HQSRLIQvAdNrGDz
gkkajRttwpHwa5PRbiVPWeuZzwlIYZGLKAoVTzrZsWnJVWJ3zdGWtcs6DMJfFAo3
6K3cMm3xOjHnyho+dZVEsQAZAO2hSnu/9sqNHmeNN/thb3E3hRljqZ3SM49EewvY
AhE4yKYbLWsCp2UR0jfIdclMVyV3UfV1mNLaXIG3qjf6QAenIFk0kuVJLpx4/ak1
biPhp4xD9DskEnYnjp7xswjy23xicZLBAlYK2y3KUeL6MAvwQBv1q8+/y/pHBhL5
fr8hRuQz8+u2wva4X2lQRzPfXGBvVK5AHXL9yLLyXZWGGjT8pSfJFbu8uc3NUHaX
GMYC6TI+WlMaHGJW5YPpO3Qx68RP5LAsP4oEA0W3yqGYNc+QuhphQIyYxub/Qvz4
F3tjK2Q2Ix1Wew4RBuekocnAUNjfbFK5dNi/VSBBNgm43KglwFQ6UAQO7BZcST9s
HRAYyeE6b7/K4oB/xS28IZH5krPfHi8C/AOlw9hbGR17POKZWVj8OW9TY+EcIsYJ
KNS70qCMVB2yL1W0HnlDjr6JKGqgvnMAqqajpzuIJft1/tpOH96G2/w51xNgY+Hf
/8Qdcltcfb+AVXlthKzFuywhC7KLb2WZrue/hNxibz6janBkjEpNOFGyz9uU8jsN
NzCzl9kf224uNdYuzeFo
=UFoH
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jul_2012_14_53_01_+1000_l.Lq/clWLO.lwVcv--
