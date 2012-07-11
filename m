Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2GKKPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:15:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32869 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab2GKKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:15:29 -0400
Date: Wed, 11 Jul 2012 11:15:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH RESEND] spi: tegra: use dmaengine based dma driver
Message-ID: <20120711101527.GE3938@opensource.wolfsonmicro.com>
References: <1341927517-4584-1-git-send-email-ldewangan@nvidia.com>
 <20120711095504.GD3938@opensource.wolfsonmicro.com>
 <4FFD4ECA.8090304@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <4FFD4ECA.8090304@nvidia.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 03:30:42PM +0530, Laxman Dewangan wrote:
> On Wednesday 11 July 2012 03:25 PM, Mark Brown wrote:

> >Is this any different to the version of the patch that I already
> >applied?

> I believe you have applied for the ASoC one. This is for spi one.

No, there's a dmaengine patch in my SPI branch too which I applied
yesterday.

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git spi-next

> BTW, are you taking the same in regulator subsystem or created new
> for spi? I can verify from there.

I'm sorry, I can't parse this sentance at all.

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/VHjAAoJEBus8iNuMP3dATcQAJSp5EkUW6n6U4eRDRRDrswD
EsaI+6S5V/wYeCV0jlCwaSrgczRktXV0MAtFBC4UChN/VY3f+2SwbOnBnfIBaFwF
xhL2dINshAApt5bGzbBXt2Ho2bRGKAwuriE8lpy0RkD7McrINozlx1FM5nTaSmTs
sJ4zIgJTHWGjxG2maFz/Z1/xZ9V5R+u+H+YulVGx2x6XsVzp8OP3XOOHJT7xqHHR
F5DdBbNhzXkRfYiG0ZrJ7TA8DpjH7qYYwaENIWh/R5iU0oT4pCab7FAw84MCEP5M
/ZZZNDEUALWImyjUf3+CMNciWYwoN1qU5SxXIZRQR4i6hmyHCXKTdqnRCnxJgqca
yndShAtnDhGACFGnzo0lVFS7FDfj9id/l7MSu8Ga5ctKlCseppBiW1+/KNgJfdcn
NVxntrqrA6ch9fckCQxXkAKwX0ykAXggECCkDuwRnDsOltHQJvmqY5fP99BEHt6q
vRaEM9wET3Yy7aGmFB5iCrIXwB/qGI7QXdV94EbbGzNUXataMbsyo6Agzw0Nvp3Z
u0R204XnlN9QqDNN76m/1aP/msaozE2yyzdo8IjAqqSWtBAVE4bY3qrRxHOTalwl
iJp7ZIOuW2JwLxWBZD43IWt/ih/OiK/yMOKRCy4G9D1lMX31TVLnzxO35e2ImW3E
qnnNQ10k/V4CzZLIe18A
=//6h
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
