Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1CCJ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:29:46 -0500
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:64755 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1CCJ3n (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:29:43 -0500
X-Envelope-From: santiago@crfreenet.org
Date: Thu, 3 Mar 2011 09:50:44 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] s3fb: use new start address register
Message-ID: <20110303085044.GE8363@localhost>
References: <201103012018.45635.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <201103012018.45635.linux@rainbow-software.org>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 01, 2011 at 08:18:43PM +0100, Ondrej Zary wrote:
> Use "new" start address register 0x69 (bits 16-20) instead of "old" 0x31
> (bits 16-17) and 0x51 (bits 18-19). This is needed for panning to work
> correctly on Trio3D/2X cards (and does no harm on other ones).
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1vVmQACgkQw1GB2RHercPdIACggTIXr79xyE3TVN7unDLSkl3t
xLsAnRY8QKDpCD+aH1cW+F9GW+r/4QWR
=r+9+
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
