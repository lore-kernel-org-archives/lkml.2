Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2CGQ20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:28:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab2CGQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:28:24 -0500
Date: Wed, 7 Mar 2012 16:28:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>
Subject: Re: [PATCH v9] Regulator: Add Anatop regulator driver
Message-ID: <20120307162821.GP3107@opensource.wolfsonmicro.com>
References: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
 <20120307132225.GB17745@game.jcrosoft.org>
 <20120307134551.GL3107@opensource.wolfsonmicro.com>
 <20120307153622.GC17745@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="90KBcPA0h13nTGdQ"
Content-Disposition: inline
In-Reply-To: <20120307153622.GC17745@game.jcrosoft.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--90KBcPA0h13nTGdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 04:36:22PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:

> > This really doesn't seem at all sane for a device which is already
> > vendor specific, it's just noise in the bindings.

> No it's

...?

> Here is a good example as we have regulator generic binding & vendor
> specific bindig

It's not vendor specific, it's device specific and people are doing it
even for devices with no generic bindings at all which is particularly
silly.

Device specific prefixes probably make sense, but vendor specific ones
are just noise.

--90KBcPA0h13nTGdQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV4upAAoJEBus8iNuMP3dDrAQAJxEkRJlKSPYdjgEYR8gK4HD
LYXfRBSJL5UFUHr5WIbqBmdYJy6zcA7DhzHTDm3mJB6dbMYV75J/NSIQMiJ1TbI/
WqMjO8WafIwB+WtdPZ8InD8gyvsUOafo4/GjHh9OuxdYLl1cDg9k3E8HTufUZabW
nP0M6jMUB1fRKNEDXVvmxK7gXcpmOjmNNlQj3hYIroVdi3JiiY9hvQ2XJcbmXf/Y
4DqQdbJB59EGSNIF/ej+DXwO+eAcbcAYp/Ioqs1khxN+4lVFQwqHeRXyMgnYMNn5
VTCl43qhVxFRo/vqjMB/GnlwjdPc5p4LNmmWpf9IxTexm6rkvHfzhXi4FN88prYT
EA/QmU0Chy4hvO3z9XfrIJX04NhPmiirzSJyKHQwB7ChdqyTAMr8QcdjBPKSRmv6
Xi09L/GnAF7htIH4cIhqD9U1UlnbCdbJG9kBSJJWxSrG1xiDI0bIx2m1yKIV6XFR
F2aMmLKp7W1TvhWOmUlKyWrU8VwPJBWNwxJ/vyAwPPdV1rNpDbh7sDYYLUOcxha+
2f2DIbm/a34mB6XcWjDpZB4KSxt85IRwSCZGFHDNdy+ElkvfGCCyedPNGjdbkUv/
rh2pz5RZ8ILuzIjODdRYu6BNJWD6GLWGdCiTI11kB1CzWO3dMXi4lqKn60K8fKfX
h8Y72prxLk6heP4eU6Es
=SMRj
-----END PGP SIGNATURE-----

--90KBcPA0h13nTGdQ--
