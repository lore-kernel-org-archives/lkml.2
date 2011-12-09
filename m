Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1LIJ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:26:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52904 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LIJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:26:35 -0500
Date: Fri, 9 Dec 2011 10:26:31 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm/imx: fix cpufreq build error
Message-ID: <20111209092631.GB3327@pengutronix.de>
References: <20111209020948.GA28216@b20223-02.ap.freescale.net>
 <1323399055-31850-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1323399055-31850-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2011 at 10:50:55AM +0800, Shawn Guo wrote:
> This patch adds missing linux/module.h to fix the build error seen
> on imx cpuidle driver.
>=20
>   CC      arch/arm/plat-mxc/cpufreq.o
> arch/arm/plat-mxc/cpufreq.c:203: error: expected declaration specifiers o=
r '...' before string constant
> arch/arm/plat-mxc/cpufreq.c:203: warning: data definition has no type or =
storage class
> arch/arm/plat-mxc/cpufreq.c:203: warning: type defaults to 'int' in decla=
ration of 'MODULE_AUTHOR'
> arch/arm/plat-mxc/cpufreq.c:203: warning: function declaration isn't a pr=
ototype
> arch/arm/plat-mxc/cpufreq.c:204: error: expected declaration specifiers o=
r '...' before string constant
> arch/arm/plat-mxc/cpufreq.c:204: warning: data definition has no type or =
storage class
> arch/arm/plat-mxc/cpufreq.c:204: warning: type defaults to 'int' in decla=
ration of 'MODULE_DESCRIPTION'
> arch/arm/plat-mxc/cpufreq.c:204: warning: function declaration isn't a pr=
ototype
> arch/arm/plat-mxc/cpufreq.c:205: error: expected declaration specifiers o=
r '...' before string constant
> arch/arm/plat-mxc/cpufreq.c:205: warning: data definition has no type or =
storage class
> arch/arm/plat-mxc/cpufreq.c:205: warning: type defaults to 'int' in decla=
ration of 'MODULE_LICENSE'
> arch/arm/plat-mxc/cpufreq.c:205: warning: function declaration isn't a pr=
ototype
> make[1]: *** [arch/arm/plat-mxc/cpufreq.o] Error 1
> make: *** [arch/arm/plat-mxc] Error 2
>=20
> Reported-by: Richard Zhao <richard.zhao@freescale.com>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7h1EcACgkQD27XaX1/VRuitwCeJ45lSV3EF05nRh/RHhAgKzFk
C8cAnR+O2KE22sWWCHR71JIFnTVMcOzk
=Erpi
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
