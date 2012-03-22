Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab2CVVrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:47:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45255 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2CVVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:47:39 -0400
Date: Thu, 22 Mar 2012 22:47:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: hskinnemoen@gmail.com, linux@arm.linux.org.uk,
        Rade Bozic <rade.bozic.ext@nsn.com>, ben-linux@fluff.org,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        bigeasy@linutronix.de, m.szyprowski@samsung.com,
        grant.likely@secretlab.ca, kyungmin.park@samsung.com,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't
 explictly specified
Message-ID: <20120322214714.GA24684@pengutronix.de>
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
 <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com>
 <4F6B4532.7090806@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <4F6B4532.7090806@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Dear Haavard, Rade, Wolfram and Russel
>=20
> Could you review following changes for gpio, octeon, pca-platform
> and versatile i2c controller drivers (for which you are, or were,
> maintainers)?
>=20
> Grant requested explicit Ack to get this merged.

? Since those are I2C patches, I was assuming that I pick them. After the m=
erge
window, that is. Did I miss something?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9rneIACgkQD27XaX1/VRtLVwCeLQKz4JTOjSswrVzUL8An9geQ
0GwAoKqQ4HeiHX3DMPLTuhluNHjJPxqR
=fsnM
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
