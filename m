Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2ECOww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:52:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37057 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab2ECOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:52:51 -0400
Date: Thu, 3 May 2012 15:52:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120503145248.GJ3955@opensource.wolfsonmicro.com>
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
 <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com>
 <20120503132004.GB14296@sirena.org.uk>
 <4FA2881B.6010902@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZVh52eu0Ophig4D"
Content-Disposition: inline
In-Reply-To: <4FA2881B.6010902@ti.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZVh52eu0Ophig4D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 04:28:59PM +0300, Peter Ujfalusi wrote:
> On 05/03/2012 04:20 PM, Mark Brown wrote:

> > It looks like you're totally removing the use of irq_base which will
> > break any boards that didn't convert to DT.  The usual idiom is to use

> In the current board files the pdata->irq_base set to some #defined
> value (which is a comfortably big number).

Are you sure there aren't any boards out there which rely on the
interrupt base (eg, using a GPIO with the IRQ output of a chip)?

--YZVh52eu0Ophig4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPopu0AAoJEBus8iNuMP3d3ekP/jPw6tqbLQidQIE6A4lX3r0W
3AhDBqI/uQrNr6/r+zw9VB/5SDnTuRTxou4l1ddp+71MlbUQW6/v2Xe2PkFmHGQg
PeZvm7lVpmESsXj/3X6yGx2RBSzv89SDDAd0Abq47UyXdp5D14fLEYX2yi90SLEb
pza1onK7wLeRaG+Qcm3I22gq3SSXPDmtWfhB1BeUjoQykF3GQo5wPbfQa68vyndB
gj/5cQmCWXsU2OKD5XGQRh7+MUOrlL5f+saKH51gEWQ94ewtg4BI1/ncFVNz4c36
y5fSP3R6EPh20jap5wSrRug2dThhE9cnUQBeTTx33yxJ/OZvT7V4da+B8EWQdCqm
pcjsFK2UzDmWtumrqqrXl6IrSJGAlNdnXZnANi+igpB+V/Sx41lyx0SyIIDwCn2v
UGY2C8/7CgfeL78D2WmdRqaqpwf8ltmayV6haakx3mQ0vAuhDeI6ftUgO3E+/kwn
5b/MUMxh+Q4yFmq+slbr9lpDG5y7geei+wCUdropvh0P0BTflBgbUaQwJWQOPWEM
S+DhAf4zH7Wu1WkCJXL0NB2wg4RG3rOHu+gB3quUNvaSwUMF2PS12aGNZX9MR0Qj
cJwPj//XOWBeKXcdhoCQSqJhW2+ImgRYLcZwF+mLhU97UpvDGMkMHKx2J11bo62F
80QOUenXUXCJPtcTSVxA
=CpAG
-----END PGP SIGNATURE-----

--YZVh52eu0Ophig4D--
