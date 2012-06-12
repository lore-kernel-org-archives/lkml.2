Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2FLOrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:47:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52620 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2FLOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:47:04 -0400
Message-ID: <4FD75648.7060702@pengutronix.de>
Date: Tue, 12 Jun 2012 16:46:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
References: <4FC135C6.5030206@grandegger.com> <1338816766-7089-2-git-send-email-federico.vaga@gmail.com> <4FCCC077.7000303@pengutronix.de> <2105333.GQGP4hKIYU@harkonnen>
In-Reply-To: <2105333.GQGP4hKIYU@harkonnen>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig28374E933A468630350573AD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig28374E933A468630350573AD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/12/2012 04:25 PM, Federico Vaga wrote:
>>> +out_free_clock:
>>> +	if (!priv->priv)
>>
>>            ^^^
>>
>> looks fishy
>=20
> Also c_can_platform.c use priv->priv when it needs to get clk. I can ad=
d=20
> a comment to specify what the statement do.

> +out_free_clock:
> +	if (!priv->priv)
> +		clk_put(priv->priv);

Why do you call clk_put on priv->priv, if priv->priv is NULL?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig28374E933A468630350573AD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/XVkgACgkQjTAFq1RaXHPa2QCePTAWniuYkAWURBkjbmYbR7pe
wkEAn3+b16dz+073eYLCrWilNg8AdqkD
=VOy/
-----END PGP SIGNATURE-----

--------------enig28374E933A468630350573AD--
