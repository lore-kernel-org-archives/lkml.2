Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2BFQxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:53:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59935 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab2BFQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:53:40 -0500
Date: Mon, 6 Feb 2012 16:53:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120206165337.GV3070@opensource.wolfsonmicro.com>
References: <20120206122553.e794e84d5f586619d710fdcd@canb.auug.org.au>
 <1328547058.3845.5.camel@odin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WWBpDPuG52WufD7Q"
Content-Disposition: inline
In-Reply-To: <1328547058.3845.5.camel@odin>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WWBpDPuG52WufD7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 06, 2012 at 04:50:58PM +0000, Liam Girdwood wrote:
>=20
> From e3e06e913cb74a57b603a2e7ac0f08c995af4969 Mon Sep 17 00:00:00 2001
> From: Liam Girdwood <lrg@ti.com>
> Date: Mon, 6 Feb 2012 16:36:04 +0000
> Subject: [PATCH] ASoC: max9768 - Fix build and use new add control API.
>=20
> Fix build breakage by using the correct API call to add kcontrols.

Applied, thnaks, but I had to hand edit the changelog since the patch
was at the bottom of another mail.

--WWBpDPuG52WufD7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMAWFAAoJEBus8iNuMP3de7IQAJ3e/VMrZTclNUGPZGcgM+V4
uGeTgwz4iXykOQa6bCNPz5DNM8EmCE+hnq8uiqpy/PSX9U0O2Ngd14h8/A8Q2+yK
OJYf6XfMs2MdjzXLmxdGJNdAsVq2GMW5zN5CxQcusHh80OSBHjUkTpmZ7BxfEElk
z56RgLC4yesQ2HIMLmE/JfY03f8TuwOn+5TY11wUiXjQICf5YkJ/fNsrvkylf3C5
Ze+20R6L8BdlKkxUtMokxPkbBml3Yr/C+yO8qLUQrJ5cCb4wF+H/ZpiFgQ8RZEfF
/E0kUWZVQC375d3yG5ZwkAoII8ojcXc02d6/sgC7L4Gl8/lCNWvwMR+zY5nkHPaY
3jVfXgic0aFqaNBWaCLHtzYlmcShUbGngSlEgnfDwZal1lL4zD1ur8nlO5kTTeQ5
C83eoD1SV2K2/bpRf2YomXV04iKO2nRjq2FHaPL/OAln7VTvsbXMHtS0yPzSNISM
HUMHpP0ygkBPXl6ibpDdBo/sh5aPEP3skrTfYwwIy7a6XnmvofjN2xHze04Z50Bj
gWjXJWsPVpxW0mx6I0VV+vaFyCkd2pBQIwvAHdCD+Jflpoukh1qkUNerak3ZWc7H
q+pbCF9XYPI3SVyM62klPyDwxTJseJ6Tg7Pd6+eb66899oyE3iIaWHvUM/tN8FQM
OdZ5Mml3tNDsIqlxjXb3
=Qc2G
-----END PGP SIGNATURE-----

--WWBpDPuG52WufD7Q--
