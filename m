Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1L0PSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:18:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1L0PST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:18:19 -0500
Date: Tue, 27 Dec 2011 16:17:43 +0100
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
Subject: Re: [PATCH] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111227151743.GA3605@pengutronix.de>
References: <1324956897.9775.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <1324956897.9775.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 27, 2011 at 11:34:57AM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.

Please not only describe what the patch does but also why it is needed or a
good idea. People looking up stuff later on might not know.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk754ZcACgkQD27XaX1/VRuHngCdEoilO9/t9kcSWxQdEOeKv4zM
Fd0AoL8mhIhxJTjEw9uacYs4qG0l4UQH
=bKvr
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
