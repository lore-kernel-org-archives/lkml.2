Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2KWPGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:06:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KWPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:06:04 -0500
Date: Fri, 23 Nov 2012 16:05:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 1/3] pwm: Remove pwm-twl6030 driver
Message-ID: <20121123150548.GC16810@avionic-0098.adnet.avionic-design.de>
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com>
 <1353405382-9226-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <1353405382-9226-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:apCigSMC7rpw8TmTl7vy0wbU4RwtoDu3zsfJ+JU+mrA
 ne8QbQvxsz905HzffCLe9bnszCtSk1nAH9V5XkBGHlbZAiO27u
 tUjcuxEBrZJAiur+Z0wGEQ4nEqH2qhPnWU2C30Cq0tbbkHnyda
 s6TWT7JEEGztOwIIRn8sUubLBmWPMTejImgqzRKcPcgc5YLf5x
 OQ6VUVBV1+aVwd2Un2OOdZneOoesXcduRscmMLOlF/lX9ifb2Q
 BNWLdnGG1/Io1VTPrTbJigiIlWWPyWKoeXA0RA3XRZkC1X/USV
 ox93LVBVyBszLnm92AZWLDbKb1VwxeuNj7Mppt/1hsAW/+uR5V
 MYjaVPPImv/kiYM9A84krgKmN5SxTbMrkFPZGyNrVS3d9jH5zn
 6TInVH6sjnIqGjKXgBvPDuWBrXBLukJ3HpGEx+FusRN2akjomP
 Yar1k
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 10:56:20AM +0100, Peter Ujfalusi wrote:
> This driver only supported the Charging indicator LED.
> New set of drivers going to provide support for both PWMs and LEDs for tw=
l4030
> and twl6030 series of PMICs.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/pwm/Kconfig       |   9 ---
>  drivers/pwm/Makefile      |   1 -
>  drivers/pwm/pwm-twl6030.c | 184 ----------------------------------------=
------
>  3 files changed, 194 deletions(-)
>  delete mode 100644 drivers/pwm/pwm-twl6030.c

I think I'd rather see this patch as the last in the series to make sure
that no functionality is dropped across the series.

Thierry

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQr5DMAAoJEN0jrNd/PrOh3rYQAL37GU4RrcHvhhlTyRomyeZi
89Z9J/D7EJ2X/c639JRkXXuGZuZCLl1PNcxYPMsx42+rhaU15WDTFgs37MEdnAmo
tjB/ljq/pYHdThBaizb+ZJC9xUzVhdsyQJohmmD/K7OF7e84bVQ7GkD3ERCvSk7S
IxMpvkTH/nO5eM7F9GqthWkUqRBCspu+MuhzYfgv0QFkKs8BhzSKx0QH2GFr2bhn
KKcbDoHbLLROeSfOE7WT5QbF+emOs5QcXDhQvm/y44NwZsvUor8x2PA89Ht5aopK
WegFcaf3XSutoNBdrJRm3CKl2tIhsIKYmH4Wg2Rj54JtVhJKHzlH0wz5cL6D6A4v
IUV1KFOQNUDJOrCwYkKb8vkYyzC7WhuU0q90MWJptHLeBYYBdz72cSHvzgsfL2HZ
8v0D6ktwUUVOJvDGz0I6eqbGpds9dn7JMkUZwq9CNd65XAydteoDMclA7chYNPsR
LuL1qSjqLk0xDJEVPIlflR2k6Dk3uQoRTCOf8QCB+HoCbfrqEyhfYwtanr0vgafX
rn2ovXHDRTFrQ+ggMRpkGD1OCgekZuxNY+5C/yumsNgVQIjMCMJkPba8q3G5fI+g
4eYG3K51z2l0eCXfBaXA5Q+K0nWQq379wyQ1tStX6zG4SPWRPVeFFinl7ainQmrQ
4ZoN2a8JfZchAAeSG7VU
=eI/N
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
