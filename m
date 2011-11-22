Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1KVMGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:06:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53333 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1KVMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:06:03 -0500
Message-ID: <4ECB9024.4070606@pengutronix.de>
Date: Tue, 22 Nov 2011 13:05:56 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] regmap: Fix build failure with CONFIG_DEBUG_FS=n
References: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de> <20111122115145.GA6624@sirena.org.uk>
In-Reply-To: <20111122115145.GA6624@sirena.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4C9401C811EBF50B3F772EAD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4C9401C811EBF50B3F772EAD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/22/2011 12:51 PM, Mark Brown wrote:
> On Tue, Nov 22, 2011 at 09:24:20AM +0100, Uwe Kleine-K??nig wrote:
>> This fixes:
>=20
> Thanks for the report - I'm going to apply a different fix to cut down
> the ifdefs.

sounds good

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig4C9401C811EBF50B3F772EAD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7LkCcACgkQjTAFq1RaXHM3nQCcCyPuFKBwBKA6ZTgccVodT2lO
vu8AoIp+YQaeIwj+TohsJyN1+r7Ko6aU
=ZUOs
-----END PGP SIGNATURE-----

--------------enig4C9401C811EBF50B3F772EAD--
