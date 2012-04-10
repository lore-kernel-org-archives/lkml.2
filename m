Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2DJFMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:12:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59123 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2DJFMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:12:35 -0400
Date: Tue, 10 Apr 2012 15:12:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 10
Message-Id: <20120410151229.836f8d8e806f33d26c4719f9@canb.auug.org.au>
In-Reply-To: <20120410145546.65b54b0d515db38e23bb4624@canb.auug.org.au>
References: <20120410145546.65b54b0d515db38e23bb4624@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_15_12_29_+1000_9O6XBa86OxS6o1eG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_15_12_29_+1000_9O6XBa86OxS6o1eG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 14:55:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Changes since 20120405:
>=20
> New trees: sh-current, sh
>=20
> The tile tree gained conflicts against Linus' tree.
>=20
> The net-next tree lost its build failure.
>=20
> The wireless-next tree gained a conflict against the net-next tree.
>=20
> The trivial tree lost its conflict.

The regulator tree gained a build failure so I used the version from
next-20120405.

> The tty tree gained a build failure so I used the version from
> next-20120405.
>=20
> The pinctrl tree still had its build failure so I used the version from
> next-20120403.
>=20
> The akpm tree lost several patches that turned up in Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Apr_2012_15_12_29_+1000_9O6XBa86OxS6o1eG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg8E9AAoJEECxmPOUX5FEi3kP/2joZcNSRWAZOsPDciJLTc+i
oePPYcPQchNJix1XBGBssiMhOW2aM5sJZGpB5QnjmvseAX3UPUCovdovBekEw0g7
usuxrYd0sj+IoFmAb3W6wG5Gtawa4Hy9mDgFGbmAwt5wojZfq8AbFvtciYEUJEaY
n+2vdQ7UN+ZNLcctNfgl06S2tfhs8S74D362H4XdgpdFLf8sU30qW3g9yMIgShd3
OngfWzlR25ecaeRvhF1BIImFfe0AYcCBW2XraAuLUV/8dVNnNssIY0l0cr0kg3Nd
C4Z4ruP42fOn9OhHVHC1m35VjELEG94fMqfv73rN/nDBGM9b1l6IS8ZonIRVVLzx
zqgMYqJgJdvUmJ01fMZTkSznyiGr+DDRn6MqXMUpI/cTgkwG1Aj37iOtoRtfscv8
cMj8Xo7tstJXTfI9TZFuDSssPxVJgDUa2QS7g1Y0gquhR3Ka3VbXIr+HnZ+xEyjm
PJBP1NYkF8unCjBEQyE7cphu7D7GdS/Z7k9LiH79h5NMPDbvDXvHoYVqkJbnhpBr
kFowK7Ozh3FdRTklVgHtqM9lqcdvv1fKcy2ZGPkTiWlVgm1LgojSaq3UjNP01TYx
I5R5XjwtXxniBYuUml1OFRIBX/yjPt8Nzqty9x+sEyEIb4NXnshTABEhI5nsBJDw
dOIVShsWo/XgV3DPC5eN
=Fa4u
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_15_12_29_+1000_9O6XBa86OxS6o1eG--
