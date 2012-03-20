Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab2CTHvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:51:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42278 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2CTHvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:51:04 -0400
Date: Tue, 20 Mar 2012 08:50:59 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] net: phylib: remove the length limitation of mii
 bus id
Message-ID: <20120320075059.GA3849@pengutronix.de>
References: <1332217679-3703-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1332217679-3703-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Aisheng,

> So changed to remove the bus id length limitation, a lot of handwork.

You might want to try 'coccinelle' [1] next time. This is a tool exactly for
such kind of work. Already some basic knowledge can help you for a
number of tasks.

Regards,

   Wolfram

[1] http://en.wikipedia.org/wiki/Coccinelle_%28software%29

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9oNuMACgkQD27XaX1/VRvAMQCdFedF2bnIx04zEuzkDEkZEW8T
V34AoIOx7Lexc/rUkqdmKIBF1trvRta2
=qftQ
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
