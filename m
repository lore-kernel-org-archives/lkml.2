Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1FOAef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:34:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45577 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FOAed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:34:33 -0400
Date: Wed, 15 Jun 2011 10:34:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH 2/2] gpio: include linux/gpio.h where needed
Message-Id: <20110615103420.1578eb5c.sfr@canb.auug.org.au>
In-Reply-To: <20110614170602.7a51b1af.randy.dunlap@oracle.com>
References: <4DDB3AFF.9030006@oracle.com>
	<20110524075248.GB19734@sirena.org.uk>
	<20110527074552.GA907@ponder.secretlab.ca>
	<4DDFE391.2030507@oracle.com>
	<20110527201201.GA6645@ponder.secretlab.ca>
	<BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
	<20110603171837.GA9918@opensource.wolfsonmicro.com>
	<BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
	<4DEC4D67.6010506@oracle.com>
	<20110614091211.465553de.randy.dunlap@oracle.com>
	<20110614161357.GB1839@ponder.secretlab.ca>
	<20110614170602.7a51b1af.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jun_2011_10_34_20_+1000_eEv+UJVGIb5jaCpk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jun_2011_10_34_20_+1000_eEv+UJVGIb5jaCpk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 14 Jun 2011 17:06:02 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Some files use GPIOF_ macros but don't include the header file
> for them.  These macros are being moved to <linux/gpio.h>, so add
> includes for <linux/gpio.h> where needed.

Shouldn't these patches be in the other order to avoid bisection problems?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jun_2011_10_34_20_+1000_eEv+UJVGIb5jaCpk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9/4MAAoJEDMEi1NhKgbsPmIH/jcSid3qbYU9J/uN7GaaISSk
1rm+wUlbmhCEao0a2PI/hJG0RR4v3P+cLgXb9JlB7KnFu62NT4+hwktKxxEr2OVy
FlGDymANSLGHqZHNUzuU7NHfXgiCT7hiwpTJdpWPxI2X4MOlPwKwuB4gWn3jLDqS
vmmBB7zfAIHXFleMJ9cGN/ziRoFsl/s6MpWsyaLO7ZeDMBeY/id00iSis8QJVGnA
OGsg3Qfvz7g8pbq0xijzFMLilLxh80Ok34BdkMRC5bhYJTplQhYpi1ANRUktWPMW
wKG9QUKKNKvM8L+YcBz0ojDPe9WWdx32/P2/DCZkRABHW+vhn+HVQ/EMS0jPc5M=
=f3ZQ
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jun_2011_10_34_20_+1000_eEv+UJVGIb5jaCpk--
