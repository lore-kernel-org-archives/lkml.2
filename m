Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764Ab0GOUtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:49:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934752Ab0GOUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:49:31 -0400
Date: Thu, 15 Jul 2010 22:49:27 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Luotao Fu <l.fu@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] touchscreen: fix sign bug
Message-ID: <20100715204927.GA4627@pengutronix.de>
Mail-Followup-To: Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1279219435-12128-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1279219435-12128-1-git-send-email-segooon@gmail.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:46:54 up 12 days, 11:57, 30 users,  load average: 1.38, 1.76,
	1.80
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 15, 2010 at 10:43:54PM +0400, Kulikov Vasiliy wrote:
> platform_get_irq_byname() can return negative results, it is not seen to
> unsigned ts_irq. Make it signed.
>=20
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-By: Luotao Fu <l.fu@pengutronix.de>

> ---
>  drivers/input/touchscreen/stmpe-ts.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchsc=
reen/stmpe-ts.c
> index 77f4374..656148e 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -269,7 +269,7 @@ static int __devinit stmpe_input_probe(struct platfor=
m_device *pdev)
>  	struct input_dev *idev;
>  	struct stmpe_ts_platform_data *ts_pdata =3D NULL;
>  	int ret =3D 0;
> -	unsigned int ts_irq;
> +	int ts_irq;
> =20
>  	ts_irq =3D platform_get_irq_byname(pdev, "FIFO_TH");
>  	if (ts_irq < 0)
> --=20
> 1.7.0.4
>=20

Stupid bug. Thanks for catching this.

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkw/dFcACgkQkLuxfMCkDTa94QCeIfDTQJ3QyKp+NBlIpwziYaHv
LAkAn3Tk6dEEQi3JdLaRib/jQiasf+Yq
=WNEP
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
