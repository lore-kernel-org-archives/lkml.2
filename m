Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1CCI7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:59:14 -0500
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:50782 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1CCI7M (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:59:12 -0500
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 03:59:12 EST
X-Envelope-From: santiago@crfreenet.org
Date: Thu, 3 Mar 2011 09:49:02 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] s3fb: maximize virtual vertical size for fast
	scrolling
Message-ID: <20110303084902.GA8363@localhost>
References: <201103012018.11283.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <201103012018.11283.linux@rainbow-software.org>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 01, 2011 at 08:18:08PM +0100, Ondrej Zary wrote:
> Maximize virtual vertical framebuffer size during init to allow fast scro=
lling=20
> (accelerated by panning).
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1vVf4ACgkQw1GB2RHercPJmwCfc85Uw/DM9pt7/mTZnR7CLElk
xsYAn3wpPJUadCxQ/KXFbQs62mmkrQZH
=KyOz
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
