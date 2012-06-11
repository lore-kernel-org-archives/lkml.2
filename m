Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2FKDlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:41:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60067 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2FKDlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:41:18 -0400
Date: Mon, 11 Jun 2012 11:41:06 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120611034105.GF4218@opensource.wolfsonmicro.com>
References: <1339121082.5794.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <1339121082.5794.0.camel@phoenix>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: isl6271a: Remove setting map_voltage callback
 for isl_fixed_ops
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 10:04:42AM +0800, Axel Lin wrote:
> isl_fixed_ops does not implement set_voltage_sel callback, adding map_voltage
> here is misleading.

Applied, thanks.

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1WjFAAoJEBus8iNuMP3dq9oP/icHSPbvQhlSZLo/zC4G5Z2V
RS8Qi52ELFGH8Jvg6fj+bSL9azQmq7WDRevskX0FWLUoG39cM/fbZ3lCTYNC1cAr
62EzXBaagmbML2LAHTNwQd1Cb/VYGtTxnSv8W6qTGYRRYPPyxNcg97C3mjrxr5Lx
Jlv3plSJFTddedGv/JqzRmhspRTmduMhD1kLfqo09NJDc8Ml/QOC0Z6MTV/U2TvU
4fjZo4qcOpadywQd/trqE5rwdrt3D/C/hkc1Iw0alZwgPw9U1RFryhnHYm3JAgpA
ygqcYIH+/bkzRdm9VXlo/Q4SfygN5hy2OoVPwXMkX1i3dtgGm4Wcd9r2YetDfshR
OGAXnCqAm43I9HbNBXEAmKUrhRHRp+Lc5Ch95ul3o5roeyXP6tls649cT2o6QtRQ
jUfY/fo+CvwSGuOXW7dNvNSHc4z8ILaWuDkxdNvvXmjBcViW5bblyoL9Pl5203WL
gPATB8RD3Vt6bTxC4a5zlMjXuWwHyXWZscvw/KJ2QF0BnYNIdFOx3ih0Pkqil15a
vlBcneE5U052UV6kQaBwQooz+j/mbE9ugp9RmNgQM30T70rDtjg4PFAHQ5ybPYtd
co+zWo9UiGLsxqQLGnKntPULXKphn0Vgfh4/NI8E0S7Dk8i2MdJCFQLBuIluyOF7
5fVaDI0aM9hiFuapgpDP
=iO4C
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
