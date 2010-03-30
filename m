Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0C3M2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:28:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0C3M2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:28:37 -0400
Date: Tue, 30 Mar 2010 14:28:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ryan Mallon <ryan@bluewatersys.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 02/24] power/ds2782: really clear i2c_clientdata on exit
Message-ID: <20100330122834.GD29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-3-git-send-email-w.sang@pengutronix.de> <20100322170810.GA30325@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <20100322170810.GA30325@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Why is this needed? I'd vote for just removing set_clientdata in
> fail/remove paths.

Yes, it will be done this way. I will prepare the necessary cleanups for
2.6.35. Please drop this patch.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux7nIACgkQD27XaX1/VRtwVgCgktG65wiSfWynE/Ysg29wExEe
ZZMAnj2B3w9xn+Cg5pSet6T/UIEYRWr9
=t4mc
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
