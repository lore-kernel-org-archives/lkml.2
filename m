Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1DDIV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:21:26 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:52021 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1DDIVY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:21:24 -0400
X-Envelope-From: santiago@crfreenet.org
Date: Mon, 4 Apr 2011 10:33:47 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] s3fb: fix Virge/GX2
Message-ID: <20110404083347.GC9431@localhost>
References: <201103292107.11969.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <201103292107.11969.linux@rainbow-software.org>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29, 2011 at 09:07:08PM +0200, Ondrej Zary wrote:
> Fix Virge/GX2 support in s3fb:
> - fix IDs: 86C357 is GX2, 86C359 is GX2+, 86C356 probably does not exist
> - add memory size detection
> - drive it the same way as Trio3D/2X
>=20
> The original IDs most likely came from S3 website which claims that:
> - 356 is Virge/GX2 with ID=3D8A10, driver included in Windows 2K, XP
> - 357 is Virge/GX2+ with ID=3D8A11, driver included in Windows ME
> - 359 is Virge/GX2+ with ID=3D8A12, driver included in Windows ME
> but:
> - google search for 86C356 only reveals references to Trio3D (probably
> because of a typo - Trio3D is 86C365)
> - my card is clearly marked as 86C357, Virge/GX2 and has ID=3D8A10
> - there is no driver for IDs 8A11 and 8A12 in Windows ME
> - there is a driver for ID 8A10 in Windows ME that says it's GX2 (357)
>=20
> Tested with #9 Reality 334 (86C357 Virge/GX2, ID=3D0x8A10).
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk2ZgmsACgkQw1GB2RHercMU1QCdEloHe7ehmFz+VqFJ6KK9rsEQ
ilEAn3it3fhw5xS6Y4NL5eibKumCBGE9
=cAyz
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
