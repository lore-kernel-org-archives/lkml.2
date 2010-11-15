Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab0KOW2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:28:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51203 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab0KOW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:28:28 -0500
Date: Mon, 15 Nov 2010 23:28:15 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sergio Aguirre <saaguirre@ti.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Philipp Wiesner <p.wiesner@phytec.de>,
        =?iso-8859-15?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: video: do not clear 'driver' from an i2c_client
Message-ID: <20101115222815.GB25167@pengutronix.de>
References: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 10, 2010 at 03:14:13PM +0100, Wolfram Sang wrote:
> The i2c-core does this already.
>=20
> Reported-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>=20
> Not sure if this should go via i2c or media?

Okay, as Jean did not pick it up in his latest pull request, I guess this m=
eans
it shall go via the media-tree? :) Mauro, will you pick it up?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkzhs/8ACgkQD27XaX1/VRvWegCfVM9iYnOkrjJqwXN/NkSvPCp3
9GUAoI6SAxrwPd4WTAouJIfU7DpENPAn
=RhbN
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
