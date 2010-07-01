Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0GAKvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:51:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0GAKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:50:57 -0400
Date: Thu, 1 Jul 2010 12:50:43 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Martin Fuzzey <mfuzzey@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Sascha Hauer <kernel@pengutronix.de>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: add flag to avoid disabling clk multiple times
Message-ID: <20100701105043.GB4092@pengutronix.de>
Mail-Followup-To: Martin Fuzzey <mfuzzey@gmail.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Sascha Hauer <kernel@pengutronix.de>, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1275561288-20661-1-git-send-email-l.fu@pengutronix.de>
 <4C1CE6B8.4090504@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <4C1CE6B8.4090504@gmail.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:46:06 up  4:33, 12 users,  load average: 0.06, 0.03, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Sat, Jun 19, 2010 at 05:48:08PM +0200, Martin Fuzzey wrote:
> Hi Luotao,
>=20
> Luotao Fu wrote:

=2E...
> Your patch fixes the clock_disable problem but fbi->backlight_power()
> and fbi->lcd_power() can still be called multiple times.
> Not sure if that is really a problem - they should be idempotent.
>=20
> I did it by making all of imxfb_disable_controller() do nothing if the
> disable was already done like this  (just for illustration not submission,
> lines may be mangled):
>=20

Anything new on this? 'd be nice if you could resend a clean patch based
on the described you sent in this mail. There're about 3 Patches about
this issue out there. More might come in, as long as the bug still
exists. ;-) So let's pack it up and push a proper fix to Sascha.

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwscwMACgkQkLuxfMCkDTZxCQCfbNb2dMseo0tUAeqPUN8FFmq4
As8AnR+Jp9lED+D3ZKNZOh3F+jRZCiEE
=XHxL
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
