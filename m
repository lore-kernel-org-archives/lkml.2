Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab1K0IuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 03:50:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1K0IuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 03:50:23 -0500
Date: Sun, 27 Nov 2011 09:50:17 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use
 module_platform_driver()
Message-ID: <20111127085017.GB5263@pengutronix.de>
References: <1322369586.2522.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1322369586.2522.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 27, 2011 at 12:53:06PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/pcmcia/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7R+ckACgkQD27XaX1/VRu3xwCgkZZwZrR+QPGyMBE0la6Pa8gr
ga4AniftxAWwrcNz0YZ3IxChyaNtnWZX
=Z6l9
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
