Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2GASLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:11:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab2GASLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:11:04 -0400
Date: Sun, 1 Jul 2012 19:10:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: philipspatches@gmail.com
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, linux-mmc@vger.kernel.org,
        Philip Rakity <prakity@marvell.com>
Subject: Re: [PATCH] regulator: add missing defintion
 regulator_is_supported_voltage
Message-ID: <20120701181055.GC28922@opensource.wolfsonmicro.com>
References: <1341097536-14190-1-git-send-email-prakity@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fo/b2PYVqg2cQvBK"
Content-Disposition: inline
In-Reply-To: <1341097536-14190-1-git-send-email-prakity@marvell.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fo/b2PYVqg2cQvBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 30, 2012 at 04:05:36PM -0700, philipspatches@gmail.com wrote:
> From: Philip Rakity <prakity@marvell.com>
>=20
> This definition is missing when CONFIG_REGULATOR is not defined.
> This causes compiler errors when compiling sdhci.c.  This can
> be worked around by adding #ifdef CONFIG_REGULATOR .. #endif
> but since other definitions are there we have defined the missing
> definition

Applied, thanks.

--fo/b2PYVqg2cQvBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8JKlAAoJEBus8iNuMP3dv54P/0vA1X5J7sOBYcVY4ggywmtw
Is8TDYy6jJ1d0787H8U71bcAB6TlV1nqAnaf6T7tAmIjbo82uw0aQF21Qe+IPyhi
1D4oxbiUGlV163keyguQTxat5jV65tOXHFJUESbKVCy3YbUQQIAcSconoKaR9ML9
jsHAGIl0E0s3mjmmPeuQWRmqCp1KV/m15BeXU5PIF+jNvkpsF+hENZwsvTY+RXUQ
O8xh4hh/OTz1K2hlsj/5HNAxGHMm8ReghwiWSZMg62TfbJ240y/n301UgIGYGd4q
OAthBQ0JFwhnK8ve0WipHKRC27sNmttBQooLqDQqujFOHDdkfnzbBJ+uTMuKKzwK
TupyoicT5E0nEntpTrhAnwgESMWraYE0BFdsHCVQUN8lY4HYINuBaPz+lLErgiRI
dgveqOeN4B5jfoHtaw5a9PkOSXJoDI44ku+wBa7LVcsh+mvTAY9ufhSQYWqjTzl2
2SpR+hfEpP2bVSf2PtULeTCCWdEoc98EEAsyB1rB5Ssaf/u0zwTZKYijxGFZvKMc
h1086m387gsrgXuothoF5qxySbTNfRIaF5p9F2+kDbFXtp7NH0RRy7Ey+JhvK1cZ
vIl27MykJSxP2n9HnZON6Ly/z4OcdF78OF+x6+8sA8MHfQxeRnFY+pxw1uUCRJkf
PYWi/z3lbOKFCQHXCWrH
=x1h4
-----END PGP SIGNATURE-----

--fo/b2PYVqg2cQvBK--
