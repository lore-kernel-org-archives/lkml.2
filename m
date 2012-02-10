Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab2BJLKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:10:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33415 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab2BJLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:10:37 -0500
Date: Fri, 10 Feb 2012 11:10:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/3] ASoC: twl6040: Remove dependency on twl4030 from
 Kconfig
Message-ID: <20120210111035.GD3056@opensource.wolfsonmicro.com>
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
 <1328868018-24668-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <1328868018-24668-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2012 at 12:00:18PM +0200, Peter Ujfalusi wrote:
> twl6040 no longer needs twl4030.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This should go via whatever path the first two patches go.

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNPskAAoJEBus8iNuMP3dWhUP/j833HfDyb3ugioLFPhn8DcI
wSbdZXaNFM0X53zgGsRZ5oE0WhrWJOpVoR3EA+6ITPKLsjw2q8TPp9hkxwjjJzPZ
SbaEbDX5BHNKieuqwQfU439t0DogvPJW83UjdhRrSHAOG+BXbLOBLjfuXokIuEOE
ULp7qILEab8BKv3JTmZSoYR3wt+ZsBzDMvw2T8+lHtpRfG3F/YaQgkshxSrABQv2
jUcVqDGOQtzR7mGl90BJQn8lFql7JSuIakcX6uiGN4cXln6j6PLiGLQIwXRr35Fn
f7GiZdItJWyYgl1FKiZ4OUltGmSaTo1B8TNxH4tOQmAm5mkr0cgCq8cupH8pZ+wl
rJrClaLXKp0/F7mrd13Q9kkyVlrJi/gQ53yvUX7r8nwrZHXCThqciNsr1eMK6ULt
FndKibhLUGYlY0csSO087hz2XpF7JCg4g19aVOos9Sfo4B76fA3IdHv8csDM9sFc
/ZMTnmtJtKYVlcG5C4/GQRvQJJRhHnt9aRwkk/Ofz+eer43KvnGuq6Jq4/4yE/xU
862acfsXH+HBpG7ipvm7V3ILEXBkPESJLI/a/iY/NJYzwTi3qEs813GXJWpVPZCZ
jxeDNlZrBTwzUCGexCw4NwQKdmYHkirhoh1s2Rgl2/dEWZ+aIygqQLGUWxb51HwR
8IIcvVkEBbclD6ee/mVV
=z156
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
