Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2HAJ4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:56:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2HAJ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:56:33 -0400
Date: Wed, 1 Aug 2012 11:56:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: add devm_pwm_get() and devm_pwm_put()
Message-ID: <20120801095628.GA30253@avionic-0098.adnet.avionic-design.de>
References: <1343806629-14397-1-git-send-email-acourbot@nvidia.com>
 <20120801080453.GJ29673@avionic-0098.adnet.avionic-design.de>
 <5018E62C.7010908@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <5018E62C.7010908@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iOomSU9ukHxdQhymBqgcJDNIANHoZLyyszmp5JE16NK
 XSyXTYif/lgib6u9hrQCOHJSWCZS1NHdf/kjfOxgA0TB64lMFq
 AyLRCuxb+cu4z/jdCZDOJMjXDJkTUKdHrQyHZnj0hY1YMjdnAr
 YNYtBPhDxMUdQzILf63Erl8o0y4NM40F4qzob0uG5jMk+WOJqE
 ZCP9dq0+OHVA5QdYBBCB46+BlUOD3+kMXfevFuZwGqvYitskzI
 1C/Bye1UM1+POG4caHXkqG/SJeJ57k77SAanx5cAFbKhZWcdll
 kysQ8c1dYRg66JfBCYsVkijg5iQtu6om1aBC0mVRx9dtV93RZK
 /ZJEQjBfq6vN54AuuAvsM0+ZaD+DgosAtkaSP0WR6FvPrM8f/Q
 7lMrFUBjkerApsN5uJGlgYiHcwBpvO7S0xuuKwl/gBgewAwE3B
 FIYOP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 05:17:48PM +0900, Alex Courbot wrote:
> On Wed 01 Aug 2012 05:04:53 PM JST, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Aug 01, 2012 at 04:37:09PM +0900, Alexandre Courbot wrote:
> >>+/**
> >>+ * devm_pwm_get() - Resource managed pwm_get()
> >
> >This is missing parameter descriptions here.
>=20
> This is because the documentation for this function just refers to
> pwm_get(), and the parameters are the same. I think it's better to
> avoid duplicating documentation as much as possible as this makes
> two maintenance points instead of one.

devm_pwm_get() and devm_pwm_put() aren't very likely to change. The
problem is that they are public APIs and people could be running
kerneldoc over the files to have documentation generated and the
parameters would be missing in this case. We really don't have a lot of
these public functions, but those that are should be properly
documented.

Thierry

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGP1MAAoJEN0jrNd/PrOhHFAP+wVkFF0QGZUWZZJ44uMukICl
/8gzCIY8LDl7BuGLTYGJ/rjkhwlM+vbpAMXm4Vb0+0vBAfoCa4nALDRgDp4iPlLx
iRltyQRYGN5ZM+HsWnKT5tkelGQWUvTv1tIDFPAwnWOw7ZbptmeIPpA8+ScXTrZy
PQdoO/zkgGg54fx89QaK5zAyzoGCSdH4X7Ohzz+DXEby8Dc7A49kVXtsu5Nzkg3X
XjS6T396DRmK4XEeaId6tDtliLboY++2DZFukfQjTZ9eLXY9G+6QaNAXRdfIb3MI
BP7ddOw44bQMUPVB60dFnF3Dpw7FG5sjJpImv/d73QJXffcMREPG7V4BIuzc4W1f
PTWF1G6j/4QoUS2OrdLzswf2bnOrtMTBKZ63Qr6wHbWtpT8Wj5zOs0FgZpjJc+Ft
CQUJJKOdsoJY4iYqfG6kuY00H5rEB61HzDhV9FJBP5491/F5bS+iii3cl3DziAMf
KUBdzGQw6t4dnnBHFrfdoyLLu4biAPUgsHpitAYe4qcBgH/uTtDa34TbiuOvs/Ih
2RIiu9b4ptvk9+obedJllPhUTXT/+KIPj3BlzavVlTm4I2ldgxor8qpgqtCgpxKj
/mgpafRBghVgQ0HvvqURm3mp/YngAf68vekFTJ3dUACfVdS8NdkNZnDo1MYCnK1r
bgKbijdOnxAh281TWeHa
=qTU1
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
