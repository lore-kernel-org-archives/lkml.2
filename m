Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab1FXBEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:04:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46679 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972Ab1FXBET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:04:19 -0400
Date: Fri, 24 Jun 2011 11:04:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, socketcan-core@lists.berlios.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 23 (net/can & i/o)
Message-Id: <20110624110409.10a6951c.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTi=ZxHDvhCs8Qki2ZrhCbfY6Mjx5+w@mail.gmail.com>
References: <BANLkTi=ZxHDvhCs8Qki2ZrhCbfY6Mjx5+w@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jun_2011_11_04_09_+1000_CQvg8Cv/hoqE8r4S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jun_2011_11_04_09_+1000_CQvg8Cv/hoqE8r4S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Thu, 23 Jun 2011 16:38:56 -0400 Mike Frysinger <vapier.adi@gmail.com> wr=
ote:
>
> not sure where this is coming from, but some Blackfin boards now fail wit=
h:
>=20
> drivers/net/can/bfin_can.c: In function 'bfin_can_start_xmit':
> drivers/net/can/bfin_can.c:247: error: implicit declaration of function '=
writew'
> make[3]: *** [drivers/net/can/bfin_can.o] Error 1

yeah, caused by the removal of the inclusion of mm.h from netdevice.h
(most probably).

> at any rate, the usage of writew() in this driver is wrong, so i sent
> a patch to fix it.  but since nothing in this file nor in my Blackfin
> tree changed, i wonder if whatever common code changed is going to
> break other stuff ...

It did indeed :-(

ah, well, I guess that is what I am here for :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jun_2011_11_04_09_+1000_CQvg8Cv/hoqE8r4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOA+KJAAoJEDMEi1NhKgbsY1EH/2G+CGsfbArVAbzGOe6mf2G7
iEIp6p7dF88WMfObMDcs/+lqmk5jhzQ1iCHctoPUBlvKnX7q43dSUFBw/UrmqPbC
YuhMePBy3x2I6m3hzADP51qDSnmoqwwnXb6Ut6Xu12hUYcpnzSIm2gaVfUA/Mzfk
VJNBkln1rXU4uhgKWZWQ8gMo0CyZ8Pbk3OCxcaKU5Wi1flUuRjV8n+cAsogL4+zB
vnWgX1n8D0j4r52q3W1eiA0ggpMBy0EE6ZYK59Kuk8fPjgXChvrdh49O2u2dyzlQ
xLsL6zERwTcQUb6BrQF94Y07XvLRudMAEtlI0oHiidXapMDSP1NHWizxFiqSQBA=
=u2GL
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jun_2011_11_04_09_+1000_CQvg8Cv/hoqE8r4S--
