Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2A1BOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 20:14:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2A1BOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 20:14:10 -0500
Date: Sat, 28 Jan 2012 02:14:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120128011403.GA6669@pengutronix.de>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
 <20120127162837.GB18572@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20120127162837.GB18572@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27, 2012 at 04:28:37PM +0000, Mark Brown wrote:
> On Fri, Jan 27, 2012 at 04:10:21PM +0100, Wolfram Sang wrote:
> > For the upcoming 2/6-format, we don't see debugfs output otherwise,
> > since the current division results in 0. I'd think 10/14 is broken
> > currently, too.
>=20
> This looks good but could you please rebase on top of topic/core, it
> conflicts with the support for padding bytes.  It's not really entirely
> incorrect, the bytes values aren't terribly well defined for register
> sizes that aren't integer numbers of bytes as they were never intended
> to be used then.  The assumption did leak out into debugfs though.

I wondered if you'd save reg_bits and val_bits there (converting to *_bytes
when needed), you could replace all the format_x_y-functions with a few gen=
eric
functions doing (reg << y) | val. Unsure if it is worth it...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8jS9sACgkQD27XaX1/VRt1bQCdHXDI0c3HFZiqhbs7ow7RxcN7
PjIAoJoh+50BtZIKsGuJcNPmaRDT4UHB
=V/HS
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
