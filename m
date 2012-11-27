Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2K0UYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:24:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60445 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316Ab2K0UYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:24:42 -0500
Date: Tue, 27 Nov 2012 20:24:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: s2mps11: Fix ramp delay value shift operation
Message-ID: <20121127202440.GF32691@opensource.wolfsonmicro.com>
References: <000001cdc9e9$4e417cd0$eac47670$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
Content-Disposition: inline
In-Reply-To: <000001cdc9e9$4e417cd0$eac47670$@com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 24, 2012 at 11:13:28AM +0900, Sangbeom Kim wrote:
> This patch fix the abnormal ramp delay setting.
> The shift operation was wrong.

applied, thanks.

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtSFsAAoJELSic+t+oim9CoQP/2jlgUoHR/dfp9h6LYqsv12B
RvNaN34xbN6dkopEkCE3X5G8d1yHxdQqU4x+vLDVpIP/pAm4Xa9tzKKniS6CXsRX
aeGnLImzSzTCGonSrn9GFTG/PtNwTB7hSJ/D2MprHBagfEgTGc71WYEP6GRFCBzH
GxZynnZ0qpHbFe6Vfks5FEbrzTwD0+4NPukSaVmlUxhdFWSDAVp663WmFMXx+NHJ
vn80+SCiZ4MPVj5AGYzem9hNgVtu2OIY1YOrZHR/16DdYPB/OY+yuOBQXTAKgj4w
j/ZwexxACp/WapEKmAWiV5ujKF56tBiVOXBZdADLLXil1yhLXOgnZQ3FkPFAjqF7
NtLn5fH5TnM7ZL4za8lfjPLLEnPSJnTFA/UPJQtZoRQc/0R7A689/crjFXvo/PuV
wwomSHay+SKQqz4qDLtCfbSjIliNAJSzY9u0ijUP+obBKfrJUiRR2XksiH9VFs5H
2fnVsqf59SQrU1aCHNsQ9z/MdGxxlH2nA3vKNFHUlAv/Vk5rtltEzKaKthL/sVxr
XYSK3+BpOOw0p061X9fK9xBe8YHCY6k+uNrLxKxndH/F0i8gCbpoICphtVEU5LgT
Y0S+iIdomlWB+fynstGrDIy8yITs+c7YkZVr4tiTYp5s1yqu6F2XD+TKonNBnLeB
ST/n34BbImnSOKEIuQoY
=RixZ
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
