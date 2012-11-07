Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KGJYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:24:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab2KGJYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:24:18 -0500
Date: Wed, 7 Nov 2012 10:24:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Qing Xu <qingx@marvell.com>
Cc: sameo@linux.intel.com, lrg@ti.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] mfd: max8925: support dt for regulator
Message-ID: <20121107092412.GF12323@opensource.wolfsonmicro.com>
References: <1352277710-16149-1-git-send-email-qingx@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFbHfjnMgUMsrGjO"
Content-Disposition: inline
In-Reply-To: <1352277710-16149-1-git-send-email-qingx@marvell.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oFbHfjnMgUMsrGjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 04:41:50PM +0800, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>=20
> Signed-off-by: Qing Xu <qingx@marvell.com>

Applied, thanks - I'm assuming that the documentation for this binding
is in the core MFD patch along with the bindings for the core?  It's
mandatory to have binding documentation for new bindings.

--oFbHfjnMgUMsrGjO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmiilAAoJELSic+t+oim9WYwP/1dixVwndsisR/4Kq0g4RY5R
aJi1V8jX+xij6kdvf5+DrCR4wpzF1gdB2nV58hkzLgevApLRIfzjz4xWZ7ZxbalF
8QNKsW2SGZlOOB5sQ+Hlj7XMxLiODV27Zy9dUZt+5ThdQlsmcckeNzqOym8UVfeX
SKH+/sMFMZehSWQNPtrpCJHcbLRTFmZliM0w/QtCSF9vXpq/ZYUOQm2z+F3OUwYh
nLo4tN79qm5LW0xv6oYlVrh19bg/DUn0WXMvSNzDpS4PxAB/WfazrpY/k1XxWbtf
5Ln35wUXtakzFbp4tTMC6DQk/cXzQwxgvY2finvDRqsjPQUeGKtv0hcOlcsmDsq4
t0XtgZ7SZ2hadQH4IJYfhaL5E3FwX4hnI4ktCKFt2xRDTKVWVvxYsQ76pYo19Ei2
w+dstd2rl421vCk3jl5FzWHEc7kTHwiQw66h8UOnVoY1N/1CLy0uyrfnyIRAFJSa
dbsnTV9ep5aqpBecI+piqVjHN/LklCSt+hh37Jpa/RiyTtGnnuwRUfAxlthVc1sb
aV59FjS3CGj0VLHN0lDTeFsY+yTrrM3qjtS4TlxXLAF48iuxCOcQWHacw5u8zVu/
MFOlM2vu4uNGZ7NlVprVtBV2qeSWrHOg+kS/nOpiTEXHYM9nzQrbcP0SnbvL/Dpu
n+751Dw7vhmlkDlObUVt
=Vmp9
-----END PGP SIGNATURE-----

--oFbHfjnMgUMsrGjO--
