Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2KVVMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:12:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2KVVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:12:05 -0500
Date: Thu, 22 Nov 2012 22:11:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 10/11] ARM: dts: AM33XX: Add PWM backlight DT data to
 am335x-evm
Message-ID: <20121122211147.GI16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-11-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-11-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NVzJoxOGPlhCu7fGuz80V3AcWF4aFE8otz6+l1RJXnS
 OHGH2yKjzipCu+NnxD6EcDmI4yzCUyvCEyEKSw9V0fkKN45E1p
 ZWcddr/auTXQO/2AHX6+UraT8AvTZWb12dmIKLtFpICKEUlPWm
 Q61TItuOq1lBClO50/A6lkx596mAVy5PtAQx5MkriH5PboYW4s
 edzrAnwiO7M8duCj5RNwLUXC6hhSNplSo07p1X6V6eU5CVokoJ
 xu7qMz2xRie8e+3E7t+kmu6Aw56eBl4HWsLEsTIMK5dMMoZzjj
 W1qmamXZqHxRYCCOzV+cEz9ahu9m/1udEEd26pk1fwoeoQWkYd
 T8vRwaEpPNPhJa3Lyy1rQGMX4HYSr26wX6FDjcxANnpf89w1dW
 rUC4t+dxiuUINYPCUoMftWC8IvfcslYgbOwwG84I6gfeTCcnAo
 CUC5Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:41:07PM +0530, Philip, Avinash wrote:
[...]
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 9f65f17..4178ba4 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -44,6 +44,12 @@
>  				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7 */
>  			>;
>  		};
> +
> +		ecap0_pins: backlight_pins {
> +			pinctrl-single,pins = <
> +				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
> +			>;

This looks kind of funky, but I see the rest of the file uses similar
formatting, so I guess it's okay.

> @@ -158,6 +174,13 @@
>  			gpio-key,wakeup;
>  		};
>  	};
> +
> +	backlight {
> +		compatible	= "pwm-backlight";

Maybe you don't want a tab between "compatible" and "=", but a space
instead.

Other than that, looks good:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpUTAAoJEN0jrNd/PrOhIGMQAIBi9n7xA6obUrKlYLDKFdBe
t983odhwp0g+V7xp0qTRgTITCLdwYtjhHxb4hnQBUw222ZZzTh9xv+XCdd1JpLGp
vO9UVY2M2l6YLfIcDfRhjvjnmyvpsxAQ5ADMsVs1KTmJtBO221u7CZVJQVzfdHKh
CJ1DlEv/qkoSUkiUKjBw/+Eu4grwLOuBbbzBBxzoSf154jZM7HhOX2XVWzR8wkGG
pNq7daPfPuq5XIpkcR1/gl3sINb9A3wbIMTNm7Tg7DoZB4ihCjEAOUpHCiGK42ns
3XLZkXfsaL5D0KRhFsqJUHQcRG/7+HWJy3ByVHJK7X2lH6W1DSroFXjWuKllRzr7
Pm22CVK1CdSPOo88IuomRxI/5TOMetX1BONpMWzNMF5FkyvFTD/l8gsxut5EmO7Q
+QB5HOhR2s8SqioRHTuuIeBujhDkYEsuOzd5Cyi5FPsdF824aNfv4jgRAFMLZg4k
2l2V3+aXF/U6/ITwjUbNNqT/8VvD7qFPjl4ha5Sw02FMSCh/Bj4gzIWvU9IcAFY6
7/2LmOAazxS3mdjHNy31whbaPG8jp47Kr2sVrPovAWAN4lPG4TyL8Gy561zDTeR0
6bp0hSf7gZd6Wzn9i1yn7EIjOS5gK1K1mFjX0+72MfYcWtf10i+sqnlFaE78lAYQ
TMmWWcc3hw5UtFVL4JlR
=XTbD
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
