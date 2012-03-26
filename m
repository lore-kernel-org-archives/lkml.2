Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2CZK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:59:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757183Ab2CZK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:59:10 -0400
Date: Mon, 26 Mar 2012 11:59:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mfd: tps65090: Don't use I2C-specific suspend and
 resume operations
Message-ID: <20120326105908.GJ3098@opensource.wolfsonmicro.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332441541-28197-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <D958900912E20642BCBC71664EFECE3E6DD312816D@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1BdFSKqAqVdu8k/"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD312816D@BGMAIL02.nvidia.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1BdFSKqAqVdu8k/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 09:15:03AM +0530, Venu Byravarasu wrote:
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> > It's not clear to me that we should have these operations at all...

> Can you please explain why do you think that these operations are not needed?

They've been deprecated for over a year, if you'd looked at the kernel
boot log you'd see that it's been complaining about them at startup
time.

--k1BdFSKqAqVdu8k/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcEv1AAoJEBus8iNuMP3dJBsP/1dNOy6+dy8kZDN85ZBVl2N7
bVLh3e1ku59Croi4TGCEZVF/blSL2GckbtAA86xcehfc1Ise1Ggj8iGtFx1EieUm
G9sF1FdtlvIkT01XKRrZEr6sNbJuIbCx35BxzGH1mYl163kqUfuHV7M8/2Ssu+SW
OQj44vGElL/zkURuRqoJ8Hd9uRLO/90aZ3+mN+3STl5zyDDoR0Y/xbr0uhxp2LbA
zwZb+XIY81AcIx+xvOXQQj1cK8TbQy0ZN6rpeU8nCubZ2e5+FkKsPc0Czrg4+bgW
/rUHWPtKybTwI25DX5ypd/noj0iG21C4jmokg65+2MyMh5+Cx20R6vIbIVabxqIf
XOOUmxFSU/i4jLxIOy1tE9zAaBV/VZD86sH4wM9rDTlItW4XcnlNoKPy8sMcC9GV
gekgAU4P8s9xbIe7Eu6mAXY7mGAnItv6Kuabd68aqY1MAz/U4/T67QunwXc1ikSR
Jr0UOXjK/FW8lzkSKxZLCkaTZIEgEXObn0WPxV5CkAESckGJmimqSS+9VQICs5cJ
C+c0HxP0UEsGDadmOXmpP/+TvHC8gUjByXTsn65czZW28qXaBjQ888X746Ur7tvP
XZJVeYvMRIlfopTeNpoBrbzzRpIIQ6P37Y8ZkqhtgRhvPYOQkp7UuV0p7blzIEOy
biplG6mmomukV98HXPdg
=gUAp
-----END PGP SIGNATURE-----

--k1BdFSKqAqVdu8k/--
