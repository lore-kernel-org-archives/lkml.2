Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2DRQm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:42:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48847 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab2DRQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:42:26 -0400
Date: Wed, 18 Apr 2012 17:42:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH RFT] regulator: tps65090: Use generic regmap
 enable/disable operations
Message-ID: <20120418164224.GB3099@opensource.wolfsonmicro.com>
References: <1334653736.23427.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <1334653736.23427.7.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 05:08:56PM +0800, Axel Lin wrote:
> This patch converts tps65090 regulator driver to use generic regmap
> enable/disable operations.

Applied, thanks.

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPju7gAAoJEBus8iNuMP3d1nQP/2lkwyJaGYiJNEwuqCghfm7O
bvejLa7aPfbFve8gRcFjvwyp3qm502tp/HtrD9qihj1HaxTeYNRrL4XyBB3ji2Wp
2mWLb5YMFvU7+HfVT7+c8G+AvDjuOHvrOM3F3nPFcUt0TtxtOigsNV2IbPSu7KVe
EBB9nuH7ix06iFBdLwZRzP1+9t8cB0O8h32FnXWifa1EnlmVLNKagjeTnzJFMxeY
f8HK2gUn9R+P3954ih02WBFmNxI2SUH8fpqL5JvnDqFN7J6qMJUHLxeCzTfG/JSw
Ji4QcfwfYmhgdybe3bWqVeTPC8ZdhMpCkJeZ3rk84Xa+APwaweq9VO7nXFvAH/XF
zrFQ2X5FoJxx8SKGSyp8vDMCf1N93W4YbtJ69HvuFWgrLPZaTf3WbGmB2unH61yB
wKnOdBJ11ec46CmMm1Y8CrsD7ulk83mN+rcjJKpVEJeG+EPQf6dgfWFAvm3KYWPo
E6nDhGyd8Cjw1k90gSf3N2BXF3psxJyYZZZ2V5ubVh+cC9qNb5sFJKMYJju1LTiM
9IXzR04jtULEy1NV7vYArwEyZdk79enhNNxlksBkc1X6aQf3XTlD1ly63w0EVMn0
Ebc6JoXbquH9VBuaHcbtDs3QFv5tQPI0n2A53NDlrmgsiDLZCVXUT5zQ2L4gvlxU
fOVuSSUn0p8SEIiQtvxm
=40bC
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
