Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2GJIie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:38:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53797 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2GJIic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:38:32 -0400
Date: Tue, 10 Jul 2012 10:38:19 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120710083819.GA25197@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 04:41:30PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/i2c/busses/i2c-nomadik.c between commit af97bace2cca
> ("i2c-nomadik: move header to <linux/platform_data/i2c-nomadik.h>") from
> the i2c-embedded tree and commits 32e42c687e0a ("ARM: ux500: Remove
> unused i2c platform_data initialisation code") and 8214fd238a66 ("i2c:
> Add Device Tree support to the Nomadik I2C driver") from the arm-soc tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary.
> Please check this and talk to each other ...

Hmm, I can't recall any discussion that the DT support patch should go
in via arm-soc. Did I miss something? Right now, I'd think it should go
in via i2c. I am fine with the other patch going in via arm-soc, but can
carry it as well.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/76fsACgkQD27XaX1/VRvjmQCgku1NQ2i5RzwCJpUb7OFj0T1Y
8rEAnA26ufeXf40O2y/Wrt597dFNNVbt
=Kh7M
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
