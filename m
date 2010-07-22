Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0GVB2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:28:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34041 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0GVB2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:28:38 -0400
Date: Thu, 22 Jul 2010 11:28:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the sound tree with the arm tree
Message-Id: <20100722112831.c6345379.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jul_2010_11_28_31_+1000_svmBv4vh_QMon2gA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jul_2010_11_28_31_+1000_svmBv4vh_QMon2gA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/mach-ep93xx/clock.c between commit
a99b53f80962ed98f4b598dc22f8c030b5dae55a ("ARM: AMBA: Add pclk support to
AMBA bus infrastructure") from the arm tree and commit
ed67ea82c0d9a163458dc6a69a7a3123db1a8b3b ("EP93xx: Add i2s core support")
from the sound tree.

Just context changes.  I fixed it up (it was just a blank line) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jul_2010_11_28_31_+1000_svmBv4vh_QMon2gA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMR56/AAoJEDMEi1NhKgbs6n4H/ipJsj0ushOfuceS+Mcfn8gy
Ka9mikTy6OZ2K4OV6uarF3jxWrO0H3TYY75AZymHWRt0ypGbMEhpNZmQ3ro29c3Y
bTkec8iIXOQnizRGBK4flsQNJelZ/IeU3f7wFvvzZ7XRlcWBel3OXl5guvV7Y9zi
i9PUfWOpJ9w1PFqyAFKs57JDSXSiH4/S3hqJHLeBqu5+gl+bQzogMwqOOEE6gEE+
yOvR8Q4K1xQlvucYjS0q6zwjpH+9cxw/Kll41pbgGicf4HjAeNVVDopVse4CNJs2
4/WDVpGY4Pt0jWCyt4bsKwncpaZQKfU1GxYz+IGrr6EykcFJIJTJ5ePcZeuG4cM=
=JfKN
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jul_2010_11_28_31_+1000_svmBv4vh_QMon2gA--
