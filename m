Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2DCRHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:07:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49589 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2DCRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:07:12 -0400
Date: Tue, 3 Apr 2012 19:07:08 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120403170708.GC2477@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
 <20120403165320.GG19952@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <20120403165320.GG19952@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2012 at 09:53:20AM -0700, Chris Wright wrote:
> * Ivo Sieben (meltedpianoman@gmail.com) wrote:
> > +	instr =3D AT25_READ;
> > +	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
> > +		if (offset >=3D (1U << (at25->addrlen * 8)))
> > +			instr |=3D AT25_INSTR_BIT3;
> > +	*cp++ =3D instr;
> <snip>
> > +	/*
> > +	 * Certain EEPROMS have a size that is larger than the number of addr=
ess
> > +	 * bytes would allow (e.g. like M95040 from ST that has 512 Byte size
> > +	 * but uses only one address byte (A0 to A7) for addressing.) For
> > +	 * the extra address bit (A8, A16 or A24) bit 3 of the instruction by=
te
> > +	 * is used. This instruction bit is normally defined as don't care for
> > +	 * other AT25 like chips.
> > +	 */
> > +#define EE_INSTR_BIT3_IS_ADDR	0x0010
>=20
> Is there some guarantee that this chip flag will always have this
> meaning?

? This is a driver flag.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk97LjwACgkQD27XaX1/VRv5nQCfYaD/C91I3oLvSDAmb0t0Sg9p
hfIAn12PQKe+qysQcPn34RU3N75LeXea
=vQkH
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
