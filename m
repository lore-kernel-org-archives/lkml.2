Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1DDIVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:21:05 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:50880 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1DDIVE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:21:04 -0400
X-Envelope-From: santiago@crfreenet.org
Date: Mon, 4 Apr 2011 10:33:16 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3] s3fb: add DDC support
Message-ID: <20110404083316.GB9431@localhost>
References: <201104032236.18936.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <201104032236.18936.linux@rainbow-software.org>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 03, 2011 at 10:36:15PM +0200, Ondrej Zary wrote:
> Add I2C support for the DDC bus and also default mode initialization by
> reading monitor EDID to the s3fb driver.
>=20
> Tested on Trio64V+ (2 cards), Trio64V2/DX, Virge (3 cards),
> Virge/DX (3 cards), Virge/GX2, Trio3D/2X (4 cards), Trio3D.
>=20
> Will probably not work on Trio32 - my 2 cards have DDC support in BIOS th=
at
> looks different from the other cards but the DDC pins on the VGA connector
> are not connected.
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk2ZgkwACgkQw1GB2RHercNyUQCfR2jtWsyLsivx/IMhO+HM31Oz
nnEAnjt5uMoxJ3GUiqmU4zd8fifrn18d
=/MoA
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
