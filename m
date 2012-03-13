Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab2CMXXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:23:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964927Ab2CMXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:23:07 -0400
Date: Tue, 13 Mar 2012 23:23:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] regulator: tps65910: Provide settling time for
 DCDC voltage change
Message-ID: <20120313232304.GX3177@opensource.wolfsonmicro.com>
References: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
 <1331618721-26326-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cf1qy2gtPj5yoBMh"
Content-Disposition: inline
In-Reply-To: <1331618721-26326-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cf1qy2gtPj5yoBMh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 11:35:21AM +0530, Laxman Dewangan wrote:
> Settling time is require when there is dcdc rail's voltage change.
> Returning proper delay time for dcdc voltage change to settle down
> the output voltage to new value.

This one doesn't apply, can you check against current topic/drivers
please?  I suspect a collision with some of Axel's work.

--Cf1qy2gtPj5yoBMh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9bSAAoJEBus8iNuMP3dz1IP+wTxr2pqespD93376gG2pmVO
Z5NKxI/aCZjndV7zm4WvyKJDBgFOMtr1QuuiXtpqzoHvAlC7PpYqFLfMIojmluVo
ZJ8BZC/grIhsa8+7HovKjgfF3EhBbaC2gCaFF2jSdGrZbWf718jPdflJlfxZXWuu
KJXV7yKXCN3NeVcuxJ83MP+y78dW6Rt/Cp7SffVgfrpm/HD900/tiEXs4TFzr/17
DyON06tmscwea/c9rAIHQARXUavPGZFwWTB9gvYgyWoz4XV007MY4P6CAkTs3jiK
beni2nxM+tKldzpgqhimH4agyMn80Wd4r5zuR9dgbwHPROBd7R+85Gs+4a5bjUb8
MZFHXGlU74Ai/roAdsGGvUoLw0ea4jXGOKRzBxJg9pJVsS1y2is1vbI5eWP4Zot2
Odnzfnh7W0wlTBPAwqrMcCEiEEwdoC8QsEf9pnQPIbXhO9CzGKPJJmFdRxKy9amV
WgrDcpXUv1ETSeYGMbQR1OTkab21XqEzl/b9Y3ATjRYhLdUy9p/DHQzR4zBZi0O3
bUxGLsOdhEXaOr0j500swGR3sn93oiu+bIMNLFX4kcMANJagmNSG9fPMj5xyI2gr
g7+M6+zTyHM6NWmK34809d9hD0LD4zG8LWRaLPxbAu5XJ9OD0VUoonSwOKsMJ7zX
9QQARoR0A0N25jDfD5pr
=qDTp
-----END PGP SIGNATURE-----

--Cf1qy2gtPj5yoBMh--
