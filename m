Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0DDONp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:13:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57659 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0DDONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:13:38 -0400
Date: Sun, 4 Apr 2010 16:13:36 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryan Mallon <ryan@bluewatersys.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] power/ds2782: fix clientdata on removal
Message-ID: <20100404141336.GA10176@pengutronix.de>
References: <1270117664-29099-1-git-send-email-w.sang@pengutronix.de> <20100401104021.GA30121@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20100401104021.GA30121@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 01, 2010 at 02:40:21PM +0400, Anton Vorontsov wrote:
> On Thu, Apr 01, 2010 at 12:27:44PM +0200, Wolfram Sang wrote:
> > Probably due to a copy & paste bug, clientdata was set again to the data
> > structure (which is freed immediately afterwards) when it should be
> > NULLed. Just remove the calls as the i2c-core does this automatically
> > now.
> >=20
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Ryan Mallon <ryan@bluewatersys.com>
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > ---
> >
> > Anton: If it is okay with you, I think this should go via the I2C-tree =
to
> > ensure it comes after the needed modification of the i2c-core.
>=20
> Sure thing.
>=20
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Sorry, I misunderstood Jean. Would be nice if you could pick it up. Sorry f=
or
the noise.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAku4npAACgkQD27XaX1/VRvsegCeIoetMb5GVUlQ8O1vxuY3V9nY
NWgAoJk9wtdhvTNRtPJJV3cw9/Q0a3G+
=NQyl
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
