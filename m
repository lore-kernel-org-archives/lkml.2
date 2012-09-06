Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2IFN0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:26:50 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37462 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab2IFN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:26:48 -0400
Date: Thu, 6 Sep 2012 16:22:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, tony@atomide.com, rnayak@ti.com,
        hvaibhav@ti.com, peter.ujfalusi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Subject: Re: [PATCH 0/4] arm/dts: omap: add dt data for MUSB
Message-ID: <20120906132223.GL29202@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344259395-4559-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FnOKg9Ah4tDwTfQS"
Content-Disposition: inline
In-Reply-To: <1344259395-4559-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 06, 2012 at 06:53:11PM +0530, Kishon Vijay Abraham I wrote:
> This patch series adds dt data for MUSB and related modules to
> get MUSB working
>=20
> These patches were initially part of
> [PATCH v6 00/11] omap: musb: Add device tree support
>=20
> These patches can be tested by applying it over
> [PATCH v7 0/7] omap: musb: Add device tree support
>=20
> These patches were developed on
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>=20
> If it needs to be rebased on some other tree, pls let me
> know.
>=20
> Performed MUSB device mode testing on omap4 panda,
> omap4 sdp and omap3 beagle

Grant, we already lost two merge windows on this patchset. Is it
possible for you to take a look here so we don't loose another merge
window ? Can Benoit just take these patches on his tree, so it goes
upstream through the linux-omap tree ?

cheers

> Kishon Vijay Abraham I (4):
>   arm/dts: omap: Add omap-usb2 dt data
>   arm/dts: Add twl6030-usb data
>   arm/dts: Add twl4030-usb data
>   arm/dts: omap: Add usb_otg and glue data
>=20
>  arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
>  arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
>  arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
>  arch/arm/boot/dts/omap4-panda.dts  |   10 ++++++++++
>  arch/arm/boot/dts/omap4-sdp.dts    |   10 ++++++++++
>  arch/arm/boot/dts/omap4.dtsi       |   13 +++++++++++++
>  arch/arm/boot/dts/twl4030.dtsi     |   21 +++++++++++++++++++++
>  arch/arm/boot/dts/twl6030.dtsi     |    5 +++++
>  8 files changed, 79 insertions(+)
>=20
> --=20
> 1.7.9.5
>=20

--=20
balbi

--FnOKg9Ah4tDwTfQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSKOPAAoJEIaOsuA1yqRE8NgP/2bap1F1tjAoanudoFaq9hkt
Vvq8eDgdGRs0W0zIy4U0KNqYOzaCbvByBWV9p1XKODf47stbDuk/uocIta4A0kNJ
gd9sG9lSmTkLvef4iIzU1gnlotidCJIOKKpbXbSvYAhy9GqK5hBYRsHNQMzCeGUS
h4rF4mhJ9UTO2Ks41NcLMwhM8rgJ3GM0hWIfSwmBk1ZJ0uY2NW+MUwD1DTgJHhnt
GaIpHfGp5PQUVSDCK0mg07e2Js733Avcj9nokNNJiiaubmzS2WIpj4C0JUirTUqH
Bt7s5Vev4hp++J969RbZY7ZVBgnXTwMKmGaJg/Qx+QmujAY8/9WUhrz/ava1OcoS
48p7V+m9nMng5stHJtReYZddtp5xwQp/TPCeEKwx5B8NfFvZ7v0zBYV6wAdeXCH2
r6tna5Pepm9OZWIdf2HpgxP1DRYJTFa4OWVo0DRLnsvgTsX8cOC5aw/jnbQMWvhJ
fDFORTEkzlQFCi4LuOVaceq3Tu6XIU2cYW8BmG2kg3uUpDXOmwG9iRwLk4kTs1wI
GfEafxpwkaPARCje2u/7sc9RRLLHEXsT4IaEgzRWnUMYK/mtk+UzTvBgGFl8gyO8
+wEiThwSdzpyegS7ibwvFU7LudrOmIVFsTXlixepD6yXgxnXA7nBalRuX3h6kxHK
CxnR9UaMDzkgXvo2AgA8
=JkbZ
-----END PGP SIGNATURE-----

--FnOKg9Ah4tDwTfQS--
