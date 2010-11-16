Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab0KPLXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:23:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58429 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab0KPLXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:23:51 -0500
Date: Tue, 16 Nov 2010 12:23:36 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20101116112336.GA3010@pengutronix.de>
References: <20101115094527.49464ed2@jbarnes-desktop>
 <m28w0tzffv.fsf@whitebox.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <m28w0tzffv.fsf@whitebox.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 16, 2010 at 12:16:36PM +0100, Andreas Schwab wrote:
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>=20
> > Martin Wilck (1):
> >       PCI: fix size checks for mmap() on /proc/bus/pci files
>=20
> That breaks X.
>=20
> process "X" tried to map 0x00010000 bytes at page 0x00000000 on 0000:00:1=
0.0 BAR 2 (start 0x        90000000, size 0x           10000)

Ah, thanks. Just had the same issue on one of my laptops, too...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkziabgACgkQD27XaX1/VRvE7wCeOBL9C9gPt4/dTb26A8JxjB2p
K1YAnjXz32zZbvwUlyjXI9AC6YlFtTRD
=M+lC
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
