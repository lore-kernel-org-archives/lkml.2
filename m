Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0FMBEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 21:04:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44278 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab0FMBEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 21:04:35 -0400
Date: Sun, 13 Jun 2010 03:04:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fredrik Gustafsson <iveqy@iveqy.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl skip long lines
Message-ID: <20100613010429.GA31692@pengutronix.de>
References: <20100612170944.GA9121@iveqy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20100612170944.GA9121@iveqy.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

On Sat, Jun 12, 2010 at 07:09:44PM +0200, Fredrik Gustafsson wrote:

> since the number of long lines in the linux kernel is huge and since
> Greg Kroah Hartman in his google tech talk about the kernel
> (http://www.youtube.com/watch?v=3DL2SED6sewRw) talked about probably
> ignore that criteria in the future, I thought the checkpatch.pl script
> should have an option to ignore checking for long lines.
>=20
> This would help finding the real errors and warnings, because they don't
> drown in line length warnings.

Instead of adding another command-line option, I'd suggest to just use CHK
instead of WARN, so this check will be enabled with --strict. I wonder if t=
here
is already consensus on deprecating the 80-char-rule?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwULp0ACgkQD27XaX1/VRsywwCfWu+ysis5+ymvVOprD6nVB1oC
VrYAoK14AQUSiEdnWEPj5ypwQKPjDpdP
=oV0h
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
