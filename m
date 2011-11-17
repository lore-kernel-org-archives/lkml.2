Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1KQKKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:10:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49035 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1KQKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:10:01 -0500
Date: Thu, 17 Nov 2011 11:09:57 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Juergen Beisert <jbe@pengutronix.de>,
        Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH 2/8] serial: 8250: Add ioctl to enable auto rs485 mode
 with some Exar UARTs
Message-ID: <20111117100957.GC2535@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
 <1321460685-15753-3-git-send-email-w.sang@pengutronix.de>
 <4EC4D67E.1050102@evidence.eu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <4EC4D67E.1050102@evidence.eu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +		if (serial_inp(up, UART_FCTR)&  UART_FCTR_RS485)
> > +			rs485ctrl.flags =3D SER_RS485_ENABLED;
> > +		else
> > +			rs485ctrl.flags =3D 0;
>=20
> This else branch may be removed, since the structure has been already mem=
setted to 0.

Correct, yet I didn't want to change Matthias' code, so reviewers can
skip this patch if they reviewed his old code already. Flag handling
will be handled different with the next patch anyway.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7E3XUACgkQD27XaX1/VRvK1ACeOCUbtz7ToYJRme43QLSlEBX7
FBMAoKMsRe/OJ/4j57Q68dcZbHkpYYod
=QyTP
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
