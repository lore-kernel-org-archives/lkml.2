Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1A3WOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 17:14:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1A3WOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 17:14:44 -0500
Date: Sun, 30 Jan 2011 23:14:34 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joachim Eastwood <manabian@gmail.com>
Cc: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        joachim.eastwood@jotron.com
Subject: Re: [leds-pca9532] Add gpio capability v2
Message-ID: <20110130221434.GB28220@pengutronix.de>
References: <AANLkTinuphNyLoFz1TLxFJ6=g+GMph6njGhs2FBB6Evj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <AANLkTinuphNyLoFz1TLxFJ6=g+GMph6njGhs2FBB6Evj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 30, 2011 at 09:20:13PM +0100, Joachim Eastwood wrote:
> Hello,
>=20
> This is v2 of the patch to add gpio capability to the leds-pca9532
> driver. Please read the first mail in this thread for more
> information.
>=20
> Changes in v2:
> * Add Kconfig magic. gpio capability is now optional
> * Addressed review from Wolfram Sang
>=20
> Wolfram: If this looks okey can I add your Reviewed-by tag?

The patch seems line-wrapped. Is checkpatch happy (enough), too?
Other than that looks good to me:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1F4soACgkQD27XaX1/VRvrLQCgpgfO88OCvM05+QIxaSV2LDRi
L/YAoKODhHKkogJdq3W1s1x0IuhvfceD
=+iVA
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
