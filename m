Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2BPF3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:29:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33342 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2BPF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:29:11 -0500
Date: Thu, 16 Feb 2012 16:29:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: linux-next: build failure after merge of the final tree (fbdev tree
 related)
Message-Id: <20120216162900.e2dd164732084f48e5b239f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Feb_2012_16_29_00_+1100_xAQJtgvzlUsJ2MKl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Feb_2012_16_29_00_+1100_xAQJtgvzlUsJ2MKl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/i740fb.c: In function 'i740fb_remove':
drivers/video/i740fb.c:1192:7: error: 'par' undeclared (first use in this f=
unction)

Caused by commit 5350c65f4f15 ("Resurrect Intel740 driver: i740fb") from
the fbdev tree.  CONFIG_MTRR is not defined for this build ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Feb_2012_16_29_00_+1100_xAQJtgvzlUsJ2MKl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPJQcAAoJEECxmPOUX5FEoWUP/35QFVh8eV6jSARbZKmJHXsc
CQsmKf2GRBd678ZVFTyZfP7q7S2dYn61y1NnGG0cgJMi5Yr8LCbLD9jcU0pnZxB1
qetP9nQsWRBXK8my8/ICBHJ2C4D2hCv8ZL2X1SsCL14z8EluaAbQ0bItSXMX9gpJ
Ele/6bCcgrgLQ/a1Dn7iClfnXW0HjDSdK1eZ4T65gIiJX1uV5/GdakJGCbAIXakF
dVSbI9Tp017j2yPMxcODH82kJ5A6pxzZ6CKPRfE03oR7zqPR4ntiwMzepZ8Mpy0Z
7pVYY8HuZvDoYFGaPvheC3hlb78V1zTi6EptdXjQfqP6fdrnomZ6ekSSA6D4YX3w
URSpgMYD1+FfoWmMtid2fBWxAJA8c+D+9eRZ33wEP1rnffyLS+RMwQOx95H6aSC8
oS39L5qbF+pLrVrIDLP5g1/ecF9owDRHffFtKSe5X1ZRju7XyOwu6BxDIeH4Hjco
YaDmAJD2Ye+LzELfjxsBmfWZ1brz8dp7fV8YrLopBwULNe8ZiOLg8Aeob8XfQDJi
BTnWEiY1PRMLpwRYoYlzgiM4jR6FYna6totb0iFS4GKaK9HUP9RVxOnxOIiVDtT7
dmc39l/L5MuKQuBJ5eWTcFOd9YEoz24snBbs2cucZtUklUsiBFj4XPgfdiRkO79x
IDW6JTjCZkeHti/8cFjc
=hKgu
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Feb_2012_16_29_00_+1100_xAQJtgvzlUsJ2MKl--
