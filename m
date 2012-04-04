Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2DDIAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:00:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51517 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2DDIAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:00:06 -0400
Date: Wed, 4 Apr 2012 09:59:56 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120404075956.GB9073@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
 <20120403165320.GG19952@sequoia.sous-sol.org>
 <20120403170708.GC2477@pengutronix.de>
 <20120403171112.GH19952@sequoia.sous-sol.org>
 <20120403171736.GD2477@pengutronix.de>
 <CAMSQXEHpjD7LWQkKWJOU=9eFYqsaJi-xHFTxexQr7yoKiCG7HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <CAMSQXEHpjD7LWQkKWJOU=9eFYqsaJi-xHFTxexQr7yoKiCG7HQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 09:21:57AM +0200, Ivo Sieben wrote:
> Hi,
>=20
> Op 3 april 2012 19:17 heeft Wolfram Sang <w.sang@pengutronix.de> het
> volgende geschreven:
> >
> >> > > > +#define EE_INSTR_BIT3_IS_ADDR =A00x0010
> >> > >
> >> > > Is there some guarantee that this chip flag will always have this
> >> > > meaning?
> >> >
> >> > ? This is a driver flag.
> >>
> >> Sorry, I don't see it set anywhere, so unclear on where it comes from.
> >> I thought it was from a generic spi probe.
> >
> > Yeah, agreed, 'struct spi_eeprom' does not sound much like platform_dat=
a :/
> > Thanks for checking.
>=20
> The flag is indeed used in the platform initialization to enable the
> "address bit" behavior, so you don't see it set anywhere in this patch
> (and not anywhere in the kernel, since no board uses this flag yet).
>=20
> Is it OK if we leave this patch like this?

Yes. This is a useful extension and there will be boards using it.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk97/3wACgkQD27XaX1/VRtYtgCeKWZbwE8YnXy19Azu/QFugfwh
ur4AnifYYhmp2r/TyFdXYuey+6bq7G3w
=hGHy
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
