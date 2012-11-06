Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2KFJEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:04:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54393 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171Ab2KFJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:03:56 -0500
Date: Tue, 6 Nov 2012 10:03:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Reorder the wait_for_completion for tx
Message-ID: <20121106090353.GI5044@opensource.wolfsonmicro.com>
References: <1352192419-22872-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Op27XXJsWz80g3oF"
Content-Disposition: inline
In-Reply-To: <1352192419-22872-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Op27XXJsWz80g3oF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 06, 2012 at 02:30:19PM +0530, Shubhrajyoti D wrote:
> The commit  d7b4394e[Cleanup the omap2_mcspi_txrx_dma function]
> changed the wait_for_completion order. Move the wait so that the
> rx doesnot wait for the tx to complete.

Applied, thanks.

--Op27XXJsWz80g3oF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmNJtAAoJELSic+t+oim9eOEQAITlEeyV8StC2jLjvPAp4Pac
XLKNyp/PerjtPTuFyqkPy1w3q5wFaIpZcRpkx2JqOcHC90vaK/lloe28nr+Zli2G
LcTyA3c3LRexCzg9OOdCKrkTjqm+Ux8xQdba2cGlwN2ALsedXbEJpOICGgiQbYoc
a4azKWPEKf7PNaBP6dJK/bPFA7GfXnZDycKhl9KvcE1LIfw0cclKmZ+0Q++dF9P7
X+2MG75/2mSGXdkLgAfbTBkzXobd6eiD0TOOdvD+EqJweR44zOiyxUCDmVJXdgpz
EFHda0n/WzJw6KdzCMcuDIiAdI+Quqmm8Py8+25+qDwO/l+saURP9IkgEZ/Iirat
GRvIfmULDsorK5HhVuSxRUHPsMEyNaxUwWH+wdBjdng26mOUpAz9mTJ6O3bH02Oq
9JGXT1fHJ4VYLtYfYtVVPOw8wySSBTpAezuyix3JeSkCjhwGq+4yrn4QN7rt666/
t/GUnkP9/qtWgZrODbhD8AupVHc1smTyR5zHu3NVXXUO9OS3jH4/SivHhFS2cQHw
z1Wm14m3eal4z7pbtoWmqCEP9nNG2mo4Ksz4zWPKdf1n5bpi2v689k7QE+1LVm9E
PU45xI8efxFH8DIn/2x6u+RW4V4OxQiTV1vsd29sFi+NNrpu5v4d+FnCGJWlZeBG
kRtS62SWIlPAdjJnIciq
=OTHT
-----END PGP SIGNATURE-----

--Op27XXJsWz80g3oF--
