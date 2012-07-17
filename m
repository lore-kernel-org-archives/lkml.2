Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2GQHgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:36:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41644 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2GQHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:36:03 -0400
Date: Tue, 17 Jul 2012 17:35:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ming Lei <ming.lei@canonical.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for July 12 (v4l2-ioctl.c)
Message-Id: <20120717173553.095663543a67620efe55c9e2@canb.auug.org.au>
In-Reply-To: <201207170848.37945.hverkuil@xs4all.nl>
References: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au>
	<4FFEF21A.7050701@xenotime.net>
	<CACVXFVOy7VGstdotnofq=o_UmFh0KwqH6p25MamwAbLfRgcTRg@mail.gmail.com>
	<201207170848.37945.hverkuil@xs4all.nl>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jul_2012_17_35_53_+1000_ZiYuRUdTjxeI0Qnm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jul_2012_17_35_53_+1000_ZiYuRUdTjxeI0Qnm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 17 Jul 2012 08:48:37 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On Tue July 17 2012 04:25:35 Ming Lei wrote:
> > On Thu, Jul 12, 2012 at 11:49 PM, Randy Dunlap <rdunlap@xenotime.net> w=
rote:
> > >
> > > on i386 and/or x86_64, drivers/media/video/v4l2-ioctl.c has too many
> > > errors to be listed here.  This is the beginning few lines of the err=
ors:
> >=20
> > I see the errors on ARM too.
>=20
> A fix can be found here:
>=20
> http://patchwork.linuxtv.org/patch/13336/

And I have been applying that fix to linux-next since next-20120713 -
though Mauro has not applied it to the v4l-dvb tree yet ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Jul_2012_17_35_53_+1000_ZiYuRUdTjxeI0Qnm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQBRXZAAoJEECxmPOUX5FEGdEP/2AwWiwtl3RECKWWuJSXJmWD
OuwKx8UWtKn3TbsrSeB8PNFDtUsnyE4Tz6v2vYEP4xCA/QSqdPOHPLFxaKszjZ9j
EwCEeLprncW1/JGVvWTvgqIivO+69GDZmB30L0aAuXwxy2xvT8q4QGqWK1e1w2dG
Jse9HWbAMI7/TKlKuh1VLnxXhmpSwm/qsopHHVtHacPmn0bsPjlSYt/4DUx/Jz2+
/KGhOf5N4KmmYqWFyfjWOhGei21qdGP6I3N5SCzOIIXaNFOtw55eIK1xFBYlgilI
Wwc88tUPgdA7GRo+vgSLtnRhQ0JCPx+nN1Bg2gR1UQcPgeCjGjDRtRezBMJwFID+
UjHvr3KDprt2lXMGqsly2HEcqHfyvIbjoF/26lNXv8FOo8IsLQ6jS6XyT4d4QtkA
vYvwMu+UQ3PxM10uuelCRlE7lF8vC5n5r5fkgwNS80jOYIVrKf4n6x6jE/WsYCWd
DkoWuGU7umoGQs3+UJuaZGNrkrSVrvMGSjDJeJe5H9OX8Ketp+hW183MjB/GspHs
V2OQNYnbjJdO7t73RHN9x0AyCOypUE2ONImaa2dqEoTzEHTSE1YaEwg8pBPSHS88
BinJ+iY3tJ1zjQkfVTPRRj2YKDAkzeBEiAqUjHGdZonmgo0EYfpYV4nFfAUh72ry
JWe1fWDXCFnFomVA0avS
=lpaz
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jul_2012_17_35_53_+1000_ZiYuRUdTjxeI0Qnm--
