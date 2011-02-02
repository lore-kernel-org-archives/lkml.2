Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1BBSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:20:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1BBSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:20:14 -0500
Date: Wed, 2 Feb 2011 19:20:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
Message-ID: <20110202182013.GA2924@pengutronix.de>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 02, 2011 at 03:05:16PM +0100, Geert Uytterhoeven wrote:

> Below is the list of build error/warning regressions/improvements in

Is it an idea to prefix regressions with "+" and improvements with "-" (so =
it
looks a bit like a diff)? In those long lists, it is quite easy to overlook
where you currently are.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1JoF0ACgkQD27XaX1/VRudiwCgga/mY1GsOPv4kFeZ44Ty+Ljk
lIkAnja5+nuqc1vZY6pJBgFu2M4DDF2L
=UGyy
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
