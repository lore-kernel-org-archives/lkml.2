Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1GPMhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56110 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab1GPMhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:04 -0400
Date: Sat, 16 Jul 2011 18:17:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>
Subject: linux-next: manual merge of the rr tree with the openrisc tree
Message-Id: <20110716181723.08d5a7b96cca094dee74f825@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_18_17_23_+1000__p_Y_FqWKDYUvPW6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_18_17_23_+1000__p_Y_FqWKDYUvPW6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/openrisc/kernel/module.c between commit 07319a81a55f ("OpenRISC:
Module support") from the openrisc tree and commit 7c71b2f8e35c
("modules: make arch's use default loader hooks") from the rr tree.

This is an indirect conflict that turns up because
arch/openrisc/kernel/module.c is based very closely on a file that is
modified by the rr commit.  I have just used the openrisc version of the
file, but I assume that much of it could be removed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_18_17_23_+1000__p_Y_FqWKDYUvPW6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIUkTAAoJEDMEi1NhKgbsl5QH/3DNMTso9yKhkdzGtRbXnbwm
9rPULedrsy9Ts3bZcQtxLqAYXWGddtENHcIWN+HU9/G2F1uZYDEVdw4j+csJvXNg
scYuy/85rjZrHft4usvJ1mD/ldJ3SbwPUtOZBsxufTHoBh4Nt7pBcDUPfH8YqQ9u
C5ejI9a9h6CxvTAuduWx8f3k+o0KUaShobpiMtYjhSjya8jkeOYYvH6qLUofnc5p
IIhb1BO5IXVp4Mu/gVWvWcodnbqlCOYVdwJXYa2/50jz7qCNc5J6E4w3TOjDZV6A
+cMXhYxV/8/omrw9ZuAVnDzXpem4fNDI1GxParDFDahlJYBqgoV1TDOLFiNW4DY=
=UCQ5
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_18_17_23_+1000__p_Y_FqWKDYUvPW6--
