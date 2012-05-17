Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411Ab2EQMMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:12:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57317 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab2EQMMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:12:52 -0400
Message-ID: <1337256768.2564.7.camel@koala>
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Thu, 17 May 2012 15:12:48 +0300
In-Reply-To: <1337201522-86521-2-git-send-email-richard@nod.at>
References: <1337201522-86521-1-git-send-email-richard@nod.at>
	 <1337201522-86521-2-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-usE+qSLH5LsVUpYCnsTY"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-usE+qSLH5LsVUpYCnsTY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 22:51 +0200, Richard Weinberger wrote:
> The fastmap mechanism needs to read the next sequence nummber
> directly.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

Created a "fastmap_v6" branch and put this stuff there.

--=20
Best Regards,
Artem Bityutskiy

--=-usE+qSLH5LsVUpYCnsTY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtOtAAAoJECmIfjd9wqK01DoP/3EsIyNWbH9Zl4QeRaMU1nxX
mKbudpc+rj8n15kbu5eBgkYiciIks0Gso03sga+2Pdh1N2Iu9dw20n6+GSZs8HfS
GQ460VdTaXb5TDFcDn9ho195fkV4rZPlbc8s+BUKMGW4e4IL8B7zSdVG6clh2Hkc
dnQYC1RjoDwyg86XxyL87qZEf5t9QYGkZTUVsrjzk149u6zjqjBTum2G8Xtvusur
ZIbV+zpr4Zj6ljQWL4CVJxAZHaNgQN4OVGYBH29yCvgY5UKM5ophynVYScLygx7P
pkrnu8zqBi927E9vTbFujCRl+K/C4w0Yil7dKn41GSrGLzOnlKskm2WgVM1fR2cn
TJSoxVwpcaJq5yVhOyOs1nKcVkAzMT4cfDkJWK2Ha8DZm80F7vnVpFRu6Lcn/svx
2zCqwKHOhYMdqlGCWEZG7A2z+sJh72Kwimrafl0tpsAlqBfCJadmZVGEqDZo0le4
3R6a26x+hVZ7TSwVoqtWUoRAX9cWTHHrxi17aROpNMCvNykp9ivJSLJn9n1Qieav
NrnGwbs+E5HjFk5r8/0RrFxiniLV2MceSAo3CdDbwI7aZxNVRto+PyifNdOyVyWJ
jyxNBDnFTOqvEnvFX5GcK4ff9jl+WzdcA/cmj8sRQGXmu6nxJabM3tcEWP+pAhiW
TCVYN+7dpruEI5GBhtgN
=7o/o
-----END PGP SIGNATURE-----

--=-usE+qSLH5LsVUpYCnsTY--

