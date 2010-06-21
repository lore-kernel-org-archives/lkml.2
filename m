Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0FUCDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:03:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab0FUCDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:03:39 -0400
Date: Mon, 21 Jun 2010 12:03:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the i2c tree
Message-Id: <20100621120331.1c6c1754.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Jun_2010_12_03_31_+1000__ImrcpGHLYvXnzHj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jun_2010_12_03_31_+1000__ImrcpGHLYvXnzHj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the i2c tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/i2c/i2c-core.c: In function 'i2c_detect':
drivers/i2c/i2c-core.c:1460: error: 'adap' undeclared (first use in this fu=
nction)

Caused by commit b741e61eb906816f78acbf361797fd408abdc715 ("i2c: Fix
probability check").  The typo in this patch is probably why the later
patch that I dropped would not apply ...

I have used the i2c tree form next-20100618 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Jun_2010_12_03_31_+1000__ImrcpGHLYvXnzHj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkweyHMACgkQjjKRsyhoI8xUpACdEm/jubUvjRjKAByj01sCJ1dU
g58An04H4MrGtcTU/jf5Lnad8/Y7Q5e6
=RiFY
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jun_2010_12_03_31_+1000__ImrcpGHLYvXnzHj--
