Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2BVN7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:59:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab2BVN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:59:00 -0500
Date: Wed, 22 Feb 2012 13:58:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Fix section mismatch warning in wm8994
Message-ID: <20120222135858.GN7340@opensource.wolfsonmicro.com>
References: <1329897485.27727.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JVu9XMG6uEpKCPDY"
Content-Disposition: inline
In-Reply-To: <1329897485.27727.0.camel@phoenix>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JVu9XMG6uEpKCPDY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 22, 2012 at 03:58:05PM +0800, Axel Lin wrote:
> Since commit 423682 "mfd: Add __devinit and __devexit annotations in wm8994",
> we need to add __devinit/__devexit for wm8994_i2c_probe/wm8994_i2c_remove.
> This fixes below build warnings:

This is fixed already, the relevant commit was posted along with the
original series.

--JVu9XMG6uEpKCPDY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRPSHAAoJEBus8iNuMP3dw7MP/3T1GGWCS2SL9/psLQbBH/X/
22DwUGqq0t05nt9rJBkXEeUaPxuNV2Egyo1cLj5xZJEhpi/hbwELv2Ua56Owym8m
AaiOQuh6MiZPmm9EXdgURJQxyc5H2IF5MYMmQ0TLOj1NKsP1MgAntrGkGPChf+Bn
jLJ5fwNT+5IJmeD48Ej2edusfbiGl9WohAmD5IstfwRVc6BPuGVuF94pHzrnYvpw
C0ozlOTWq2GO6NKCx2s5AbwaBG2DDzrbhPtc59diiurfVp7OBAz+yUfV1kqs+Ya7
0ZBjAAeVRmeVMyxjFLc08JjucobBgukJWQYgEc4TNQLAkHa116p3ACCLituC8IMe
sZKa9gxptpxoNBRKvyyb7nLkEhG0YxaYnfJRB+NqCvPRe0FZS3+EOW1iGWdkUYan
RLgZ4AaOnR19FRpKDwJZJWtxMoJxT2BXWSKYHJ24BmG1Wq0iqepcrrypj69SyieG
e65WEeTgpV6yTLYQwvDqzsv/eghDSe0PJqHe5zJzjPEg2xwc/G4JSwOXk88JE6Lx
blkX3h4yxMf5S03gLkOoHszCN1IXnHHQ7osS2dpLputNFWHCoE3F9wsk7BE69P+Z
jh/Qk8S+AaRGnePqBpV8HlZdIH4zXmroCxAiA8xrL+E2Bopk+TDtem96xaNC502E
mbuq6zlm/LFbmikQguAq
=1lbU
-----END PGP SIGNATURE-----

--JVu9XMG6uEpKCPDY--
