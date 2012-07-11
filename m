Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2GKN2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:28:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45245 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab2GKN2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:28:43 -0400
Date: Wed, 11 Jul 2012 14:28:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core
 function.
Message-ID: <20120711132655.GG3938@opensource.wolfsonmicro.com>
References: <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Content-Disposition: inline
In-Reply-To: <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 01:10:01PM +0100, Krystian Garbaciak wrote:
> Fix typo for case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.
> For undefined mode, return REGULATOR_STATUS_ERROR (0 is not valid status).

This is deliberate.  It's not reporting an error, it's reporting an
indeterminate status which is a different thing.

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/X8nAAoJEBus8iNuMP3dFF0P/3of0bSCZbm00mEulO/z/LHO
/leErSMgLvKbkMLf4Ln4N3W/yWZn8T/ppXAYCx8oZ0ObNX0/Pijq2mkw2+JSD0dk
j6h92YPT8mgShJiWRRKnciF0u+5NAb9j5T3/GV/94J1O2ZLs0P+EBvTTU+Goqd6n
ZwYlKuFOmjSYndfOekYbnxCXAOLB6aY3iVKLFz4wIk5fhqxrZxegBX4VjBw9JOLV
xoYzM0yNK51ZzEJa5VbYqba3IAy6mx0EnfKAzOAdL7Pda51sS8wHTn3SEbcMFHNd
s6+1lvqMec1CRCSAvovZRypuF7hyvm3HU6ldJT+8GKw8hKhBgZr3E00icuGCohY3
T8vz7uhU1VKIAay5+eTVJkoB8cSZlk5mOPD8Iq66RooTNe1eB1OdaIUcQ9jUCaOM
8pd1AIHJr9H/POytY5J70dsOtugVlt8CcSJOXYAszuaov/8fmKieU2Gwm9T9ZETy
BMcde5mnE6OeZAKfECvUQ5IaWlzIbw48cgEkwVY1B5eVra9Yu7jh5K71t3+rMrhM
p2azMQtvvVOmxch5dfTGwbtbaPHF6da2+rQlKEeJXkEvwH3HX9rfMwgCxHDyZIPc
v8afLAJMAZbE1BL3SpSIspvMm+QYzKkNoypbduGADoCZzr7qZ79Gs8jV1x8G3pxC
/WQBNFXF13t+Bt85YLS+
=FrF3
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
