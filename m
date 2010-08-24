Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0HXFRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:17:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57088 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0HXFRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:17:18 -0400
Date: Tue, 24 Aug 2010 07:16:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Hemanth V <hemanthv@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jingchang Lu <b22599@freescale.com>,
        Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] i2c: remove obsolete cleanup for clientdata
Message-ID: <20100824051639.GA436@pengutronix.de>
References: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de> <AANLkTikupuVAhC9Dj-9QgDzMVBd6vfh5OjFXGsXnwnFK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <AANLkTikupuVAhC9Dj-9QgDzMVBd6vfh5OjFXGsXnwnFK@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
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

On Mon, Aug 23, 2010 at 05:58:17PM -0400, Mike Frysinger wrote:
> On Mon, Aug 23, 2010 at 11:05, Wolfram Sang <wrote:
> > A few new i2c-drivers came into the kernel which clear the clientdata-p=
ointer
> > on exit. This is obsolete meanwhile, so fix it and hope the word will s=
pread.
>=20
> on a related note, do we need to clear it when erroring at probe time
> ?  doesnt seem like that is necessary either ...

Correct, you don't have to. The core will do it.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkxzVbcACgkQD27XaX1/VRtUJACgpRoADMt+2wWflWiR16/XDxYx
BkIAoJeO0XtvOqgJn0ZHD420NJq89llw
=FzSa
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
