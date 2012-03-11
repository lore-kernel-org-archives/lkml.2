Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2CKLua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:50:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40889 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2CKLu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:50:27 -0400
Date: Sun, 11 Mar 2012 12:50:18 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de,
        spi-devel-general@lists.sourceforge.net, oskar@scara.com
Subject: Re: mfd: mc13xxx: add I2C support, V2
Message-ID: <20120311115018.GA16825@pengutronix.de>
References: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The only issue from V1 [0] not addressed is the use of regmap - mainly, I=
 don't
> have the time. I accept that this is a lame excuse but hope that use of r=
egmap=20
> can come later if it is required.

I really appreciate the effort, yet I fear that this is a show stopper. It =
gets
open coded what regmap is trying to abstract, adding complexity to the driv=
er
instead of (probably) reducing it. We could also get caching basically for
free, if this is desired. I think the regmap approach should have been tried
before we go custom. sound/soc/codecs/ad193x.c might give an impression how
regmap spi/i2c in one driver could look like.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9ckXoACgkQD27XaX1/VRu1TQCguTRzuYmuyD51yNY2sSrpVImy
UakAn07LT38X0rmZado25bkDMc1mMGCe
=uJOg
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
