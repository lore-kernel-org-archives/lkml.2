Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2LRKJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:09:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38963 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2LRKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:09:18 -0500
Date: Tue, 18 Dec 2012 11:09:06 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
Message-ID: <20121218100906.GB2612@pengutronix.de>
References: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
 <20121218105223.0184d4a3@endymion.delvare>
 <CAH7P7Nhz2FpBct4afvAXU2Zgi-yA4TkJj7CtYMaW7pXr6weZig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <CAH7P7Nhz2FpBct4afvAXU2Zgi-yA4TkJj7CtYMaW7pXr6weZig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> i have planned fixing these too, do you prefer one patch fixing all or
> multiple patches (one per error/warning type )?

One patch, definately. You can skip the 80 char thing. Are you also able
to build-test the changes?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDQQMIACgkQD27XaX1/VRtvfQCeMIzrA2Lq2W0IzmYzkyncSKK9
bhgAoIAu4ve/Wf4Qi9Ix/G9DqQCz/dEh
=ZNY1
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
