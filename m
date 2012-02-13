Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2BMQd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:33:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091Ab2BMQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:33:26 -0500
Date: Mon, 13 Feb 2012 08:33:20 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, shawn.guo@linaro.org, artem.bityutskiy@intel.com,
        w.sang@pengutronix.de, LW@KARO-electronics.de, lrg@ti.com,
        cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mxs-dma : move the mxs dma.h to a more common
 place
Message-ID: <20120213163319.GC3494@opensource.wolfsonmicro.com>
References: <1329110756-14434-1-git-send-email-b32955@freescale.com>
 <1329110756-14434-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <1329110756-14434-2-git-send-email-b32955@freescale.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 01:25:55PM +0800, Huang Shijie wrote:
> Move the header to a more common place.
> The mxs dma engine is not only used in mx23/mx28, but also used
> in mx50/mx6q.  It will also be used in the future chips.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOTs+AAoJEBus8iNuMP3dshgP/0oxrWuqvejvhp1kOy6FWPbK
i2VdoFTU7ordzqj4U2osLcPKSx4vOgbEM+AQLmsebA7n37t17pkA0h2GtdIFYZrZ
SNJc4sDI6RJYL7E17yE+LzoBwQcaTp1yZxY6oGIfYzcOfZrROOCtVMfyTGt2cB4+
Lwiarl5HU+frDb/rQ7KsN5qlvKW5/w2xgXIl6EtH63h61nyw9PBVo/8mj8Rhb6Tw
tQJMmnQpmtbXdpMSVtEWctz3LP+tMUJhY9BIdyIifZ9BmBPaPq3phpj0nid7Zi+l
zvqjgV708j1aUpZkScRqLMLeAev5vUW4j/AZ0/jcCyt1RYw3k+/3Y2A/kmPF71M5
cZdrIBjQYwkxYEeM6LeLlkOh28iqXi1cIh/3AO3hQJxezRvqyyFHfNQu/unVLbvZ
BpZUcDVo8Sie2DeskRha+nBO2hqmy4SpUqRLLOWLLjCfixu1BQ8Y5XshEnHjPpyq
oUI0iK17OSpDcKC1DezOm4x/St/pTn3GWYNYaO7aiMLu9STAQmPZwLU9D6Rf673B
idmEdXQq0Xk0Fh38Hu4EzVavYsb1AZbdTYG3KZWgHM0GR70QSXUv9R0kYobt8Dqc
HLYb9/sSrl5BlT/kIuP3QNY/ZEHrf6w94fVMTk4xgxYSluY6EcVMz+YHpXGU0u+A
JHvRGx6M7t4h+hYTLQJe
=EySv
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
