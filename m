Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab0JZSwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:52:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0JZSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:52:33 -0400
Message-ID: <4CC72360.1070608@pengutronix.de>
Date: Tue, 26 Oct 2010 20:52:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: David Miller <davem@davemloft.net>, andrew.chih.howe.khor@intel.com,
        masa-korg@dsn.okisemi.com, sameo@linux.intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        morinaga526@dsn.okisemi.com, yong.y.wang@intel.com, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net>	<20101026.105545.200376685.davem@davemloft.net> <4CC71DA4.3020600@grandegger.com>
In-Reply-To: <4CC71DA4.3020600@grandegger.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig25F0404BD3A0EB13A51464B9"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25F0404BD3A0EB13A51464B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/26/2010 08:27 PM, Wolfgang Grandegger wrote:

> Oh, this patch has various other issues, as Marc and I have already
> pointed out, which should be fixed before the driver hits the user.
> Unfortunately, the CC to netdev of our reviews got lost somehow, sorry

After noticing my faul I resend my review to the netdev + socketcan
mailinglists and the individual persons mentioned in the original patch.

> for the inconvenience, but the original author should have received it.=

> Tomoya, could you (or somebody else) please also fix the remaining
> issues quickly?

For reference, here it is:
http://www.spinics.net/lists/netdev/msg144852.html

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig25F0404BD3A0EB13A51464B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzHI2QACgkQjTAFq1RaXHM/DwCcCvIFej7VdTLSPUr9ezOmk7Ua
f7wAn3qmz+Km9M8/Z6XgsfyrHnUepWZY
=ZbQZ
-----END PGP SIGNATURE-----

--------------enig25F0404BD3A0EB13A51464B9--
