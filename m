Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1C3ID1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:03:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60365 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1C3IDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:03:24 -0400
Date: Wed, 30 Mar 2011 10:02:23 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen
 Driver
Message-ID: <20110330080223.GB2232@pengutronix.de>
References: <1301446249-13646-1-git-send-email-cheiny@synaptics.com>
 <1301446249-13646-2-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <1301446249-13646-2-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> +	retval =3D rmi_register_sensor(&instancedata->rmiphysdrvr, platformdata=
->perfunctiondata);
> +	if (retval) {
> +		dev_err(&client->dev, "%s: Failed to Register %s sensor drivers\n",
> +				__func__, instancedata->rmiphysdrvr.name);
> +		i2c_set_clientdata(client, NULL);

I originally just wanted to say that this line can be removed. Then I
remembered that I already sent a patch for a similar driver in staging
(dc7b202a4ee6cb686e2bbef80c84443f43ec91bd). The staging driver looks in
a better shape to me. Do you know about it?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2S448ACgkQD27XaX1/VRsOdACffOvvpHwddb0yANlelOwKNIxc
eGsAoKzVsj5ZQ9IIBXhUUFI2Sw//diK5
=AD2T
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
