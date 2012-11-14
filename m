Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2KNPd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:33:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2KNPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:33:55 -0500
Date: Wed, 14 Nov 2012 16:33:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121114153348.GA32208@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A357D3.9080002@nvidia.com>
 <20121114150125.GA11050@avionic-0098.mockup.avionic-design.de>
 <50A3B8DD.7010607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <50A3B8DD.7010607@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6pJfNbPwKQPmPQv2uBbNVck+faYPeyHMxFWCOt8Dsll
 Vb822MvywOBcqBTeWfV+tgx6rcny/RtKZYkshdnKcmYUsXjlrd
 Szl3dqHIyHEqPWEIY11oFSTAvefZxc7x12Z0MsjI21LzPEqsGL
 uMQGzwx1/ozyTGWEfoKiNtJ6brYCF5A8SZNEwzb9Yc/cvK1pmh
 KOT9jCwvRm5jbEq5fLQufW8QpFQ4b5CmFXujTVpQKUOh9Iaeje
 /W2U7EBEdIX1q4uFOLMdxRqrKSR5YDEON5viLSxAVgSRK9e+U+
 1NLNlgOh7ma4TTXzzoYYFfOLRThAh7PNxXEG+7aKXfsN7WZPqF
 XFSQ2mYq6k8oUqRRTIEZFrRDQMVtyGG1X6VUnRG43y+aFialkK
 SuYFhz0U60iSUYKU42Dg8Be8XWlvOW+PnS1rwaAxIVyS76QNI2
 AokiQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 05:29:33PM +0200, Terje Bergstr=C3=B6m wrote:
> On 14.11.2012 17:01, Thierry Reding wrote:
> > Funny. I just tested with this line removed and I also get the freeze.
> > With the line I don't get the freeze. Does the freeze only occur with
> > additional patches on top? If so I think we should keep the line in for
> > now because it is what most people have tested against and which has
> > proven to work. We can fix any remaining issues with host1x specific
> > things when actual patches emerge.
>=20
> I was running with 2D acceleration support added on top of your
> gitorious tree. It was the nvhost driver, which probes host1x, and
> initializes it. In middle of initialization (writing zeros to sync point
> registers), host1x stops responding.
>=20
> I agree, if removing the line causes regression, keep it and let's debug
> this issue later.
>=20
> It might be that we have a difference in bootloader. Does your
> bootloader enable display? U-Boot and fastboot do, and it might be that
> has an effect. They would need to initialize host1x clocks, and it might
> be that kernel initialization somehow clashes with bootloader's.

I use an upstream U-Boot version that performs no display initialization
on the board that I use. Perhaps that indeed causes your setup to work
properly but not mine.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo7ncAAoJEN0jrNd/PrOhVNoP/iAe087EDWMv4d3Mw3sM/vJ+
a1D9uNUsciaL+b5TSL3l1wT5oVsmAbtawW0l/jBSAaAPwk/PdBvxJTjJ4ZSXlCFp
HsTKUrj3MHkYdIO1MK9iH9oxeaU/A1jzC/pHKFB6G9jfsajwPm8MiSTGUIPf9Yha
HCWSpJABj8TBHFnM7HVO7lcWqFr8RfBO8csRpY5jiolgtuS+SqFlL2VEN5YGa8nJ
+y+kJpkzrnPon2UGcJbMRcwLNb8c+umoifNpjapuuruj1NXKDQj7nK7n4cEyG65L
TNl0eyr0F9akusaYiaDS/nV8N/iHYs+UJXdom1QAdnBc+OMg85ksiQUVC6ZDyN/Y
OgVnlwG6Lq0j6lDPogZ8dWZj0cjLGhbga+nyr7l4qFzOoXdztUFyhWHJ84FkjJI4
hdvbY17+OBUo32ronYzoCwgYu2t89CfT+WMAHJxxCHpalXWPRZ1+tdCevvtJwvvw
379lNJW05opCLt/geE2Pjd5+xYTBxCLMbYsEW7/38/CESyxHtEoXvvzV3NoLPldv
AhrLX8jgwNtY1OxFumKapX/OJEnvFBrhyUyL2gZWV5+XOcMf5UrwKR/kAQDqep1u
P/ZczhudKQQTQsVS54apJJMNjVpjxsdMq6DCwYDvGANupjZacBUwiIphdRsk4M2T
AVp5/q+3kuJaZsDpvb3s
=BmCj
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
