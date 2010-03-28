Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0C1DB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:01:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0C1DBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:01:55 -0400
Date: Sun, 28 Mar 2010 14:01:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, david@fries.net, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Message-Id: <20100328140141.f4a86697.sfr@canb.auug.org.au>
In-Reply-To: <201003271634.08054.bzolnier@gmail.com>
References: <4BAD5472.9050303@garzik.org>
	<201003271119.53757.bzolnier@gmail.com>
	<20100327.074434.193717071.davem@davemloft.net>
	<201003271634.08054.bzolnier@gmail.com>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Mar_2010_14_01_41_+1100_v9.R/19XUj091tkL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Mar_2010_14_01_41_+1100_v9.R/19XUj091tkL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Sat, 27 Mar 2010 16:34:08 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmai=
l.com> wrote:
>
> On Saturday 27 March 2010 03:44:34 pm David Miller wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Sat, 27 Mar 2010 11:19:53 +0100
> >=20
> > > The commit itself may also have a problem but since it was _never_ in
> > > linux-next tree it never saw a wider upstream testing.
> >=20
> > This is not true Bart.
>=20
> Uh?  I had verified my claims before writing previous mail..
>=20
> The patch ("via82cxxx: workaround h/w bugs") appeared in Linus'
> tree on 19th January and it was neither in next-20100101 nor in
> next-20100119.. etc.

That commit first appeared in linux-next in next-20100120 as part of
Dave's ide tree.  It was merged into Linus' tree on March 5th (commit
4c10c937cc2eb197db565392db91d429eec71176 "Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-next-2.6").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Mar_2010_14_01_41_+1100_v9.R/19XUj091tkL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuuxpUACgkQjjKRsyhoI8z+hACcCdX6Gfmpx98FQU82fQmlrbAf
8kEAoIllxYcIFrVTXd1Ozxbzl/yYY1Bk
=ZLJx
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Mar_2010_14_01_41_+1100_v9.R/19XUj091tkL--
