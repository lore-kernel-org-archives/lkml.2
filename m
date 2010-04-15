Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0DOCxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:53:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45622 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0DOCx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:53:29 -0400
Date: Thu, 15 Apr 2010 04:53:21 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
       saeed.bishara@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for
	AMD flashes
Message-ID: <20100415025321.GB14954@pengutronix.de>
References: <1271221078.2532.5.camel@localhost.localdomain> <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 14, 2010 at 05:57:33PM -0700, Kevin Cernekee wrote:
> Ensure that the flash device is in a quiescent state before rebooting.
> The implementation is closely modeled after the cfe_cmdset_0001 reboot
> notifier, commit 963a6fb0a0d336d0513083b7e4b5c3ff9d6d2061 .
>=20
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Yes, if this is present for Intel, it should be present for AMD, IMHO.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Still, the correct solution is to wire the correct reset-line to the flashe=
s.
Above patch will not help if a watchdog kicks in. Been there :(

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvGf6EACgkQD27XaX1/VRuxvACdGIp8CjRPZTaXtOm7sFBP+5uL
fFsAn1p7OC/twVIhzbn+tMW3MG1EDyPJ
=9H/B
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
