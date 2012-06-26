Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2FZKs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:48:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab2FZKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:48:26 -0400
Date: Tue, 26 Jun 2012 11:48:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: arizona-micsupp: Fix choosing selector in
 arizona_micsupp_map_voltage
Message-ID: <20120626104823.GP30406@opensource.wolfsonmicro.com>
References: <1340707078.3075.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Content-Disposition: inline
In-Reply-To: <1340707078.3075.1.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2012 at 06:37:58PM +0800, Axel Lin wrote:
> If min_uV is in the range of: 3250001~3269999,
> current code uses the equation:

Applied, thanks.

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6ZNvAAoJEBus8iNuMP3d+xwQAI/lmQAP42l4N+lEC1U+pNGD
Oq/VSVfLin/DCBHMrz0CXc7M362FK/JHKmUeUNuVv0DSP00pzt287uw9n6xsO1Jf
Q/dVy67uGV0a2Mob99iFxOgWYa/UJ3QLJBePWhYrMxdMN0rftUtnOFsupppRYMGc
Up3xQVRh+0DSoPzIh4i51NdIKrg3MpKUbsO3+rjOvx2cyM9XDBcC5S6VBjrP6Kbs
8huU9OVciRyc2kT3EUeyqXrwD6SlvW0FUBgeQQTS9+Uvt7Igwl3My4yNi2+ANxeC
knX8+vwTvfZpy+4evcco+y5uY0FVsZTmFnal2YO4n5aSnknTgb3y/kUV4wm8A32D
YW6nn5tZSLuz14sTnM2OHru2bu8pDFvVQEaOPPdgPpQJ4Dnht4vFrbpCd11RTwOR
UwBbLlqQ1eB8i1P+g5XNMaY+FdHdXfeEpsL4lrrkDFz6yLNV5CP3g3uOxSGqERp1
NPFEGUyGHC5Im/y/ABdVAGzgTPXT+W7sCb1N5yWyoWZAP/uGEwBRB+6tSbmNtKHR
a3sVKAtSD/DfkuICBY/fQGed5E0S0d7YIHIFTJLY9KSrLlHLbfanuYaiZTwugsNH
mDs7v9W7z03vl0zSn8s2TYXtjeLuhYGOrVzbqI6IY82uDRcGv5hrV+B4BeldBCBz
yvqluEUQ5R0pUDxNHnsF
=QUzl
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
