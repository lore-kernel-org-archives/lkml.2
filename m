Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1KWPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:03:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33142 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1KWPDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:03:14 -0500
Date: Wed, 23 Nov 2011 16:03:12 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH 0/8] serial: 8250: support hw-based RS485 direction
 control (finally!)
Message-ID: <20111123150312.GH4063@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2011 at 05:24:37PM +0100, Wolfram Sang wrote:
> Some 8250-variants control the direction pin for RS485 in hardware. Linux=
 has
> RS485 support these days, so update the 8250-driver to adhere to that. Th=
ere
> have been attempts for mainlining this before. So, I started with the ver=
sion
> from Matthias which got no further comments, a proof-of-concept for the 1=
6V2750
> from J=FCrgen, and reworked it to match the current state of RS485 in Lin=
ux. Some
> minor cleanup patches came along the way. Really looking forward to
> comments/tags, because I think it is really time to get this functionalit=
y into
> mainline once and for all ;)

Ping. Claudio? What do you think? Matthias, are you still there?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7NCzAACgkQD27XaX1/VRtKDQCfX90JuzHxBmNyE93y7FdKO+VQ
OrAAnRy2LiZtXAJCRgctO/fVYMh2rGuu
=HgFy
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
