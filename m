Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2DPSro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:47:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39144 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab2DPSrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:47:43 -0400
Date: Mon, 16 Apr 2012 19:47:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v4 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20120416184739.GG3219@opensource.wolfsonmicro.com>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
 <1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1XWsVB21DFCvn2e8"
Content-Disposition: inline
In-Reply-To: <1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1XWsVB21DFCvn2e8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 24, 2012 at 03:19:49PM +0530, Thomas Abraham wrote:
> Add irq domain support for max8997 interrupts. The reverse mapping method
> used is linear mapping since the sub-drivers of max8997 such as regulator
> and charger drivers can use the max8997 irq_domain to get the linux irq
> number for max8997 interrupts. All uses of irq_base in platform data and
> max8997 driver private data are removed.

Applied, thanks.

--1XWsVB21DFCvn2e8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPjGlEAAoJEBus8iNuMP3dCfQP/2awbnbc3dYnm7DJ/TjQs3HM
wPtJshUps7WW4FBfl8mHXDPheNhA277rjAPyuGfKPeKEH3CkmuXYHTvimNqkycsR
FP77REVa5UQmHXPhokRhl7DfzBlXxNdqgOfa1L365cOobWXnGpuLBp1m6/AROKM2
AVaf4juy1fT/LhisUSYmz1WMCvcNqLb4hfC+CkUSSYLWJmqayrcrnIllFEudMK+1
ewxrWAkko8YN0NS2psxcN3ijfuffPMXESUV1P+ARek6u10tk+18AkLUJ6ZDKEnC1
Ff2rgH4/XhGOimxfZUDsPPZNdeGxkw4VvaVtOK55S/e9zWKJ4lxARwYrzRMrx2pt
QdrjFYZbIxxg5C2VC18fJuIfBA3/WGboeHc6EoeRd3bXMLDgNlaezcvCs4NOkrEF
EysXY8pKT3VWMmAGabQOTHq20DqCBn5ICmeXpt7S4iJy3fc72xrcH8Vsu0LjSL9c
sUGj3Gh7Z4ldRltT4bHPoDjdKJ2Vyk6Ki58tLz3e3oxDdUOK1xrc3GJbtYsqV7sM
o+b42//qzdgT0L0emtLdw+9c1mIXjaWIy04r8qC9/ALDCb4WkeJAvMEmtHe4gcH2
5sX2ifokwVJvJCvJkWHkRypCcaxkMBN/SKf1bKiXVyx4RdVVZ060FSi7o/Jdq2Ur
Fpfn01sSvXHu53eDfog+
=+gaP
-----END PGP SIGNATURE-----

--1XWsVB21DFCvn2e8--
