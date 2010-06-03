Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785Ab0FCEBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:01:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45546 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0FCEBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:01:47 -0400
Date: Thu, 3 Jun 2010 06:01:42 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [git pull] (updated) OF-related build breakage fixes
Message-ID: <20100603040142.GB32748@pengutronix.de>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2010 at 09:06:54PM -0600, Grant Likely wrote:
> Updated pull request.  Added more fixes from Anatolij of the same sort.

Just a second. I think I found two more (using coccinelle)...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwHKSYACgkQD27XaX1/VRsCxQCfcBNEiNeFue4iA6HuWU2hAv2d
ZQcAoMn54ldKtj26RG7PWv4KOMDroV5n
=FJJX
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
