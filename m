Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2CGTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:17:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44494 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759754Ab2CGTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:17:16 -0500
Date: Wed, 7 Mar 2012 19:17:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Message-ID: <20120307191713.GY3107@opensource.wolfsonmicro.com>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
 <20120307173157.GT3107@opensource.wolfsonmicro.com>
 <20120307173922.GB1130@pengutronix.de>
 <20120307174443.GV3107@opensource.wolfsonmicro.com>
 <4F57A419.9090501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9baxdNnpTjJ7oIU"
Content-Disposition: inline
In-Reply-To: <4F57A419.9090501@nvidia.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9baxdNnpTjJ7oIU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 11:38:25PM +0530, Laxman Dewangan wrote:
> The open drain support is already available from next-20120306.
> I was waiting for the change to be in tree before sending this patch.
> Hope I am not missing anything here.

Nobody should be merging -next into their trees, it's rebuilt every day
- you can only rely on things in Linus tree or things which have been
explicitly cross merged into other trees.  Otherwise the individual tree
won't build as it doesn't contain the patch you depend on which breaks
bisection.

--R9baxdNnpTjJ7oIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV7QzAAoJEBus8iNuMP3dWWcP/3M15e+6KI5UlaAPmqXVBjSZ
vz274qOw9B2s89BneHFPJPOX4jVXmdcgDLqrJrmzyXyLuWfxSpjLc3TzQd8MCVr8
NdgBpEsfLPlWsKgcX+3CfZyRUoEKG5Jm327IowWgo5ioGZe7ys6PccDfiK2aXY1D
Eo5zYN1HNIeGRwEnsAJYELFFUeBN7EAY6Z+rnMN/Trxb4tpObnI6SbIfvyyDyHeo
EiEN1QlN5eHg8IAWPmN9WAbuSOmJR7yV8ySugJDcrT6WKPa1YoJY1RnnpcI8iZY3
9YJfGrurujsHRmG6OEJQ6FxA3IwrpH1WtdGhb4lnT9KNN8BJ8VCl0+EjYznVWzRv
VGajH7G0YYcZJ+UcB/882aaRxMprGMmcANXb/pjeA5VfuplvydyB/+VG2kPKQ0zk
kIRaaK8K0SfyJOW8x8j6mL007tBd8TqbVfPPe71zGX/0Na0Ok/uXUQfZlNQNeZsB
aDwQZwRKteVvb9GiaVi0TfenErMckb5OWsaSYBoOCU/mk0QSsfuEcBs+jFkBj8jx
giESiEXvTv21bjEac2x8CAY0/vgVimBKpfN4dcfGvyLrg+J21Ce6g/aN6UKIfrZW
kWbD0UljFBvhqxdCW2suVinzHXst/y9DmlMqtM46V3f8DgyziK1hypcX8m5FVHgE
3qoditlhcG69JHvwPaRa
=m3ly
-----END PGP SIGNATURE-----

--R9baxdNnpTjJ7oIU--
