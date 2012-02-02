Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2BBMk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:40:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab2BBMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:40:27 -0500
Date: Thu, 2 Feb 2012 12:40:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 5/7] OMAP: sdp4430: Add fixed regulator for twl6040 needs
Message-ID: <20120202124025.GF7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <1328185019-29575-6-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 02:16:57PM +0200, Peter Ujfalusi wrote:
> The twl6040 VIO power is connected to SMPS V1V8, the
> V2V1 power is coming from SMPS V2V1 of twl6030.
> These are fixed, always on regulators.
> Create fixed voltage regulators for these supplies.

Shouldn't the PMIC be creating the relevant fixed voltage regulators?
It's a bit clearer given that the supplies actually come from the PMIC
and it would cut down a bit on the boilerplate in boards (though much
less so with device tree, sadly).

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKoQzAAoJEBus8iNuMP3dK7sQAINNif96qMJcL2Mx7K0JhuAg
VPMrXsBVusY2fRoGOwzmxRgRb/pH9g17n/g9tuLfmOdx84gUT6gpkfJjbbEFLr+Q
UCT5OEBTtth8Cba55pqmcLFn+6l8C2wkeXbsNyErZlAdb3qX3SMywqmmWtEpT7Km
CYzPErwA7SaYb7/fCfvklEZJQKVlV0t3Ra59e5y958KMYOkEa39zscezLur/AgWv
S98zSUb9DSfnIDPNegAy1Fif9csAcXY96pIdwzLHnxsq51knU4RkjbK0jcC2eROp
1mxCZT6ZK8rW2E0VPQeldr8U2qhqf42kjBv5b+/ttGcSqZu6qXwH272//+Wcn3pW
EpdSgW2ajEwUTKWk9dO+jBYMQaez2oERcThE116/9wuoDTV6b50l1DyvgnnQiFgv
WgfDFHz115zHBC1+EttTb5BOyVww7V44Qp4Tb8V9+MJrERAUle3ke47ckYBd21so
9JIVX4QkvOBQ1Fii0vlf8xBXDGlOpkWGM+DRDotwVnVhAGiamUxslBmtlEzsET1V
osSol9FL6+qyeYErMHHNcpU045VnZpC/JlQ8Yyu2IkpMfvMkJe4HiuBkYp6iifFX
lqVIkAE2ZVVpCm+GAm6TKnu348zha2U6Av+khp9W+OvQmvfFDW50qgqnXPWrjVSC
+o/RsLPp5bSj4jEizLLo
=pA51
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
