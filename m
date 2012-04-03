Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2DCRRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:17:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56704 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2DCRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:17:44 -0400
Date: Tue, 3 Apr 2012 19:17:36 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120403171736.GD2477@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
 <20120403165320.GG19952@sequoia.sous-sol.org>
 <20120403170708.GC2477@pengutronix.de>
 <20120403171112.GH19952@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Content-Disposition: inline
In-Reply-To: <20120403171112.GH19952@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > > +	/*
> > > > +	 * Certain EEPROMS have a size that is larger than the number of =
address
> > > > +	 * bytes would allow (e.g. like M95040 from ST that has 512 Byte =
size
> > > > +	 * but uses only one address byte (A0 to A7) for addressing.) For
> > > > +	 * the extra address bit (A8, A16 or A24) bit 3 of the instructio=
n byte
> > > > +	 * is used. This instruction bit is normally defined as don't car=
e for
> > > > +	 * other AT25 like chips.
> > > > +	 */
> > > > +#define EE_INSTR_BIT3_IS_ADDR	0x0010
> > >=20
> > > Is there some guarantee that this chip flag will always have this
> > > meaning?
> >=20
> > ? This is a driver flag.
>=20
> Sorry, I don't see it set anywhere, so unclear on where it comes from.
> I thought it was from a generic spi probe.

Yeah, agreed, 'struct spi_eeprom' does not sound much like platform_data :/
Thanks for checking.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk97MLAACgkQD27XaX1/VRtw2QCggmIMO+ISn5+bzAo8K3kbj7B2
sAUAoJNr1feEO4ED1QoRZqrHpcCrn71B
=S0t5
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
