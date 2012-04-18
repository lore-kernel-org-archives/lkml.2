Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2DRQpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:45:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48864 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab2DRQpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:45:20 -0400
Date: Wed, 18 Apr 2012 17:45:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v5 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20120418164501.GC3099@opensource.wolfsonmicro.com>
References: <1334741463-25058-1-git-send-email-thomas.abraham@linaro.org>
 <1334741463-25058-2-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <1334741463-25058-2-git-send-email-thomas.abraham@linaro.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 18, 2012 at 03:01:02PM +0530, Thomas Abraham wrote:

>  struct max8997_platform_data {
>  	/* IRQ */
> -	int irq_base;
>  	int ono;
>  	int wakeup;

This will *still* break the build.

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPju+FAAoJEBus8iNuMP3dySMP/06ZJIzfNHhd83iByW912sKr
lXAFiCQHcXUs3ARp+zdpqGeFGUgBaMJlNB4qBvfCeHL0tlfGLU8xetrbSZANXx+Y
aarluTnIZM1vuHtoPDbCxC5x3M+zRRVfVJPpMHPuGjStrrJ0M5skzVTpIo9/rPpM
qSuDRI1pACDM7KCO7x/UVVfW9cOQf8BpasME23rhS4isKOMvrbNkOxdMRTi3aeP5
IuYma3wszawRisbrA9Rh5tb835Momljic5EsWGh5XE420Z34xwVXuJSQlS+apuGq
cFc/NBYd/8C195w7O6WqTEEmLojWGD2EtabkuIF1bPPljqeJkG9WwiSbrl4y+/08
+vGly04TTKt9k6HLSkXDLrmprNMd90X7Msmf353cCoyPSkrck4tbJdEcsajhsglL
K9CUG9Or4dLo8Aid8CnxBcrQF8j14Y4Wv29aEqIK0H+/1DgB3Z+lcIq/5153utGL
4KJI9SKBw1PP8WOiFY9ZEqKKTrwo0jVsEOHBDViYija27Ecpnsil+4TSKFi4sETM
w6bnsSSdV63WHyvYw/kGpZGX3pp4uIK+jCczJ2KpcroOfZ+Y9GoAPd0v9qqRfN1B
rMlfw/ecNVOQLEkUi2/YshWqwLhMJZh8YbcIDgF1t9bVVnAbjgQ79oX/fhuWtQ/j
YT+zXAFP3hx8YbRldN8U
=VgHj
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
