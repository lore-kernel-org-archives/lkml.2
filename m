Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2BULvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:51:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56518 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BULvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:51:36 -0500
Date: Tue, 21 Feb 2012 22:51:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: build failure in Linus' tree with gcc 4.4.3
Message-Id: <20120221225118.a2e510b249cefd66be08749e@canb.auug.org.au>
In-Reply-To: <1329823933.3639.6.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	<20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
	<1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
	<1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
	<20120221213818.34410cc74de633cda0169819@canb.auug.org.au>
	<1329823933.3639.6.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Feb_2012_22_51_18_+1100_m0LMl3/HgnK2CRrj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Feb_2012_22_51_18_+1100_m0LMl3/HgnK2CRrj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Tue, 21 Feb 2012 11:32:13 +0000 Matt Fleming <matt.fleming@intel.com> wr=
ote:
>
> +static inline u32 read32_le(u8 *src)
> +{
> +	u32 data;
> +
> +	data =3D *src++;
> +	data |=3D *src++ >> 8;
> +	data |=3D *src++ >> 16;
> +	data |=3D *src++ >> 24;

Shouldn't these be "<<" ?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Feb_2012_22_51_18_+1100_m0LMl3/HgnK2CRrj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQ4U2AAoJEECxmPOUX5FEHA8QAJ83l6GKpJcbzqLwgEBkftF9
LTAFW4BgqsuR1xflmvLRxlsOLi8R6PrVmvsFfBDUP0Z2olNFX8OYJuOX2j58jwZF
3+RWl1knWWsmIh2q7WFZhyVEd1q0p0dbosW369EunaPHYP4DjmrMt9hFSeafgeTw
7qo/zxjmvsKSbnD08XwkU1XhooJTCgOJy9owJiZ7EgtOdI5vqwTeN6aEJNiGzbFU
L1VTye8UpSqss1nprs1lA7ksWAfRUS5qMW7sBW7dzLAItspk8NktFIwlC0bRdYvW
nm+ilicDSWNbctaXUDAz4f0BL4+ztvvFu4oPoL0fAHy3AD7KfSxl9W61UIoM2R5K
eF83nOt4Znvjj6E1AK7UBOes/Y4ZaDYKsjgBOWPiETkXOTGI3avwJiuxtF8qktJV
8cTJEfFF6LoOgOlvtoW52JIdJfloZmgyvtRI8StSfxiw/GpPRj2ZToBDk73QXibY
AMKNxCDlgE/Js9hMlUfWr/edJNYbHvOaRvy5st79sXfz8crD6v3M4akaBgal+DwH
t71gYQ/HBD25r/dOyOW6RWtGDwb8SwcDdNiyzuWhnmNhpUkz6bOdMc5LBkjJKT2K
Re5LIk4QmKcDDD3CGbxedq9FLHgta3hMEoXzSaEteYXrTGLyYG9aa+ZTZuCuG2L6
fqgmRxeMKd2JWlkdz5TV
=P2S7
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Feb_2012_22_51_18_+1100_m0LMl3/HgnK2CRrj--
