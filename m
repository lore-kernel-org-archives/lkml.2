Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2CYHkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 03:40:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36603 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2CYHkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 03:40:15 -0400
Date: Sun, 25 Mar 2012 09:40:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Peter Rusko <rusko.peter@prolan.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: PCA GPIO interrupt triggers
Message-ID: <20120325074012.GA25173@pengutronix.de>
References: <4F6B4C11.4000608@prolan.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <4F6B4C11.4000608@prolan.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I'm using a GPIO chip (PCA9554) for a matrix-keypad. The keypad
> driver itself needs interrupts for both rising and falling edges.
> The PCA driver (gpio-pca953x.c) doesn't support it, but I don't
> understand why.

? I fail to see why having EDGE_FALLING together with EDGE_RISING is not
supported. Are you sure you didn't use some other IRQ_TYPE here?

> I think, this patch should work:

Think? Can't you test it :)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9uy9wACgkQD27XaX1/VRsh9QCggLvaRPC5QAlNNZ2NTwEgoafY
L+cAn0n7lL3tmN10x+HU4346GXeOkIZ9
=UvFw
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
