Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1L1VyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:54:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58721 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1L1VyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:54:07 -0500
Date: Wed, 28 Dec 2011 22:53:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Olof Johansson <olof@lixom.net>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH RESEND] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111228215333.GA13515@pengutronix.de>
References: <1325076512.6997.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1325076512.6997.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2011 at 08:48:32PM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
>=20
> Use DEFINE_PCI_DEVICE_TABLE ensures we make the pci_device_id table const
> and marked as __devinitconst.
>=20
> This also fixes some warnings from checkpatch:
> e.g.
> WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> #1096: FILE: i2c/busses/i2c-intel-mid.c:1096:
> +static struct pci_device_id intel_mid_i2c_ids[] =3D {
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Cool, thanks for the update!

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk77j90ACgkQD27XaX1/VRtAbQCdFBrZGeDihrgq7W1Ckl24Mw4U
M6sAn3WRWfjPravbkxQtGSDGvlouDpXU
=c5TY
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
