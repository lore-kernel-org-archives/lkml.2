Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1LGI4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:56:52 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:39959 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab1LGI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:56:50 -0500
Date: Wed, 7 Dec 2011 10:56:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: storage: Use kcalloc instead of kzalloc to
 allocate array
Message-ID: <20111207085645.GL32368@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322600880.1534.336.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GU3/x65mZ6MFE8p3"
Content-Disposition: inline
In-Reply-To: <1322600880.1534.336.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GU3/x65mZ6MFE8p3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2011 at 10:08:00PM +0100, Thomas Meyer wrote:
> The advantage of kcalloc is, that will prevent integer overflows which co=
uld
> result from the multiplication of number of elements and size and it is a=
lso
> a bit nicer to read.
>=20
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

applied, thanks

--=20
balbi

--GU3/x65mZ6MFE8p3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3ypNAAoJEIaOsuA1yqREaikQAJEpVf7c0RLfMIn394JRQyj+
l/JJyMrKeYVcgCIlfAGp2XRXT5RJAyE5CbehArvjEBjCtaup9EYZpTQ1T5qEayxy
p4gM+wyz98LxDe2XC2xovNLx08/EP8cmC09KnJ0gx5PZ5+QSQeNnJ84EgIYYFxEP
EBE0N70V6gCcf44KJnwN693Jk2dTzCWKG8B94Hnt4O2g33orpLgyBdAys/corUlg
kRiUC8x3GLILCo5hKwmcVbmApTDaF1NGQwl/YVTnWKhd3nextxy4MprYbpQJGyAk
Lmoai4lTe7yJ96S/JtYK8MgMnv5GrvoJb15KyvSTvQEcU79srktiSq0onf+DxDzQ
I8Cm48z1vVRZva9pfMekcjU0vcJ8NLAA6DsZEWgqXPq2owtwORMR4F0UCrW7HV2T
1yy3LHaICwEZ+8EyDh0DDf30+cvRWZvPzC3dC61EC6jKE++4C0vfE40yF56/wz8O
E7q9JMgeBQjVyUQWLAi2qY6MryznM/beeaxhV5nGa6qgYKnmq5264irpVrltx8vh
Hk3q9uh4qFeiigFDE4lW8SAo26jrET7iRwcdcbyT+XjNdtp+4GdeXtszK2QFdYtK
Cji8NkajQgTLd+QdnzXYoxA2IwcnLJT+pPP3pqlit/ldKPu+tweylcVP1IcTvepF
eXKc8nzCCKPqPwjNGkYq
=0qzw
-----END PGP SIGNATURE-----

--GU3/x65mZ6MFE8p3--
