Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2HWGBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:01:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52509 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2HWGB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:01:28 -0400
Date: Wed, 22 Aug 2012 23:01:23 -0700
From: Tom Rini <trini@ti.com>
To: Matt Porter <mporter@ti.com>
Cc: vinod.koul@intel.com, cjb@laptop.org, grant.likely@secretlab.ca,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH v3 0/3] DaVinci DMA engine conversion
Message-ID: <20120823060123.GA12312@bill-the-cat>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <1345684176-21472-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 09:09:33PM -0400, Matt Porter wrote:

[snip]
> Matt Porter (3):
>   dmaengine: add TI EDMA DMA engine driver
>   mmc: davinci_mmc: convert to DMA engine API
>   spi: spi-davinci: convert to DMA engine API
>=20
>  drivers/dma/Kconfig            |   10 +
>  drivers/dma/Makefile           |    1 +
>  drivers/dma/edma.c             |  671 ++++++++++++++++++++++++++++++++++=
++++++
>  drivers/mmc/host/davinci_mmc.c |  271 +++++-----------
>  drivers/spi/spi-davinci.c      |  292 ++++++++---------
>  include/linux/edma.h           |   29 ++
>  6 files changed, 923 insertions(+), 351 deletions(-)
>  create mode 100644 drivers/dma/edma.c
>  create mode 100644 include/linux/edma.h

On the Logic PD AM1808 EVM:
mmc0 rootfs: http://pastebin.com/HKVdmA0G
jffs2 on the SPI flash rootfs: http://pastebin.com/cpAHgdug

Tested-by: Tom Rini <trini@ti.com>

--=20
Tom

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQNcczAAoJENk4IS6UOR1WbKoP/27KgPYRsTGlN4Rlg3nu0M2v
9lUG+/eG8IvOBRWILROIsS4StIeK9NjswsrGT9WJLzJvZCsRBkOYXqanMDYr9VES
4S56uwMsa7r/oYbi1OHEJSKfMqovHUB8PTw8BnDAGHgsB00kOefcuTYHtK6NROJI
4lhNar82jHSdRPZ+hb6+pcxrHAOu0RqZHuJJ0vyH4NE5jv2iUhI7VmPyivlU3SOe
J0LagMFEEl8Bnk0DsuZbjQh1aajjK3toKrapannnP6RUCcYzKx/6i2mdICINgl2t
v+uWcsoRvVahNB0TSLhyBJydqn/LqEehdEe4EYzFOBBLUi2aVSU/+oaov8rfQzBx
Iv821ti9P6FvKBWoFG4kPX5ITzVJ9cpaOcW/Zi8B4gF5MuzDz5zjjVSv10stRjSK
ySAv5YzRBXrykYb+DQvdz1FLqQdfF6/5QWU+kRSucgetjN7kXJlkE2aOy4JvTAVt
s+XQL+wxwOKz8SfU1JPpUFo7xOJvfbAVRCBDVC1MRrcJ9H8fjI/wYeVgoVVqMOk2
nxTaqz2j5pNfJaXuijHzofNfqh5QpHVIAfQgw239/BqzXUnXD2EvLnURfJjRf2aR
iZ4vBABR5U9gFCg5OcLKeEfmEOnyZ7VW6ameCZwJB6yFWTJikWvxU+wCyPdgSrGP
e2Av2e1OEnvmVGKs5AME
=YRVJ
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
