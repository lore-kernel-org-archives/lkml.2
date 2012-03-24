Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2CXA4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:56:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305Ab2CXA4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:56:44 -0400
Date: Sat, 24 Mar 2012 00:56:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: rbtree: Fix register default look-up in sync
Message-ID: <20120324005640.GC3190@opensource.wolfsonmicro.com>
References: <1332497097-17846-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <1332497097-17846-1-git-send-email-lars@metafoo.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 23, 2012 at 11:04:57AM +0100, Lars-Peter Clausen wrote:
> The code currently passes the register offset in the current block to
> regcache_lookup_reg. This works fine as long as there is only one block a=
nd with
> base register of 0, but in all other cases it will look-up the default fo=
r a
> wrong register, which can cause unnecessary register writes. This patch f=
ixes
> it by passing the actual register number to regcache_lookup_reg.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: <stable@vger.kernel.org>

Good catch - I'm fairly surprised nobody (including me) noticed it over
the couple of kernel releases it's been there.  Will apply once we've
got an -rc1.

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPbRvBAAoJEBus8iNuMP3dERUP/1LzvtHRFx0gD9s3Qn0sfiYL
weUyyzq/kXShVl1mbkTKyBbg0j8eThkqBOwScio56SUhOhJVW1H7wNzf+Sgwygjx
x31339QGX4o77UeC93ziKfvGMaq1NuUwrfzWAwLv+0hunV4idBcb3eB2QO/N9+/E
FE+FKO4VYcc2ngrCyTRQFsaP2jy0yvT+09k1/7urY9kyqG6nvFPx4wcFFGfZMKMa
aoOlxZJmZTJqcpXPIkYiGVgPuSw7imo3iWqVGNNkzvoyLzEZ1yrUg8VsMmWrBhxn
eqpKzeOx+F1J7GvmdA81u6/HtTSF+b04tznkm2Vr7c9bP3U4axPGVdVQFa1T+Oi5
+BUeJ2pWrx2Hf5cIMmPqzu2pSDzWQI5wvupc6QaT/loF5RURLcxlatmwstfdq5NB
CTqL1v1cjdvmsKzMuFDmAvzLNrOfwM4QS46Ive6LxfyUKlrPuUSx59t3Lib8mgeX
H+my7rtUdVnxRiicgO5iPz76QFcwtmkCnwMO8n793R5BzioF4lmgIJUn/LspCpaC
JDkkCCzTj96G98wlui9Iyx3Q5ImvgJkH3JZcv3fGCFzf3Fg1OcgxaD1TPYFoZImi
KuRnHmyYPDGBOXEblhr9c2OVVyaKn6lZlM9BCalpvLz2zAvitUYgf7mYCVU2qpcJ
asBSKcLGCBRuSUtszzRo
=H9TS
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
