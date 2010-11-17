Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab0KQCdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:33:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0KQCdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:33:37 -0500
Date: Wed, 17 Nov 2010 13:33:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: fate of the cleancache tree
Message-Id: <20101117133324.0654bfd9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Nov_2010_13_33_24_+1100__59AbtRlEan0VObW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Nov_2010_13_33_24_+1100__59AbtRlEan0VObW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus, Dan,

I didn't really follow the discussion at Kernel Summit, but there seemed
to be some question as to whether the cleancache stuff will be merged or
not.  It missed 2.6.37 (obviously), but my question now is do I keep in
in linux-next in the hope that it will be merged in 2.6.38?  Or is that
not going to happen?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Nov_2010_13_33_24_+1100__59AbtRlEan0VObW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4z70AAoJEDMEi1NhKgbsjEwH/1XSfvx6XrcO7a9EdCWUZRZi
TslAyUMp8Ftt3qwi276sfatHx0f6dCAwTZQ8VYom40l858heUCWUirDignlYIdYN
MYLO4DLk+MLaL9BUfEVlqdQ+VlEKoj/kc5z2fPLrIq70bYuOEcs/9jkQiTITWRdj
B+saZADpq4KmNX5TrW5QZSo6S/WmsKJ2aiE75TwgRg4eBs86nXekBQHw7/4+U9//
D7v3gNorAQs6Tw1npV9dL7qmC1FWkR9VlYTyG45ee7GOTjhmIqdCpd+rp2id7FIT
PGndiweNQfPznJ6YjFLswFNGG6sfpJXuwiLeqvECSLW23p3cI0OztWoDdwG4bjU=
=4pX8
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Nov_2010_13_33_24_+1100__59AbtRlEan0VObW--
