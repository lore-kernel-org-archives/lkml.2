Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542Ab2JYCtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:49:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57001 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2JYCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:49:02 -0400
Date: Thu, 25 Oct 2012 13:48:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, linux-next@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: mmotm 2012-10-24-17-15 uploaded (uml)
Message-Id: <20121025134850.76cdb390565dfe5117bdef7e@canb.auug.org.au>
In-Reply-To: <50889347.4070801@xenotime.net>
References: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com>
	<50889347.4070801@xenotime.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_13_48_50_+1100_W0//dMTdMtFYQYl9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_13_48_50_+1100_W0//dMTdMtFYQYl9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 24 Oct 2012 18:17:59 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> uml on x86_64 defconfig:
>=20
> arch/um/drivers/chan_kern.c: In function 'tty_receive_char':
> arch/um/drivers/chan_kern.c:89:42: error: 'struct tty_struct' has no memb=
er named 'raw'

Caused by commit 53c5ee2cfb4d ("TTY: move ldisc data from tty_struct:
simple members") from the tty tree in linux-next. cc's added.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_13_48_50_+1100_W0//dMTdMtFYQYl9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiKiSAAoJEECxmPOUX5FEPCoQAKQkPuWwOt42MUAXD6QfND04
jZUPLUcZdZPA8ci34N/jH8+cszUO6XzIXU2igDdMe8Cg0O0I0HtnkpRG5QkZ1Cpw
FD/HCePZq80n0aOpqpC0iFSDrfgmclR5j0PZassLgLrhiPShZRuoPhnN/cMydLTZ
Yx2FTkOGuof1MRxw/7HdV3/3PrBvw/iul+CG+dSezfK4mSOoMRTd62psrdmMAbnx
tSVPXi08TQQ+XXawYGnxswy51BiMpcsyeDkXccz3Z/pLu4BZWn3XQ4mtE+AdmJm0
r8pKiFL6U4ybFyihQKKvEKnDoXN+GfO6qPfyrlXEnvYkFqZmZGP2nqNZspKqmfUH
u0ET6LPp6cSOLLocZYa9cmwpVjpDbS2Yr688HMMOWrnbnGI+MjdnMe7JJi6Xu6xV
/eEIm/oyez3dRYB4ulEk1rltgbJ7NF8wcfPSu1hzldElZ/XAVzlU3gqjEcpeXAlz
DSxHJmTktQArGbPPU+93khGCYafYjcMmBudV/VPWFcjqrLdE+13+P9fj8HPd5MHR
FR7YPFpCI98bA1z0KDRv2N4ghIXKM4T3LTC3stB6wnfvN6dAS73GkYXWDBKMH8H+
ClzDgDkOxo5LPxCflBgxIgPBEhAN5ajX2ofcem6tmxJaQw9j4Yha5bNPVzMk6UUQ
iplKnUg5tj4Yl11x3Yye
=Gxus
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_13_48_50_+1100_W0//dMTdMtFYQYl9--
