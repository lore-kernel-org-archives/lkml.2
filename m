Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2K2Ers (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:47:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38907 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2K2Err (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:47:47 -0500
Date: Thu, 29 Nov 2012 15:47:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20121129154739.241d7a45c8bab79b3aeb9fe6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_47_39_+1100_l_JzM1SjO9mElQtg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_47_39_+1100_l_JzM1SjO9mElQtg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflicts in
drivers/staging/fwserial/fwserial.c, drivers/staging/Kconfig and
drivers/staging/Kconfig between commit 7355ba3445f2 ("staging: fwserial:
Add TTY-over-Firewire serial driver") from the tty tree and commit
e5711071ad94 ("staging: fwserial: Add TTY-over-Firewire serial driver")
from the staging tree.

I am not sure why this patch exists in both trees :-(

I fixed it up (they are the same but the trees contain more commits
affecting these files) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_15_47_39_+1100_l_JzM1SjO9mElQtg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtujrAAoJEECxmPOUX5FEfCUP/itfXzXsgmQGLlvfPkCm/qSA
nhZbS0MB8gX6bV8A7YhmOfb8+pWCkLtc9f7YqVYMd3L2tXuYr6IGfFwHpQ7A4F+r
MNG/KkufjY5ByqzWH8bKltlafZqTudNuJwD34lIyU2euxJQnHr1IVXhIZEzu4fJU
t7MKGO6wzB3TXs6jQFtn6Lnz9Kn43LfFSGkArZikp0pIPQxSA26zJ26rW+Nyntek
lvLGu8PPxVwvdeLDkElWX85BjB6tE1J8x5RW//mRSJhD7jW/e7dEe8mlddjiEQxf
j8XL2Vy/W3YUdzPqsS7Es3PdixMPgBWsGptny1rDGBnAy0oUYqaALNd8jV7HM1Qk
qo4xGtdY+fp+iKuj8Z6RzPPlY9erbonnf9Y7xNmgwKcvxsmrATz9ns4Uuph+Y3Pt
2mbqtktWH084nbEFUgakYtpaH8fjBKPVvNXpJiClvXSJIrpl0fCEYd4CgC11Jjfi
010N5rONEWQT77g6T4D9A1+t7Pfwbbm7QrfbkbfjjzijwSzU/2/J3qhQ7WuBb4Oi
Qud2w67uQWPX/eMsT6tNQbMYgXEUb9DKwTarhHEe6TANG+m2S/6TPARQVjHGpskx
jDRjcXZe2J8lABL2PdAuLxvO9SmBnKd25ezcfILWM44GUKyov86IkRuMCdwM1SDP
pUk+Y6cGcCGj5d1huRq6
=0gh1
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_47_39_+1100_l_JzM1SjO9mElQtg--
