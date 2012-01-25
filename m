Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2AYIaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:30:15 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46826 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752772Ab2AYIaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:30:09 -0500
Subject: Re: [PATCH] drivers/video/omap2/dss: use devm_ functions
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1327410045-3906-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1327410045-3906-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1327410045-3906-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Tqhkox6DqtMuBk8x6OLS"
Date: Wed, 25 Jan 2012 10:30:03 +0200
Message-ID: <1327480203.1858.18.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tqhkox6DqtMuBk8x6OLS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2012-01-24 at 14:00 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> The various devm_ functions allocate memory that is released when a
> driver
> detaches.  This patch uses these functions for data that is allocated
> in
> the probe function of a platform device and is only freed in the
> remove
> function.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, this looks very good. I'll apply to omapdss tree.

 Tomi


--=-Tqhkox6DqtMuBk8x6OLS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPH72KAAoJEPo9qoy8lh71CwIP/2OmQyhyKDQ7vMn5l3r36opX
C1nC0BNVL8Ng5ZinwJAJKyAFx7ZMS4hmn0XQLetaqElFHlZjJ3T0BrshQasmOro+
KVKW01Y8VmurASfUK0muvZqf1XTutS0WgkFZzNgYiqApJpzY5i3LTMaDHo7Xoyru
8s7gVEMYs5+hggAWDjsOqCKrmquoxN7dDgxOCxrRtuKSbxZyTfE0CzBpkksn0nyq
NpAPj4/WOPDa9JRTm39gYiLSMxlQqgAvw0IcI/TxYv6Gzbc9xNYgrja1kyRbkrSV
8d6Y+/+zA2JY460cxuAHyEu29LgaqWiYmANv1HKXWZi9Mdh9+gALAxkEeta4htH0
BfkjB3i3qjgx/2ccJ788UloHFpjh8BcwuZKBiz5RPrGkBeN0cKAFj0M4aCuAAhHW
5sYe01NzEMNsuBDbwjNnQiEE3jGLpP2KzgkcM21iefxIPLw1wmpzfOn5zGRfInAv
IWbpxti2pLKPhfmAhaY2S89QNZg0/eayJSDq7fYNx5sxUdHWDCy3jRBG0EdQoOzc
vADRgoOic2duGHNkBBgRD0zhJJSFLRBSksSCdaZbgMKsK6S55V7zBbYAzY1rJVsB
Y1yZ/1rngY9ca9fblsImbb+SUMOaEb9oWmQn1502pD7mZ3VIxAse7PKKKAC8cTqm
bCPjh/pShN6UU12AS97r
=eYcY
-----END PGP SIGNATURE-----

--=-Tqhkox6DqtMuBk8x6OLS--

