Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2DFSWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:22:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2DFSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:22:44 -0400
Date: Fri, 6 Apr 2012 20:22:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Remy Bohmer <linux@bohmer.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Ivo Sieben <meltedpianoman@gmail.com>,
        Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120406182237.GB13649@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
 <20120403165320.GG19952@sequoia.sous-sol.org>
 <20120403170708.GC2477@pengutronix.de>
 <20120403171112.GH19952@sequoia.sous-sol.org>
 <20120403171736.GD2477@pengutronix.de>
 <CAMSQXEHpjD7LWQkKWJOU=9eFYqsaJi-xHFTxexQr7yoKiCG7HQ@mail.gmail.com>
 <20120404075956.GB9073@pengutronix.de>
 <CAMSQXEHxaJpmjpOz_VL54bs1W9x3kCJKGoeTCmBpZva_hSTVsw@mail.gmail.com>
 <20120405164354.GC16546@kroah.com>
 <CANqCtQJjzkANJQMd8E9XKvOyk_FLCm1ER=VznrQ+cAerGbO0zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <CANqCtQJjzkANJQMd8E9XKvOyk_FLCm1ER=VznrQ+cAerGbO0zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Is this acceptable for you Greg?

If so, don't forget my

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

given to the original patch.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9/NG0ACgkQD27XaX1/VRvWkgCePBHkUm7UmC/fw/gT0T4XFTc+
iIgAoJXrS4qZubgEU6a0k3lUsbQjSG+W
=ggCZ
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
