Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714Ab0HGDiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:38:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0HGDiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:38:07 -0400
Date: Sat, 7 Aug 2010 13:37:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Christoph Egger <siccegge@cs.fau.de>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the mtd tree with Linus' tree
Message-Id: <20100807133740.a3549810.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__7_Aug_2010_13_37_40_+1000_rtsNFU4hX0+e2gpA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Aug_2010_13_37_40_+1000_rtsNFU4hX0+e2gpA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the mtd tree got a conflict in
drivers/mtd/maps/Kconfig and drivers/mtd/maps/redwood.c between commit
c76986cca8379db619de4b6c6b7359125df0e341 ("Remove REDWOOD_[456] config
options and conditional code") from Linus' tree and commit
73ee5760253dc8893502e19a9cb118d25dab21ec ("mtd: remove redwood map
driver") from the mtd tree.

The latter just went further by actually removing the driver so I used
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Aug_2010_13_37_40_+1000_rtsNFU4hX0+e2gpA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMXNUEAAoJEDMEi1NhKgbshS8H/2AWaQDuV+g6dfFQjfQ6JCm/
Y9M4ScRKbH0eY/25bd1FxAKeBfQ9QWOdzMRDFyC960wAhrbSLq8QHlfUSSrjvIwf
McnDZsZA8FBOiYm/p+ma3X18Xf4ogWOsg0iu8kNeBLl6dW8uSUeF/N3FSR0YLEsO
zw3rlI/7PlQz8KF66DT7tXKBcImiKX/jHrNXoAJvIGAqFiVNZD9T8r0dlAvT/YgT
3ohRxH+Vd9h9KMFFlPPybVJIPNBxAbzyzdujY+JQXULct4oEeZpnH7kYeowHuxdo
Qln3nUhn1DeWGdciH9Zfey6ZRQe10MUDXganKpjA6D2mVjwm3SoqhGab0M9arRc=
=0w5l
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Aug_2010_13_37_40_+1000_rtsNFU4hX0+e2gpA--
