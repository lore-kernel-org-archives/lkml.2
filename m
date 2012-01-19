Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2ASI7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:59:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38373 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2ASI7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:59:18 -0500
Date: Thu, 19 Jan 2012 09:58:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, shawn.guo@linaro.org, artem.bityutskiy@intel.com,
        shijie8@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, LW@KARO-electronics.de,
        alsa-devel@alsa-project.org, b29396@freescale.com
Subject: Re: [PATCH 01/10] MXS-DMA : move the mxs-dma.h to a more common
 place
Message-ID: <20120119085856.GA2630@pengutronix.de>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
 <1326953767-24155-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1326953767-24155-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 19, 2012 at 02:15:58PM +0800, Huang Shijie wrote:
> Move the header to a more common place.
> The DMA engine is not only used in mx23/mx28, but also used
> in mx50/mx6q.
> It will also be used in the future chips.
>=20
> Rename it to mxs-dma.h
>=20
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  arch/arm/mach-mxs/include/mach/dma.h |   28 ----------------------------
>  include/linux/mxs-dma.h              |   28 ++++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 28 deletions(-)
>  delete mode 100644 arch/arm/mach-mxs/include/mach/dma.h
>  create mode 100644 include/linux/mxs-dma.h

Please use -M with git format-patch, so we can better see that it is a
pure rename.

I'd also suggest to squash patches up to 05/10 into this one,
(collecting all the proper acks from maintainers) since the changes are
trivial and it will reduce dependencies and temporary build-failures.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8X21AACgkQD27XaX1/VRsIbACgnuVCSNKUZmE6HcC0XqTK/eyL
wJYAn0szFKcf/BehDhzQimc88/A28S5+
=xo8Y
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
