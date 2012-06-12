Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2FLIu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:50:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57614 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2FLIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:50:58 -0400
Date: Tue, 12 Jun 2012 10:50:40 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/4] i2c: tegra: Bug fixes, cleanups and M_NOSTART support
Message-ID: <20120612085040.GC9230@pengutronix.de>
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
 <4FCE3078.1030008@wwwdotorg.org>
 <4FCE3CD8.8060502@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <4FCE3CD8.8060502@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2012 at 10:37:36PM +0530, Laxman Dewangan wrote:
> On Tuesday 05 June 2012 09:44 PM, Stephen Warren wrote:
> >On 06/05/2012 07:09 AM, Laxman Dewangan wrote:
> >>This patch series having the:
> >>- Handling of late register write due to Tegra PPSB design.
> >>- support for I2C_M_NOSTART
> >>- Use devm_* for all allocation.
> >The series,
> >
> >Acked-by: Stephen Warren<swarren@wwwdotorg.org>
> >
> >Note that patch 4 touches context adjacent to Prashant's "i2c: tegra:
> >Add clk_prepare/clk_unprepare" patch, which I hope to take through the
> >Tegra tree since it's a requirement for the Tegra common clock
> >conversion. I don't think this will cause any significant conflict, but
> >perhaps it's worth resolving it explicitly.

Is it really a requirement? Just wondering if it will cause problems, if
Prashant's patch goes in via I2C after arm-soc has been merged. I am
fine with simply acking the patch, though.

> >Wolfram, perhaps we should put these 4 patches and Prashan'ts into their
> >own topic branch so that you can merge it into the I2C tree, and I can
> >merge it into the Tegra tree too? Or, I can take everything through
> >Tegra if you want, and ack it.

Laxman's patches should really go via I2C, I think. Can't we just fix
the conflict in arm-soc?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/XAuAACgkQD27XaX1/VRvJZACgmJUb4NCK9hURE+7FGYME/+LZ
OzEAoKY7E/RqXHNHCLmrYYM0lm5vXHfQ
=01H1
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
