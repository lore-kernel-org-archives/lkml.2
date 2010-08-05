Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab0HEAxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:53:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0HEAxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:53:33 -0400
Date: Thu, 5 Aug 2010 10:53:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Kulikov Vasiliy <segooon@gmail.com>
Subject: linux-next: manual merge of the genesis tree with Linus' tree
Message-Id: <20100805105327.d1e4deb1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_10_53_27_+1000_ch8KvHF_uM+B6cz9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Aug_2010_10_53_27_+1000_ch8KvHF_uM+B6cz9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the genesis tree got a conflict in
drivers/net/irda/sh_irda.c between commit
752ef8b541da2606c5668dcc176e7b16dd68b945 ("drivers: irda: fix sign bug")
from Linus' tree and commit 8a2b6beffc88b83089845d72eed2ed74eb5c9b1e
("net/irda/sh_irda: Modify clk_get lookups") from the genesis tree.

Just context changes.  I fixed it up (trivially) and can carry the fix
for a while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/irda/sh_irda.c
index edd5666,9db7084..0000000
--- a/drivers/net/irda/sh_irda.c
+++ b/drivers/net/irda/sh_irda.c

--Signature=_Thu__5_Aug_2010_10_53_27_+1000_ch8KvHF_uM+B6cz9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWguHAAoJEDMEi1NhKgbsS94H/0Z8gRWB/w5im9F08fqiQ4rC
clUU8rLiP9e7wO+ZGJKoZ0F7M7Niw3nY2eSA+yrSg/VGVZXTqNGecd1up1Z+YBbK
UODlB7zVaLx0XMpL4fYneVLotID0UihW8JY/Sy6f5Bc6JxplHUaPQ3SXWhTM619G
DeK7hyxIjKddWwkG67RH+QKPlE0NnU1Xbmzl13Ln91AQFQVV9hU5Lt9wlQTKoydi
eknjn0GmqZ6DG6RWhBlevF6FN2/vASaNtKzeUFeqetP+MnkG7GIjRanAFaGicK55
JMEZjIvPa2MQ+tlgP0qSQ88nKqfdanZ+nSedx8obv5qdmW9hoC75UXjMpdauH6s=
=PVbb
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_10_53_27_+1000_ch8KvHF_uM+B6cz9--
