Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1DRQHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:07:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40706 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1DRQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:07:05 -0400
Date: Mon, 18 Apr 2011 18:06:58 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110418160658.GD23814@pengutronix.de>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> For example with "uio" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] =3D=
 {
> 	{ .compatible =3D "uio", },
> 	{ /* empty for now */ },
> };

Please use a proper example with "vendor,device".
(And after that it won't be empty anymore)

> +		/* Multiple IRQs are not supported */
> +		irq =3D platform_get_irq(pdev, 0);
> +		if (irq < 0) {
> +			uioinfo->irq =3D UIO_IRQ_NONE;
> +			dev_info(&pdev->dev, "no IRQ found\n");
> +		} else {
> +			uioinfo->irq =3D irq;
> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
> +		}

Come to think of it, the driver so far does not print any dev_info messages,
only err and warn. So, I'd think these messages should go, too, but this is=
 up
to Hans.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2sYaIACgkQD27XaX1/VRtjtQCfeaOx0SOga+UL3/wrlPRIoGFx
uqcAoKaLCRFaDUMJL0p0BIO2aAbtFaO3
=OjG4
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
