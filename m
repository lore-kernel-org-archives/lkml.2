Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2KTIci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:32:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42552 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514Ab2KTIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:32:37 -0500
Date: Tue, 20 Nov 2012 17:32:29 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
Message-ID: <20121120083227.GW10560@opensource.wolfsonmicro.com>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
 <20121120004356.GC4483@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211200840590.21420@axis700.grange>
 <20121120080805.GU10560@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211200921190.21420@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0mHLbha4YKvhGtu"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211200921190.21420@axis700.grange>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L0mHLbha4YKvhGtu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 20, 2012 at 09:23:41AM +0100, Guennadi Liakhovetski wrote:
> On Tue, 20 Nov 2012, Mark Brown wrote:

> > Modern devices tend to use multiple GPIOs for this control for a jolly
> > good reason.  If you've only got two levels then the wm831x algorithm is
> > probably the most sensible.

> Ok, I see, but other my comments still hold.

Not sure what those were?

--L0mHLbha4YKvhGtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQq0ASAAoJELSic+t+oim9eXsQAIG1KZH4u3OF0k9PVByJydea
GFJnJXhKnV2fNMecRSvMlOSu9NkTdY8GdlY+cZ8rO/QsEnvfZ29BltKbnmurGR2K
SxoTrPmw+HWp3vFdn6bJ7MTtF3d1AtnWNFVbcE56pXAZA18VCwRtb7jlU0wsJ5nk
Vv/2pzWw1xPYBp4bU+8ATO+QiLExzflAO3kQlGoXGoz2D4BUpW3AhCI7H5WoPLUM
fVNQZH/aeJ5X1U4cOMC+bjdVBIQ6cksF4Hni+QT3il4tXtv1ZggUN0CulseKD7tA
kSuLEHb92cFI4+fiYj9JximVDZ2brbasXt/CfGwgmluNsSEzv62Dde3gRFVL2QeB
R8+xpJrG5nTIGwEYVZUHQnoGgpPgqE0CKPfg7tX/GlTpLwBA9Iyq9ZclAGSzRRPM
LRJEUk0T3DxVHxr1mD63+hkz+V8ccMf+BrxtntC8v+hG8P0SV2lOgG+1txW2MoRj
VszoVGIUjn/omhEoQ5pWRGe2m4n1zPSMFtC35SD4XMpTgyOJ/9CummQ+kaQdl714
a2pNi+JXNbpkcX2c8F8isY0pQPfWUJumx1bhHs7pTNobH4Dei2APA2V2/DIgYvmP
v9tqe7sHnO8kvQzGHjQvosWSIye00S8wUChR7Pqj9ObYt+Ydiv74/Jd0lBrQIvo8
8FfkCtFBHulyGODpx1Bz
=Xf6u
-----END PGP SIGNATURE-----

--L0mHLbha4YKvhGtu--
