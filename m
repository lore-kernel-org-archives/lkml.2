Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761Ab2CQVsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 17:48:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35085 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab2CQVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 17:48:11 -0400
Date: Sat, 17 Mar 2012 21:48:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Peter Hsiang <cdefgab1288@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: max98095: add jack detection
Message-ID: <20120317214808.GH3315@opensource.wolfsonmicro.com>
References: <1331849267-30710-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ISKrrfpKsPiF35CV"
Content-Disposition: inline
In-Reply-To: <1331849267-30710-1-git-send-email-rklein@nvidia.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 03:07:47PM -0700, Rhyland Klein wrote:

> v2:
>  - Removed useless function for irq_handler
>  - removed enable/disable irq
>  - Added pdata entry for jack detections slew rate
>  - get irq directly from dev

Applied, but always include this stuff after the --- as it shouldn't end
up in git (see SubmittingPatches).

--ISKrrfpKsPiF35CV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZQaRAAoJEBus8iNuMP3d06oP/ipEe1DoSROAiQN66TX/iWUk
xYyRLQe7Wk7sF0Xehq1c7HkAcc+z1aAyPCvMnuti9NS6J4bcB7eUAvLL4Inoicos
uG0gs/lIcmUikaMhdQwRN++Tn1wQF5Jq2rJ/vKXfW6t+wi1zJgDfdtbVjZ6l5Hne
4/AEJDRSZtDms/lnajShhCk2p1l2atxg0aFHD3sRDhjbncb3Y7R+EjBDs9foGTD+
GjVKBzOyMhjuzBD/OjkoVGWdpIcDVuur1e3Jhv75eeWedjvesyvroaZESlYac+Yz
PAFwBj0dn9zdSVFJOQVxyP9o1Xnr7D91U3hKKaJT2WPISZ++tCEz4gQ+Os5UEji9
WoNPNbJ02NdzbtslEnAVxhx0RJhnkRcU9p+KaxgNspL460fKAhWUBNF3ahPzoetl
+DFdllMGuxxnGSqQ0Glae126FOIZQXVWxT942cvOTZjAZ5rUAsZHblQKcB83xBte
9ikenw9Klcc1QECCLH9V1fFMYZ4T/XkYp7YxHUib2xDEWldxkhdCygocA7FDCa60
eaVVZF2fhIn7NjtDfpVXq5330shYA6NoF1joVYVF1mmxJSlV5PuOE/pj1VJDmdca
Le72T0QmtulFtktty3aLhQdzUWn2rVaWAF1JEjINPr/Ge1bYwtVDE72CIUTqsJci
J9V31FpKGc6dRdaQDRbv
=SHOa
-----END PGP SIGNATURE-----

--ISKrrfpKsPiF35CV--
