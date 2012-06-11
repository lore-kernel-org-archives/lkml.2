Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2FKQeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:34:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38445 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2FKQeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:34:02 -0400
Date: Mon, 11 Jun 2012 18:33:57 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: sonic.zhang@analog.com, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing
 I2C transfer if MEN bit is reset unexpectedly.
Message-ID: <20120611163357.GE3887@pengutronix.de>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
 <CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Content-Disposition: inline
In-Reply-To: <CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 17, 2012 at 05:00:40PM +0530, Shubhrajyoti Datta wrote:
> On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> >
> > Correct I2C transfer may fail because interrupt status bits XMTSERV and
> > RCVSERV are not checked when MCOMP interrupt is handled.
> >
> Could you expand MCOMP?

I agree. It is nice to understand patch descriptions without needing to
know all the datasheet terminology, so please rework the description a
little.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WHfUACgkQD27XaX1/VRsfigCeJXnlD8bakgy760zwhwD61sfF
ogEAnjHsnD/rk8bddZWImg4K4vn+sk61
=noP8
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
