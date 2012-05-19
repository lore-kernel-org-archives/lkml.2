Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2ESR2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:28:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41036 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab2ESR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:28:47 -0400
Date: Sat, 19 May 2012 18:28:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519172842.GW4039@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
 <20120519164134.GT4039@opensource.wolfsonmicro.com>
 <4FB7D4D8.2050501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XQSDX3NWE02rtiZq"
Content-Disposition: inline
In-Reply-To: <4FB7D4D8.2050501@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XQSDX3NWE02rtiZq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 10:44:00PM +0530, Laxman Dewangan wrote:
> On Saturday 19 May 2012 10:11 PM, Mark Brown wrote:
> >On Sat, May 19, 2012 at 07:44:06PM +0530, Laxman Dewangan wrote:

> >>When registering the regulator driver, use the rdev->dev for
> >>getting the regulator device of given supply instead of parent
> >>device.

> >You're providing no motivation for this and it's difficult to see how it
> >improves things.  The class device is dynamically numbered so it's not
> >suitable for specifying supplies on a non-DT system and for a DT system
> >it's not obvious to me that we would want to involve the class device in
> >anything, it requires an additional layer of indirection but that's
> >about it.

> If I dont do this then it will not enter in the following case for
> getting the regulator_dev of supply regulator because dev->of_node
> is null, the tps65910-regulator driver have not set the
> pdev->dev.ofnode.

But why, why should it do that and how is this related to your patch?
You're *really* not explaining anything clearly with what you're doing
with device tree...  it's not clear what you're trying to do here or
that you've understood what's there currently.

--XQSDX3NWE02rtiZq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt9gxAAoJEBus8iNuMP3dUVUP/R/oRK3eC2EkpICBs9hwu/rk
mbZbKiaBuLlOzky8GrRSIRYMeGuNOAeyNaUTrLLWrIDztlL0cTAahqznhiD3BvhD
BEN5IQvSzZWXYxeuvRiJnbhrZp8ouLReSCN07kiefxycG9U8b7Z8wfwFfpiabdMJ
/celqu9prJVgHaZcWzXKwyN/p494FQtwjENXaOG/lEyaRnfWU9JpRrspRsLld7Jc
02JCS8RjSGDcmrzWorm3LGyawqvf09TGL6ym4tpWEn8U8qmBHqm2HRqn0ROHWWv1
5E/DKvlyLAN+xkPOqON1GKgtS3Iyl14kAIsPkFnuMykFxJceluyIG7CQbMgnJ6bj
wZ7gJmIjThBRdsIoCWT2DvjL+r4ZjSXbaHzpJX0AKmsSXRfAmpkJc7Hd+UWInKzP
hOb7YA1hI5vEPG4D4jSRAgUJ1qxP5v5HxTojZTpQ3hr4FPj8gBZXMu4tf0UdOxFl
g5jA6h2oPXNWG1dYKggYJa0ATgFkFQOb9hwuAwS+ZULcCFYGnz9gaIVgQ4L+XWve
vhCON8k0IeGE3GWC1fmIfVbJ69eAkzty0I8SVOCmfekABIEvS9TiyQGc3ORleA61
EXLoW/yuuimKOL/vXn0wgAmV/SUttozbcWen65BuZuNCUXe+VAf/imnpY9s4QkLx
wp7vjWfh7IOaAapqwNFy
=4AEW
-----END PGP SIGNATURE-----

--XQSDX3NWE02rtiZq--
