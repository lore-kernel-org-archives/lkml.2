Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2ASLhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:37:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2ASLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:37:10 -0500
Date: Thu, 19 Jan 2012 12:37:08 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: regmap: no indexed caching?
Message-ID: <20120119113708.GC2630@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

indexed caching was removed from regmap (commit 4c691664583ef6a91f9ed0e08a7=
5fbd30a5ffd5c)
saying:

    There should be no situation where it offers any advantage over rbtree
    and there are no current users so remove the code for simplicity.

What about devices having just a few registers (4 in my case)? I'd think
there are a number of such devices not yet converted to regmap. Is it
assumed that the additional overhead from rbtree-caching will make up
for the code saved?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8YAGQACgkQD27XaX1/VRuFFgCgpMu6iKD0F8RtyqqN4DCFyIRR
cPMAn0SPyBlWnrg2Pxn8n+n8MLkB4m42
=aeDV
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
