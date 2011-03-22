Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1CVJKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:10:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52146 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1CVJKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:10:38 -0400
Date: Tue, 22 Mar 2011 10:10:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v6 6/6] powerpc, tqm5200: update tqm5200_defconfig to
 fit for charon board.
Message-ID: <20110322091027.GC2134@pengutronix.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
 <1300782452-528-7-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <1300782452-528-7-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>     As this board is tqm5200 based, added necessary changes
>     to the tqm5200_defconfig. In previous patchserie I added
>     the changes to mpc5200_defconfig, as Wolfram Sang mentioned,
>     but as tqm5200_defconfig is in mainline, and the board is
>     tqm5200 based, I think, thats the appropriate place, as

I'd think the perfect solution would have been to merge the
tqm-defconfig into the mpc5200-defconfig entirely and get rid of it.
That being said, I don't think this issue is big enough to block this
series, so fine enough with me.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2IZ4MACgkQD27XaX1/VRu7cQCfWpwfinmAeGn8hGBfiiU0IqlG
MkoAoLaw5f0WowSPgUmyBzmU9YvG4B6b
=7p51
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
