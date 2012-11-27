Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2K0Th2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:37:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35136 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab2K0Th2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:37:28 -0500
Date: Tue, 27 Nov 2012 19:37:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Message-ID: <20121127193726.GI4468@opensource.wolfsonmicro.com>
References: <20121123081307.GA4529@opensource.wolfsonmicro.com>
 <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 10:12:13AM +0100, Lothar Wa=DFmann wrote:
> Due to a broken make rule, sound/soc/fsl/imx-pcm-dma.c or
> sound/soc/fsl/imx-pcm-fiq.c (whatever is selected via Kconfig) will
> not be compiled into imx-pcm.o when building as module, i.e.:
> CONFIG_SND_SOC_IMX_PCM=3Dm
> CONFIG_SND_SOC_IMX_PCM_DMA=3Dm
> resulting in a non-functional sound driver.

Sorry, replied to the wrong version here - I did apply v3.

--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtRZuAAoJELSic+t+oim9cOoQAJLonLXJNbz5SYsX9h/WPLo6
ZOIWbhUg5oV0it1PgFk6NLHNQXcTrxon8/Q7s+9dL5EVzHTKPx+cxGQBWlOCxd9/
M89rH+zpWbhMZEmYzfgu6i2wY1+8r1VeGCM7zB6yQ+Yv3rIZn7gDKNFiYL8ZHxGq
fXqu6Id1m0meRxPxcdr/rSZc+5DjWQz4zU3jGmZKAvEu1kMFKDvtqzCZsLW1n26P
fv+CS8dyEPRdcJn6r1VO3JwEKmgaR2nQhRJQq64TrcWieEhTy3sl7dyxQ2Og+sYU
f8ZBziFFyYiV2AZmjuFhZj+FO02+DeUWdEPmohfXxJNvpQzBVMDQACDu/bd6Qj4A
P9zVoxsDXduhfd7zXyvcuKJW5aznbYFxqd0JIIsAB3+wLmLOuw9kplJ8cmEoRaXl
oVEz2l9C97197bxHDMnmoXTxZByNv+t3E8QWKYD94eEZStPnKui2uob99KKFEaaf
8/9GFnsGt/DzoUy5PWIcfXbZT04sm+DaSoFSj9RZElkhY8ibwhaoO+qJAAB01gYo
egO4YrDMPz9QbXf2JJSWgZ5HFFCDP1+W9zfOvMzS9fd8OGrBF+Fz/sSeYEeb+RNP
xKMvnX8EoYbBaFvKUQzcftvOjUXkVAYXu27LWquGnt6EHckgnpU/Qrut7W2QzfF/
j+VaX/Dgi84fAJg+3eaY
=fbnX
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
