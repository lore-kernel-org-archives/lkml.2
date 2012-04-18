Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2DRKwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:52:14 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:49207 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab2DRKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:52:13 -0400
Date: Wed, 18 Apr 2012 13:51:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/usb/musb/davinci.c: add missing unregister
Message-ID: <20120418105108.GZ13842@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1334588590-23891-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lPJ5i9rX1WvdYcWF"
Content-Disposition: inline
In-Reply-To: <1334588590-23891-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lPJ5i9rX1WvdYcWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2012 at 05:03:10PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> usb_nop_xceiv_unregister is needed on failure of usb_get_transceiver, as
> done in other error-handling code in the same function.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

applied, thanks

--=20
balbi

--lPJ5i9rX1WvdYcWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjpycAAoJEIaOsuA1yqRECnsP/2A/t17LUL22cDdiGqp2dYQe
9aIBKzHGx1TsI5hGg5Q8tklKSGk7pq9HA4B8Za0Fchgk4a3b/xWxCBIAP0aBVkJN
gB5UbCE3ik3PrT7+X7RuIZZQAONoS5ROmyCgi938qOh4jjpj2EhdZFpl/fwbdfjw
SFEu9qS79DegFLLY19BgbIe/CrpUPwA9n81SZGyJv0QYFfID9m37/XFqVEd/06XX
wwVdi7gITYvA/LNf9RcfwQtTdrOR6HJAbDatZS5YnLYUud6ynpwk/zljtcP/5J90
2cuuXbAP7ueBh2K+kaiDDofk7Hqrp9tg0B18fiV3hLa7AtRix964JIpnodimG3ue
JeC2GZ0AJDksbGrCiUc/sYNTzz04JDic54KvkhUxUbfU/DoMRXu9/tTwf6mlo8O3
xOANKi1xKGeFyZ6fgS1nLTd8t1vV2XTTqCUzDhu37PBj3JbSOHkX/cGd/Ul0vbvz
jJfa07W09H4tAkn+DPNOD7letmtlsz+oL0K9lgjSan9iomkCNpF6txYNpyLN7i1f
P1JEF5+5ntwvnN+Ct17rEL0vjGa4GeYpzA0wocC4QKzG5sR7/qdZo+Fzn2X7guiK
2GFh7O3oZ12/otFnS8jzk4I8LxFShQQbrnUVMDVJY3Vt0gJS6uU2pJS0veev4Ltr
CpfVRmUInW7JU6jz7uCv
=niyq
-----END PGP SIGNATURE-----

--lPJ5i9rX1WvdYcWF--
