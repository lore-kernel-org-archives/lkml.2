Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0C3Mj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:39:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab0C3MjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:39:24 -0400
Date: Tue, 30 Mar 2010 14:39:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jean Delvare <khali@linux-fr.org>, kernel-janitors@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100330123912.GI29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <20100321144655.4747fd2a@hyperion.delvare> <20100321141417.GA19626@opensource.wolfsonmicro.com> <201003211709.56319.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Content-Disposition: inline
In-Reply-To: <201003211709.56319.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hans,

> But this just feels like an i2c core thing to me. After remove() is called
> the core should just set the client data to NULL. If there are drivers th=
at
> rely on the current behavior, then those drivers should be reviewed first=
 as
> to the reason why they need it.

It will be done this way now. As you have taken part in the discussion, I g=
uess
the media-subsystem never really considered picking those patches up ;)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux8PAACgkQD27XaX1/VRsNLACeMRihdtZYj1mX2Ywgi3AXwWp2
yycAoJeFx9bZZCseZnxm8vkZ1NroWbF/
=94gs
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
