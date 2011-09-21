Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1IUKbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:31:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38622 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1IUKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:31:52 -0400
Date: Wed, 21 Sep 2011 12:31:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, yong.zhang0@gmail.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Wan ZongShun <mcuos.com@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [rtc-linux] [PATCH 46/57] rtc: irq: Remove IRQF_DISABLED
Message-ID: <20110921103148.GB1966@pengutronix.de>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-47-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <1316597339-29861-47-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2011 at 05:28:47PM +0800, Yong Zhang wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled=
],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>=20
> So now this flag is a NOOP and can be removed.
>=20
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk55vRQACgkQD27XaX1/VRt25wCcCXsHPJWh/pPcXnQxtBVTGEaA
KscAoKVT5YrNLDwHLpI/2D0DiaRh/wSL
=uMlT
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
