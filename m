Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2CHHpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:45:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33599 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2CHHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:45:19 -0500
Date: Thu, 8 Mar 2012 08:45:10 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/3] drivers: base: add support for stmp-style devices
Message-ID: <20120308074510.GB18510@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
 <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
 <CAOMZO5C9EDi_Hy-8=iphr+154gyPgBLnjSVV0seLgi+HoK4zRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <CAOMZO5C9EDi_Hy-8=iphr+154gyPgBLnjSVV0seLgi+HoK4zRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 07:40:22PM -0300, Fabio Estevam wrote:
> On Wed, Mar 7, 2012 at 7:28 PM, Wolfram Sang <w.sang@pengutronix.de> wrot=
e:
> ...
> > +static int stmp_clear_poll_bit(void __iomem *addr, u32 mask)
> > +{
> > + =A0 =A0 =A0 int timeout =3D 0x400;
>=20
> Could you please add a proper timeout mechanism here?
>=20
> Something like: http://patchwork.ozlabs.org/patch/137365/

=46rom the patch description:

=3D=3D=3D

To avoid regressions and ease reviewing, the actual code is simply copied f=
rom
mach-mxs. It definately wants updates, but those need a seperate patch seri=
es.

=3D=3D=3D

Or is that considered a wrong path?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9YY4YACgkQD27XaX1/VRu7/ACfWLUXnY+fuir045BtUEDQ0U3z
B0AAoIkrt58zivO8SF2N1buTV6+K93cb
=NCed
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
