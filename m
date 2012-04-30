Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2D3WbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:31:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45550 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795Ab2D3WbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:31:24 -0400
Date: Mon, 30 Apr 2012 23:31:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Anthony.Olech@diasemi.com
Subject: Re: [PATCH] Regmap: Converts group operation into single read write
 operations
Message-ID: <20120430223121.GB5604@opensource.wolfsonmicro.com>
References: <1335767746.9546.15.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <1335767746.9546.15.camel@dhruva>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 30, 2012 at 12:05:46PM +0530, Ashish Jangam wrote:
> Some devices does not support bulk read and write operations, for them
> we have series of single write and read operations.
>=20
> Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Also, I'm assuming that there's joint authorship on this one?  The order
your signoffs are listed in I'd expect Anthony was the author...

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnxKjAAoJEBus8iNuMP3d+30P/iynlL5mG55DLMPDoVivkOg1
IGR3Jy2XdG6x9YeQ3ZcQiZQ3DeZbikufM8NZ6YvGVK2D0BlvX1xkc1sSy7ldm3Fn
KO3MS4X1g/Vgj/yWiToCsKM5VBi0fuWb24QuvEVFF5M+BUuwB/tP6FK8hpy0XOoK
SoNRG1SU3GaI0CdjiQuDZ/FBr8Wvs2gfK5iO6U5YMsYbZ5lCWHCdcT7IzPuYzUF2
MtJveKVYzhJYyDeXOt+a2nx3oWqjYVFjAlVD77EzH+g58fePfWgCE7w3MN6k4F7X
WF35gYve21UvXmIgqSBKnEvz+kOzWGnd61iax0eEoJosJt7qd/runHqAqnm5bPk+
jbvbu1BbTQw5jbZ1D2uP7QO4GTQIsiovPQhZ669xfUU4uQ+7bEZlVxtpqWGnXz1T
Vzmskqdrl8bigEhnNCvfxGpt8IusTJg/3u2hUNI2ysgfISsTGf/GzIIw2xDaIjam
3Z4sEBo9+kvO9Z1TOfhEHQdwzu55/1DgrS+Ed2Z74HxiFRIq59ltDhDeYsYPw0hw
SuQnXDXXWh7RslI3jhQyKbqpz7q9eTsvJzUQRnlPfNYG8ivPaf0ftMgpE4dcP35J
+bYSTUbRJbuEpaRL/WpUf8TX5HgszgOnwE8XEdrBZhNdVUCqOSemd2dzezks7lok
n9gRN5mnzhWECAOLJrKH
=7/d2
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
