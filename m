Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2DPGZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:25:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2DPGZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:25:29 -0400
Date: Mon, 16 Apr 2012 08:24:48 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH 4/4] ARM: LPC32xx: Device tree support
Message-ID: <20120416062444.GD3037@avionic-0098.adnet.avionic-design.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
 <1334400790-10892-5-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Content-Disposition: inline
In-Reply-To: <1334400790-10892-5-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:HSwvgFbjdQ0rnI4o8t3Nqo+9zBrGqv/Vd4qi2xv517b
 EPmcHToCNgbVLuwc4A4114lO6dJ69PnGCPtwfkLxSjeu3yHSCF
 TagZc9h1HeK1Cv+8rqOAV6kqBePnywbJ4d92fknKtr2I0OMDSW
 XaUW6125VCxq4re9b9C2k7AEmVmFh+99Wm8l2q3zilfHVDK3od
 HGYlKEk7a6heoTvKxnbBRoXHYgh0EnMIlqTPMpQY6+R8ZnShYu
 /2zKI5dJSQdzeAPW2YZb+Zv3iWpjzTQO4xQHrKv7Drh5y6qfiS
 aNxoj8KmcbW+XuxfjyQ3ov3Ai0j5fPJfdNNqOI6r9WXaAvDvHF
 ntnAF4vVTmL1tcX1/2upT7WHczWLEJhp21vlspuS1RNLqhf9t9
 G2HwDZ7B9ZYmx8xxhLXlWKyqNBsaUqQbp4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Roland Stigge wrote:
> This patch adds device tree support for the LPC32xx SoC
>=20
> arch/arm/boot/dts/lpc32xx.dtsi: Include for devices based on LPC32xx
> arch/arm/boot/dts/phy3250.dts: Board support for PHYTEC phyCORE-LPC3250
> arch/arm/boot/mach-lpc32xx/irq.c: irq domain conversion
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
>=20
> Applies to v3.4-rc2 and requires the previously posted lpc32xx driver dt
> patches (Set 1: 1..8 + GPIO patch)
>=20
>  Documentation/devicetree/bindings/arm/lpc32xx-mic.txt |   38 ++
>  Documentation/devicetree/bindings/arm/lpc32xx.txt     |    8=20
>  arch/arm/Kconfig                                      |    1=20
>  arch/arm/boot/dts/lpc32xx.dtsi                        |  303 +++++++++++=
+++++++
>  arch/arm/boot/dts/phy3250.dts                         |  108 ++++++
>  arch/arm/mach-lpc32xx/Kconfig                         |   26 -
>  arch/arm/mach-lpc32xx/clock.c                         |   77 ++--
>  arch/arm/mach-lpc32xx/common.c                        |  192 -----------
>  arch/arm/mach-lpc32xx/common.h                        |   14=20
>  arch/arm/mach-lpc32xx/irq.c                           |   78 +++-
>  arch/arm/mach-lpc32xx/phy3250.c                       |  146 +++-----
>  11 files changed, 613 insertions(+), 378 deletions(-)

This looks like too many unrelated changes for one patch.

Thierry

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+LuysACgkQZ+BJyKLjJp/YYACffDx5L5Bnn1/UnZDkRiewtD/p
Fc8An3lHrjlrPZyPRy+8HO12pgxJK2ro
=FLPw
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
