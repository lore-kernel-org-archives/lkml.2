Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1CVJGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:06:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41509 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1CVJGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:06:51 -0400
Date: Tue, 22 Mar 2011 10:06:35 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v1 1/6] powerpc, 5200: add support for charon board
Message-ID: <20110322090635.GB2134@pengutronix.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
 <1300782452-528-2-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <1300782452-528-2-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 22, 2011 at 09:27:27AM +0100, Heiko Schocher wrote:
> Signed-off-by: Heiko Schocher <hs@denx.de>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> cc: Wolfram Sang <w.sang@pengutronix.de>
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> cc: linux-fbdev@vger.kernel.org
> cc: devicetree-discuss@ozlabs.org
> cc: Ben Dooks <ben@simtec.co.uk>
> cc: Vincent Sanders <vince@simtec.co.uk>
> cc: Samuel Ortiz <sameo@linux.intel.com>
> cc: linux-kernel@vger.kernel.org
> cc: Randy Dunlap <rdunlap@xenotime.net>
> cc: Wolfgang Denk <wd@denx.de>
> cc: Paul Mundt <lethal@linux-sh.org>
> ---
> - changes since v1:
>   add comments from Wolfram Sang
>   - no defconfig file
>   - comment corrected in DTS
>   - boardlist sorted alphabetically
>   - commit log without boardinfo
> - changes for v6:
>   - rebased against current head
>   - repost complete patchserie
>   - added Acked-by from Benjamin Herrenschmidt
>=20
>  arch/powerpc/boot/dts/charon.dts             |  226 ++++++++++++++++++++=
++++++
>  arch/powerpc/platforms/52xx/mpc5200_simple.c |    1 +
>  2 files changed, 227 insertions(+), 0 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/charon.dts

AFAICR all my concerns have been addressed, so

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2IZpsACgkQD27XaX1/VRs9NACgr8W3jgII/9j+wwDHI0DxGQkf
WigAoJSodGGj2+gxQNZDayA3A1skv4oa
=EIfN
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
