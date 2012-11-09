Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2KIWDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:03:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2KIWDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:03:35 -0500
Date: Fri, 9 Nov 2012 23:03:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: harmony: Add ADT7641 temperature sensor
Message-ID: <20121109220330.GA31801@avionic-0098.mockup.avionic-design.de>
References: <1352498323-31845-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1352498323-31845-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:b2wQN2wuP0x9AqF+11wDSUCx/+rflDJVfEr8Vvrbdvp
 f74TvtF4RsEs3Lf41kCeKT/JQ4XOQaRs2RsF4+Q2WibFpXjer5
 ImVVs3675K+r7fvf9A6JNTCrswPBUAoSC8T9lZ+7codfN7ecPO
 7pUQ+LUVC6ZjZjcfhBFkrw28o0Sd3M6IOksxn1J+za1Nvr3RcZ
 jWv896FGC3hx+Wc7TeQCILxrWVkFnZL2lo9bHCEkvAoKQEprAn
 Ybe4MYtphonH4kvzOa6M2LkNph8bL3ZI+ltyo73dHlL/+/zKhz
 kg6daZMI7SW+9R56DnCqCYk5K6l0hPiujK1krEGYdNeul+4g/a
 nuUMLZcQRIp/ZoVPZVv+VrdH35IOUduvLpoqFLWGIHufISjBEq
 LDeIDbje7BBIkZ9WkO+VzAi/UXiy50JpPU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:58:43PM +0100, Thierry Reding wrote:
> The Harmony board has an Analog Devices ADT7461 temperature sensor
> connected to the DVC bus. It can be used to monitor the ambient (local)
> and on-die (remote) temperatures.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

I forgot to add you Tested-by on this patch. Can you add it when you
apply or do you want me to resend?

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnX2yAAoJEN0jrNd/PrOhBzAP/ifti4B15Dny7V/HByxedkE8
DeoFCQacJ57YbwV0UJnTdks0a6aaNyCL9AHioPtiL9sG2huCDC6DO4r6aJz/TlYw
9ANOSVAhny8+qvFOYS/wzHkk1h5bc+Uk3qiO4QpaFHNYwwz03IbrXxTiwjK/U27D
SGD5+sWSflAZPGhuFqmaey9eO/evdvH0TdmkbwLCeLgKEdPWSb0eioYG1DDim7IA
pLb/G/5fBxQjj58JFbQoFO+WTj84YhrhupuJpn7+Ov50zMd139Z5j4/QSE4Kc/Wj
xJaN5cX4VSQlTIc70EKb8Z0kX3a7h6bi2FYyDw6LzaqBi3lFOeSFecKf998cvdkG
mFxkdZgKOZ6QRImfMZhLu81B2wLk/MMNvXVFCy5l0ePZRNnhLUjCqM7vEkjA2Ns6
RogN4oaHXgYmeaw6vdAwvtSOTb7gCBl98qgFfQ8NshcdHLLVRzYpmWi6P2GWIZW8
E48q3EFfBWN37gXp/1U0coOib10EK/zlsR40CsOx6pvJphpaSCcJv2hZ9tOcMA17
L13SxKTI1HwUpHVUFwDGOoSU3sq3szYwy2UfHzpqVv3Q7ep12Y2efrF5uxDbfg2p
JGljBzgHaBQ2tK3OeCVdvyEWBcBpYWsEo1b0IAA/9zGAYTrfQDOdhIS/2AeuND7K
e6wDKsNDHR8lqd4C4p86
=H/Xr
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
