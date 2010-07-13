Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0GMLL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:11:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57180 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0GMLLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=TD4W0KxI3Fb+dmIFRZiGh/jBDIgDNEieo4MF3gsFkp77uXwNHYC7FIa+pKye/sSNGg
         C69JuQN/+JGcUAIl34t6jq3Pce06l9v6ch7zdIHtgkC9VxfF/mhiFm84xRb5D3+5Nn9W
         cT3dovoojqhLxwV/PCqOBGbvPcqgIh9ZAUrHg=
Date: Tue, 13 Jul 2010 13:11:12 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100713131112.26a3da54@varda>
In-Reply-To: <201007111651.42963.Martin@lichtvoll.de>
References: <201007110918.42120.Martin@lichtvoll.de>
	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
	<201007111651.42963.Martin@lichtvoll.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/55dxYQzSeG=8sgaZ4NrtUFu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/55dxYQzSeG=8sgaZ4NrtUFu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El Sun, 11 Jul 2010 16:51:42 +0200
Martin Steigerwald <Martin@lichtvoll.de> escribi=C3=B3:


>=20
> One reason for a demand for me is best expressed by this question: Does=20
> the kernel developer community want to encourage that a group of advanced=
=20
> Linux users - but mostly non-developers - compile their own vanilla or=20
> valnilla near kernels, provide wider testing and report a bug now and=20
> then?
>=20
> I can live with either answer. If not, I just will be much more reluctant=
=20
> to try out new kernels.

 I for one stopped booting into -rc kernels.
 The fact that still have to patch my kernels with a *one* liner
 since 2.6.29 kernel [1] does not give me confidence on the "test
 report/bisect and it will be fixed" promise some have made in this
 threath
=20
 [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D13362
=20

--Sig_/55dxYQzSeG=8sgaZ4NrtUFu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJMPEnQAAoJEDO4iEReSTB2BJMP/3pH5br8uG2Oqo4rWtqpOWPH
ysi+Y+RU9yyeYI/ffXKWZU1A5Mt+H5a5K7W9Cv9+yavNu3tcN8iP2Xtj9VvvhO5C
la/NA75RiWrM4XgQani2lJEfbWI651L8cpxvPUnUFF7S9Uh86mdS8B2XJSi3QVIS
MIgEp4uS7kurHq7LAWPVQR4P6zqhzxldamn/EczvBb1lQ04kg/jIVlQ7gGZ+9Ume
NjaUL/FKE1mzYGsjeTXLDm7jtcZyvD3UKJkCewBXiJFjk8LBEkQO7o+xOsCdPxsm
mcROJ0oCi6BHpZNuOi1WFULa+8ZK5BoDfNaSxp3WutfubVkEttE1/gg180SBuLtP
Z4zkwL7T7DdV7IXbhoImjiMbqL+y4S7Ael7DgDxVyNHNx2xPwkqEUvHpNaGaBUsH
v0ngjVXx+mLgQShBBoRd/bZgQhcMkjSEixwUTsmqxOY4315egGxqeDUHlVL2dtqd
PMRJI9ecFUZtbqGfgKXh2AMU1z5Z64/qzMbR5NDC1QYx2DbTSE0njJ2L2arLrttb
Is5b298hNhZxaMxHXtGY83T89E7QDGkE+ZG7TeBNjdT/T2H0KMy5ff0q4Gm0zQxV
WorrMt1tpEh6zHZQuZRNSWKowblncziSp+GG+VAKqOJ9S/ZZWoykGXKC1UeNKx90
x1Di15AieplcQn0cT40Q
=tKaX
-----END PGP SIGNATURE-----

--Sig_/55dxYQzSeG=8sgaZ4NrtUFu--
