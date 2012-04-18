Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2DRE4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:56:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2DRE4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:56:03 -0400
Date: Wed, 18 Apr 2012 14:55:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: triage for April 17, 2012
Message-Id: <20120418145552.3272a0b2f4da1440dd097f75@canb.auug.org.au>
In-Reply-To: <20120418030524.GD21302@windriver.com>
References: <20120418030524.GD21302@windriver.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Apr_2012_14_55_52_+1000_FqxmkU6A8.nVJSQr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Apr_2012_14_55_52_+1000_FqxmkU6A8.nVJSQr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 17 Apr 2012 23:05:24 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> We've got fails in a couple ARM platforms, since those platforms
> were deleted.  Perhaps we can slot in new ARM boards like the vexpress
> into those slots? [ixp2000_defconfig, ixp23xx_defconfig now dead]

I have disabled building those configs and added the following:

acs5k_defconfig
acs5k_tiny_defconfig
afeb9260_defconfig
ag5evm_defconfig
at91sam9260_defconfig
at91sam9g20_defconfig
at91sam9g45_defconfig
at91sam9rl_defconfig
bcmring_defconfig
bonito_defconfig
cm_x300_defconfig
cns3420vb_defconfig
colibri_pxa270_defconfig
colibri_pxa300_defconfig
cpu9260_defconfig
cpu9g20_defconfig
da8xx_omapl_defconfig
dove_defconfig
edb7211_defconfig
exynos4_defconfig
ezx_defconfig
h5000_defconfig
imote2_defconfig
kirkwood_defconfig
kota2_defconfig
lpc32xx_defconfig
mackerel_defconfig
marzen_defconfig
mini2440_defconfig
mmp2_defconfig
mv78xx0_defconfig
nhk8815_defconfig
nuc910_defconfig
nuc950_defconfig
nuc960_defconfig
palmz72_defconfig
pxa168_defconfig
pxa910_defconfig
qil-a9260_defconfig
s3c6400_defconfig
s5p64x0_defconfig
s5pc100_defconfig
s5pv210_defconfig
spear3xx_defconfig
spear6xx_defconfig
stamp9g20_defconfig
tegra_defconfig
usb-a9260_defconfig
viper_defconfig
xcep_defconfig
zeus_defconfig

Hopefully they will mostly build :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Apr_2012_14_55_52_+1000_FqxmkU6A8.nVJSQr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjklYAAoJEECxmPOUX5FE5doP/jZS8DmoCXweGjJA9QHGtJ7h
xSqQSRgh8eaAaYAzksHTWmzulB5fxahIi9j9RO7dHitKmZmGH2Sy3G3VKsCUDP3J
2ed1d9immdgke8Kez9HymnnLo/ql2ykSPHPOLiZo+Boxf7yFsc5LZZ3K9BJlCQyd
42SMmWKT3D4hlBNdSNT9mv0PpFCRPlOG3Y7XD5+y/jRs4s37AVEdjrVSJVwtsicb
EeB6gSObH8E+l9jSjDQWgICFn8QDpaZNiVSUnMsikpVBku9L9HjVdoulaxj6W+zA
Jpm01PabV3nO42NGNxJqmoy9TVI2hdZGRcu1eVlU+kRVAdYA5hTDmpzg1pg96qYB
iAP9DtnzioitXJDFTxGAo07jdQ2F2ifaIlnFD9fJu3s6u0EynqdUOEabm8gD3kM9
qciVI2awBL2YtPXAoudbz2merJSuHqHBf+7XNmCS3NLFFFn8UpJJ6oPM2bNlUxPE
9vDE1exz2lmneYzB9+muzW00wQyEoFR77QZgZGLVm4xe/WjssIUl364Hh7ilW8wa
N6w8rEgm7swwrR9CUT4+f9mD+4EYwUAeWrRrOS9asesFntwT8tVWE5ECq1NRREMG
Aih963mI/TDR5hmtnXY7SXTirp5MdiOmjoqv6SAWzey7XrWbGtR1p5xFXDck9PIj
wSLSspBOkw9f6ScxRwJc
=ei1i
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Apr_2012_14_55_52_+1000_FqxmkU6A8.nVJSQr--
