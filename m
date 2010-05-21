Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0EUNFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:05:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41832 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0EUNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:05:07 -0400
Date: Fri, 21 May 2010 15:04:17 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git next branch
Message-ID: <20100521130417.GB27829@pengutronix.de>
References: <1274433088.1931.63.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <1274433088.1931.63.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Wolfram Sang (4):
>       powerpc/pmac: Fix dangling pointers
>       i2c/mpc: Drop NO_IRQ
>       i2c/cpm: Drop NO_IRQ
>       i2c/ibm-iic: Drop NO_IRQ

Sorry for the confusion, but the other Ben (Dooks) has pushed those
NO_IRQ-thigies meanwhile.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv2hNEACgkQD27XaX1/VRu60QCgm3W5fvkTNJzcby/If0cSWC9d
I8EAn1MORnPkXUZ46HFyr5w9P2TDOxaT
=Ocp+
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
