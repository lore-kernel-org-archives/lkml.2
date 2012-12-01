Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2LAWjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 17:39:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2LAWjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 17:39:19 -0500
Date: Sat, 1 Dec 2012 23:39:13 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Lucas Stach <dev@lynxeye.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121201223913.GA19755@avionic-0098.adnet.avionic-design.de>
References: <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B7AB93.5060207@wwwdotorg.org>
 <1354265429.1479.187.camel@tellur>
 <50B9EDA9.2000500@nvidia.com>
 <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>
 <50BA3668.1010504@nvidia.com>
 <1354383291.1503.25.camel@tellur>
 <50BA5AB2.8000604@nvidia.com>
 <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZzsBgQYoJpNVomNDwfX/+OUOFJol03453H/Bil1iYwf
 PRiwe1tAYF4Oap1daVmN4aOlNOXNkVRhVzO/7ifne8Yit1otOo
 8SEGookWFH3TID5KNfuc6SvTK9PwG7n4VY+SFP023qwltp8tu6
 kZ5z6jl1ft6m4W6QyHN+HZZRpFOz+oxy1YtDfRIke2oMroACqt
 RXa/gyzAYvFxbfU2MbZGAXLHcMZS99s5oKidmdK6yhvmtkw5xh
 vyjSeDBwC9aqPDf5NuVXP/lwhuNW/IMmjvxjDNYOwVaUyyXbo1
 oixj35vM6ncfeN6FuAckcqlfI3eOU+58auVG5hd+Os6qCGB8pw
 oNGVXkG39rnqcrKyF466Xo/Fj4EjHaNrLLBpzHPwr0tfspCnxx
 hU9JASaLb719aXQO9Hd85zgmE7XRBwHIe4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 02, 2012 at 07:42:06AM +1000, Dave Airlie wrote:
> Guys I think you guys might be overthniking things here.
>=20
> I know you have some sort of upstream/downstream split, but really in
> the upstream kernel, we don't care about that, so don't make it our
> problem.
>=20
> There is no need for any sort of stable API between host1x and the sub
> drivers, we change APIs in the kernel the whole time it isn't a
> problem.

Point taken. I was primarily concerned about needless churn during early
development. But given the latest discussions it has become clear that
there's no need to rush things and therefore we should be able to
resolve any potential issues that could result in churn before the first
patches are merged.

> You can put the code where you want, maybe just under drivers/gpu
> instead of drivers/video or drivers/gpu/drm, just make sure you have a
> path for it into the kernel.

drivers/gpu/host1x sounds like a good location to me. Does that still go
in via your tree?

Thierry

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuocRAAoJEN0jrNd/PrOh14EP/i4hoUlx2RBFcDm7eBa3UiPD
Uj4rjJXxS3oJOC5PJezwh8S55dzIKEGLI9Ync1Pxib6BdSnCwrM+Z5KA8VfuCML8
ijXhRDGPR3UE6C5tq4xz3cHaQ78Db+5cgCMU2lLWpNVRs87xtvCOis70ryoWjXGv
rqG5ZY59Xbmd3Gndl5QAtHJ4hNKTLKl/RYSa0l7xeQ4UkurrxJLTj0avH7KYpJUM
okZT221H2DqaEpmXhtBm9XMBaIAF7ws/3AnGpWHQW9Nfr12mhHHZQc+lPnZ05d1/
WqCExe+KGq2NMvxYb5JHHDPLIYkD5PbOniWGG19SB3zS+zI74aYY7MnJ75d47Frk
dPn0p129TXDUA1c31IWH0f8c85sq1fRCuH2Vf90cB7/oeEu0z6h978fqqkLJ48z+
qGKRTlW8B2tv10ccIqC0oG6SO+frA03Wn4eRf9n9QgLUdoIETpdfZN1TKpyVgbvd
gt5MG+sqeXZfC49BqVIBE6WH7lBW+NmBoGKqOKnpKIrgLA5dvaU64B67IPdNDkfh
PNCipQ0sjrHwmYPPw8NRdE1CRvdqoDZz8EkBKHnn0dA8zKEn4UjlrhqzdZjt5UGX
25/fFlG14WblOTbADz5eLwQHkg61d8zOvmq7i/moV22WbfZcR/9vGTwxFwl76NFI
PXt19oMIjZQ7uJVUTbkD
=iGGt
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
