Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0KVC5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:57:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55572 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab0KVC5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:57:23 -0500
Date: Mon, 22 Nov 2010 13:57:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, randy.dunlap@oracle.com,
        catalin.marinas@arm.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Revert
 "kconfig: Temporarily disable dependency warnings"
Message-Id: <20101122135715.121b5eb7.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Nov_2010_13_57_15_+1100_/G4+qX/M1Q8iy.b5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Nov_2010_13_57_15_+1100_/G4+qX/M1Q8iy.b5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe <lacombar@gmail.com> wrot=
e:
>
> There is 2 patches which fixes that by adding to the kconfig language
> a "visible" property to menus, 1 revert of "another" solution (which
> works but does not scale) and 2 patch which makes usage of the new
> property. Ack-ed and complemented by Mauro, but still waiting
> review/blessing by Michal.
>=20
> The core change is available here: https://patchwork.kernel.org/patch/306=
412/
>=20
> Alternatively, if you don't care about the menu structure, Randy
> proposed a one-liner.

OK, good to know it is being worked on.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Nov_2010_13_57_15_+1100_/G4+qX/M1Q8iy.b5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM6dwLAAoJEDMEi1NhKgbsP7kIAJbu9b59fW0cFsf9A2aK0yB0
UJsgLp530WOzDYjnvFfOJrIMlniTD/UYpbSAoTn33BF/Oh4xdOFvIt7XBJgEvLz7
IERHY/tNxlwD2h2u1U+EZso7AfkKWezoS9Tj6PJSJVMwOipuPrLO8Px9//zh1Ii4
jM6f9R/43DtM3C+2P5dPbgvLyBBSIqM78wAKj5Yu6vqqkW0v6ig/k8371mgEjsJg
SxhQbvcPYssMTrB6XPr+xp7XLrozhMqLmYzZhiOsrdZTp4LP0AeW2EtBlaBVEk4T
hjipJR2qxjn90oqzLOz8pf1LVw/ojJUGlx5Ero3dv6QsQJF/LMgEq4mCXh9D34A=
=AyOM
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Nov_2010_13_57_15_+1100_/G4+qX/M1Q8iy.b5--
