Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2DZLmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:42:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715Ab2DZLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:42:34 -0400
Date: Thu, 26 Apr 2012 12:42:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Default Kconfig state for hw_random drivers
Message-ID: <20120426114229.GG3207@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="APlYHCtpeOhspHkB"
Content-Disposition: inline
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--APlYHCtpeOhspHkB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

An Atmel hw_random driver just appeared in -next.  Since it's just a
regular platform device it has no dependencies on any particular
platform so following the behaviour of other hw_random drivers it's set
to default enabled if hw_random is enabled, even on non-Atmel platforms.

This doesn't feel like the right thing to do - it'd mean that most of
the embedded RNGs would end up getting enabled by default which probably
isn't what we want.

--APlYHCtpeOhspHkB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmTQlAAoJEBus8iNuMP3dnXkQAJ0fiWQ4q5EaIlcErYqIOP1/
/rzf+XS6zVdRMItdngYtDbZ9vtT1603qgQWaxS17rQzdSfZpME1pp2KTNqvdjL2H
SVXFsooROI4pniWlbipbZ/fv/EPMUtxcd86NV9E/dwHy30Dzrp4SLeImYhn2vaP8
yYdXUvRQ8wOsSTJxRd8FrGdI5BNEbLAuL8s4Y2LVF+XqDfIB+5GzNS7xkwxQtWYv
zTRMeIDVyJ+A7d2rqHvLP85Jv81USoGXxbDY7JkQmcTd8v5t7YLKHuMS7x6rTbRm
ypINNwZ5X8uRrDPStnBTiwhRXCMLPGHJ9mpt+K97352iDdFt3Ubk6gNDRligMoWG
lsfsRyo2CmAVzp+1lTob6Q6DnhL7rOIte1S8vpKEmS1rZgnmagQg8Qf29pkdTN/4
KqShrQzGIjYC5Iw7V9crljcYLp/58N9hiED+3aqg8zS0vWHhND7xsENhxMnX08HD
4dFcFAdNT8li5pyqOyMik+v7IMBSKXDMCQv7UVVKl/bn2ebCE2pilchkpxlwKFmF
JDXVmCw5tlLBDD7utJm0SUzQamHl8NoasWTSie5eMQ5mM5nibUwelQm5UrFkArv7
s0mHWbqENq60q/w3tRgFgAAjCr147VZuNRhvsk/LpE2zuu8F0j23lThPdDniZoW+
bOrnCj8GM04ADOTbfXXd
=jnX8
-----END PGP SIGNATURE-----

--APlYHCtpeOhspHkB--
