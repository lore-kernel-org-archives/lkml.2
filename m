Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2KVVQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:16:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab2KVVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:16:32 -0500
Date: Thu, 22 Nov 2012 22:16:16 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 00/11] Support for AM33xx PWM Subsystem
Message-ID: <20121122211616.GK16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:dhqBcjty3ZwAr9FflxG6LAxYhCzj0wK32N57wH+PXn5
 t91zVt0C9CKMy/x288DYT71F8MqxiM8PNVPSx13xke/EOmyUWf
 GDvbo2jVqnl8Mn+Q6eH0FqRQypBypbL6AdAz5DErsn7cOZSgnm
 Mn9x1Sh0/gJXrTRLUclqCpj/izOdzSLsyn6k05eOOe9eX+ADZY
 moJKB5DLAx5JvjJglK+j2dzeRJeX2QmIqfImkLIe2Q2SwuprVJ
 wKvrnnYJZpAV2XA+GSAMV+fzaCXO6Ob41fzCk57TgGx15L6wQE
 E6+MrqcTuQHSFp47/xniIXcuMWoNFh0aJ45x3IU3vz0R459G1q
 2l5ct+Zt1Yl1NItjdwvO7wgyHJWHt8ZzmGWFacIBiiydeKemQ8
 4ghUejBBjOwPZY/w+YUT43jdNLYc1D4R5NDPjsueAfehZe+9Ku
 rYTNe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 06:40:57PM +0530, Philip, Avinash wrote:
> In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
> PWM subsystem. All these submodules shares the resources (clock) & has
> a clock gating register in PWM Subsystem. This patch series creates a
> parent PWM Subsystem driver to handle access synchronization of shared
> resources & clock gating from PWM Subsystem configuration space.
> Also Device tree nodes populated to support parent child relation
> between PWMSS, ECAP & EHRPWM submodules.
> In addition EHRPWM module requires explicit clock gating from control
> module & is handled by patch #2 & 8.
>=20
> As suggested by  Thierry for handling clock gating for PWM submodules
> should handle with a global function. This requires config space
> handling done independent from driver and is done at parent driver.
>=20
> So the parent<->child relation adopted to handle
> 1. pm runtime synchronization
> 2. PWM subsystem common config space clock gating for PWM submodules.
>=20
> Patches supports
> - Driver support for parent child relation handled patch #1
> - Optional EHRPWM tb clock in patch #2
> - Parent child in HWMOD handled at patch #3
> - Device tree binding support handled in patch #4, 6 &8
> - pinctrl support in patch #5 & 7.
> - DT node populated in patch #9 ,10 & 11.
>=20
> This patch series based on omap_dt/for_3.8/dts_part2 and tested
> on am335x-evm & am335x-evmsk.
>=20
> It depends on [1]
>=20
> 1. https://lkml.org/lkml/2012/11/21/70
> pwm: Device tree support for PWM polarity
>=20
> Changes since v3:
> 	- Rebased on top of omap_dt/for_3.8/dts_part2
> 	- Add pwm backlight for am335xevm_sk
> 	- Moved tipwmss.h to pwm-tipwmss.h
>=20
> Philip, Avinash (11):
>   PWMSS: Add PWM Subsystem driver for parent<->child relationship
>   ARM: am33xx: clk: Add optional clock for EHRPWM
>   ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
>     subsystem
>   pwm: pwm-tiecap: Add device-tree binding support for APWM driver
>   pwm: pwm-tiecap: pinctrl support
>   pwm: pwm-tiehrpwm: Add device-tree binding support for EHRPWM driver
>   pwm: pwm-tiehrpwm: pinctrl support
>   pwm: pwm-tiehrpwm: Adding TBCLK gating support.
>   ARM: dts: AM33XX: Add PWMSS device tree nodes
>   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
>   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk

Hi,

So how do you want to get this merged? Should I take patches 1, 4, 5, 6,
7 and 8 while the rest go through some ARM tree? Can we still merge this
for 3.8? The patches don't seem to have build dependencies on each other
but how about runtime dependencies?

Thierry

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpYgAAoJEN0jrNd/PrOhx04QALld4zdyK4uzCc10EXZBF8Qy
s+eYwWUVMnV8FMb0xi3rU9PrKq51CPydX+JhjFGDMRjAYlnIOdjwvOX60OSfsE/K
z0LVCghVsivnGP76PFjeYt9fHd+dmAFEWoTQo6R4BHLDhogt+OwwQvkdK5DZwbU+
X+XWPQ13pTkio4Y7IXHCGAdBLazNw/L0cfmwJMtbMfia4HI3HSgmu5YZxGDguUs4
VqqaS4i/Qt3eIw3Q8Yf2Xkrp/8HZkt8qza4zfwsOdU3El8BkiWAby9keHGJsdSXH
KS7W2jClSxAE4+R/zimz6Vk1MUyoHXMJ73vgc4C3N2caYcIrPYzn3LjcCo9fIifs
80hAM6FMdg4JkAYxE48OlTFEmm6Nx22GYQFxcxI9BxmKkecRH9twTUa/h+sdGAUU
fO2bWH2plaYTIdDQzKpB8OAIz12Bofr5ls2Ckm8WlC35hNn30vQDiDYrUuR1isS4
hrf/BIq99lePmNoXLA5gnBM+rWMBi0eshLIxSenVrrtZPWV5gPtdi5BmtG7GFwoa
byCokYRSiKcufa9H03tiscDnWTYWpVkBID8C8N054XOxMPPk2sZ6wQwWlZr8rNEN
VS+myT9lx7LfzsFdM32y/0NKfYQ3AV73EZ36zfXdctMg63rPc5X2znWGCHG4bGBa
3yzGmffBKYCgD9X8tiXZ
=oJFt
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
