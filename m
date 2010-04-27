Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0D0D5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:57:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39910 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0D0D5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:57:12 -0400
Date: Tue, 27 Apr 2010 13:57:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sjur Braendeland <sjur.brandeland@stericsson.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
       Pavan Savoy <pavan_savoy@ti.com>
Subject: linux-next: manual merge of the tty tree with the net tree
Message-Id: <20100427135706.259fa9c9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_13_57_06_+1000_mrs_nB.6EH/=Uo7u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_13_57_06_+1000_mrs_nB.6EH/=Uo7u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
include/linux/tty.h between commit
9b27105b4a44c54bf91ecd7d0315034ae75684f7 ("net-caif-driver: add CAIF
serial driver (ldisc)") from the net tree and commit
f3150d54db0e0caa1871f66b2424f463a34a7e7b ("serial: TTY: new ldiscs for
staging") from the tty tree.

I fixed it up (they both changed NR_LDISCS - I used the higher number) and
can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_13_57_06_+1000_mrs_nB.6EH/=Uo7u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWYJIACgkQjjKRsyhoI8znEwCeNAyEj5U/jSsfPK61aBxC4pfU
LuUAniauKxZCc2BASpKTjP9dfpj6htaH
=sh/J
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_13_57_06_+1000_mrs_nB.6EH/=Uo7u--
