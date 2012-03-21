Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2CUIva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:51:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58451 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2CUIv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:51:28 -0400
Date: Wed, 21 Mar 2012 08:51:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add TPS65090 regulator driver
Message-ID: <20120321085125.GA10935@opensource.wolfsonmicro.com>
References: <1332315326-11354-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1332315326-11354-1-git-send-email-vbyravarasu@nvidia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 01:05:26PM +0530, Venu Byravarasu wrote:

> @@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
>  obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
>  obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
>  obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
> +obj-$(CONFIG_REGULATOR_TPS65090) += tps65090-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o

This won't apply against current -next...

> +       rdev = regulator_register(&ri->desc, &pdev->dev,
> +                               &tps_pdata->regulator, ri);

...and won't build either.

Always submit against current development versions of the kernel.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaZaGAAoJEBus8iNuMP3d6GUQAJud/vSrVOjPFAkr+yoXubmn
J8uw66APlboIgm4Zri/+j0rf3Nd8gElcQODC1nyYXG+a4jdlB9mgikRkAfEPABS9
VfIAt/bSwKFBAGGoIC4vRi21aeOIQ2rpmmnI7f2iN7w3n5htNkJXoCPrw/hPEZNx
BFGBhoJQx52XpeANP6/Gf4+jLFAA6WKn+vmeyVNyCO5R8AVB4WnqsU4WpKZ/d+LA
kOzovDpKsR/GiswpPMRQTjopt6yvLgJuKZeE2WGojmMVoGsz0NjK5chtvc7kP5ri
qHOMg6j3lpa3LktqV6gwEvy95WQCnDfWu6GuiWj7uE10s2Lnk8+DutuPpIGKxJvE
3S4YM5V9k4eFfP3n+P4dmlqfoBBFMV5p5nyUAv40vB6MbFhKMpYUtn6z8FwzRiEw
s47wLFLX4g/da6F0eC/yks3mm+LioGDgPcQzF0GFFmpYVu2Qgs/ZSZPSm5EK4aSP
Y0VNAUnbBeDox3bHfV+ExFqa/ymPd7i26b8fRlmZf3bguS/Noy6WuEvRUzGNeTWN
FSklkbqa53IntiYP3NFDG4wDVJ4dwI8Y/TYvT+LNafY3vk3VRYeXxdrKEgUS/hMF
rGki7QjlN2pQIQ+/uIvlTCCMZEu1qapfyLtGgqsukl2jxI480Q7CpOvMZFT2Jyn9
sudqoZkoLmrladsjOh5e
=HVyC
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
