Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0G1COl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:14:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59038 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0G1COj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:14:39 -0400
Date: Wed, 28 Jul 2010 12:14:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: Make jz4740-fb depends on MACH_JZ4740
Message-Id: <20100728121431.8cb5554b.sfr@canb.auug.org.au>
In-Reply-To: <20100728113136.97942d63.sfr@canb.auug.org.au>
References: <20100727111422.673b4919.sfr@canb.auug.org.au>
	<1280197979-24307-1-git-send-email-lars@metafoo.de>
	<20100727055546.GA5469@linux-mips.org>
	<20100728113136.97942d63.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_12_14_31_+1000_d67reDFEy785X0Ha"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_12_14_31_+1000_d67reDFEy785X0Ha
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Wed, 28 Jul 2010 11:31:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 27 Jul 2010 06:55:46 +0100 Ralf Baechle <ralf@linux-mips.org> wro=
te:
> >
> > On Tue, Jul 27, 2010 at 04:32:59AM +0200, Lars-Peter Clausen wrote:
> >=20
> > > The jz4740-fb driver should only be selectabed of MACH_JZ4740 is sele=
cted.
> >=20
> > Thanks, folded into the original patch.
>=20
> But it didn't make it into your mips-for-linux-next branch today?

I will apply that patch myself just for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_12_14_31_+1000_d67reDFEy785X0Ha
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT5KHAAoJEDMEi1NhKgbsUfQH/Rj480z51khOP/Z/qZ+E4O/L
WkYk9gc1NagnTbYco8zsWzf8uOlO1D/mHI2dassAMzIq6US1OhimMU7M2JBv6RrO
SdPl3OVouot6qO8zeI9a03Q/eFN4k2QJMsgB+IYWQhQbeRnfbuBX3Kl/5uQLkwdK
GrwiNwFdKOs6UHgDutn90bsy3WwNHb7k7qAfylVlAXeNGUqUT49qju/2CP8u95GR
duVVHHxDuHqsMcYvItLIzJeoOcZ4V5KKD3XxcVWmJ/FQvwa/u5fefHuexxKXhArc
ZRyIfCVF4q40prqyG24SXl6M2931zPwd9jIr7ZypylAfuImMiFr0dsxA359xMpE=
=3WbO
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_12_14_31_+1000_d67reDFEy785X0Ha--
