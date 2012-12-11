Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2LKMoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:44:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38896 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173Ab2LKMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:44:52 -0500
Date: Tue, 11 Dec 2012 21:44:47 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Fix logic to determinate if regulator
 can change voltage
Message-ID: <20121211124446.GG9097@opensource.wolfsonmicro.com>
References: <1355229397.6766.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
Content-Disposition: inline
In-Reply-To: <1355229397.6766.2.camel@phoenix>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 11, 2012 at 08:36:37PM +0800, Axel Lin wrote:
> Having a linear_min_sel setting means the first linear_min_sel selectors are
> invalid. We need to subtract linear_min_sel when use n_voltages to determinate
> if regulator can change voltage.

Applied, thanks.

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQxyqwAAoJELSic+t+oim9h8sP/0LCq5TxL0+YWqYRaPzeDzT5
seTDyk5uFDCpdyIkFoD35QneBqv8OjyyXGjv5pBUHgVFE/mqF9Y6Z8e0YYXGiDXu
KpV1/0NJJvsFtbhWipE005ATxn0fVbXe6lEJRpK/FeT6PyvNci3jwzz7hgzEYIdD
+XuipAFMbGidzZoAUMGvSXn0bz8E8mkzwujTSzKSvvDrQut4tJ4jPgAvSb0J4LvQ
Jjphzk4r4jbCP6WN5MJUMfGDSo/R8dolocgyUuNvoiSdbzKC6jbCmhLAsYoYsYh1
UXZ3rc53hdTpvJu0HrOeLmPb1m78xGNL4cY0mYqZccqFQHQja6Iu+XM7ifJOrt3G
vsrmSh3J+HhgaPztIqClSkxlF7BrDPPN86waT63/KuekJWIAsdnec5tTzG0ucio7
hQ2ixWpqERbaRJ1kiOtOKIQvHzjHj0r68cvfl8VvwUwm5nHj/9UHVLY4sm+OJKUV
6IdedboAO1SzMN22kUpjupyg+5qjFvfCMIqFkapps/j/QK2dtHC68ZJPBNhXuvaM
e2zfjrfh8e6tT0ffqto6jqXC+eN5nIZiyWLEJ7t+04MUmfViGTA/OvBGD22tqxPx
Of4D9Gu+lWJRS3/zyDfj923bR0cuLeOi7LuWVyUY8EO3B8JMW2wBb+gGHb+8gODV
ag2awRLxStjrfYrG6gpG
=tFFU
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
