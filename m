Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab2DRE4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:56:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2DRE4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:56:08 -0400
Date: Wed, 18 Apr 2012 06:55:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 1/8] ohci-nxp: Driver cleanup
Message-ID: <20120418045540.GA16990@avionic-0098.adnet.avionic-design.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <1334682507-15055-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1334682507-15055-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7WvKIvBXqU1royQLg+aHArYhlufPpEulFSg5StdRULE
 0jcKlZpRPDULgglDLOXD+gB2mo7fkGm2643uq7FkTM2lYBok5v
 kuue2ZOWxtYUg3WXN24BI8hPEKWNoG+/isaIuqUXdTu/l0zRVK
 ftdZO45TmtwFewzsYoQ0FgsVN0tYgT/HpYxKdEpZ9AQT09Qe5Q
 yYGGwZTmt6GaQYIu+Xn6KjbjzrsfkbYmiyoYbyzCauR0mdsZ4P
 8lH2esnq/hFiO3higgGZVkvmSr6s4ADQazOAnidvcekPiL/hCT
 DD4zH9CSmbAD2OrAp7EW3PbtcijEo1eNLz3wF4mKrMuLLpfhIE
 +jw0fXjY2eqRCleyl4yMHRM6JgcmYkr8bAFsXYtgl1aIxBjx/O
 d8+i75rcieVX9nSa7OYTrKszdTWRb2yAlE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Roland Stigge wrote:
> --- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
> +++ linux-2.6/drivers/usb/host/ohci-nxp.c
[...]
> @@ -220,7 +220,7 @@ static void isp1301_configure_lpc32xx(vo
>  		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
> =20
>  	/* Enable usb_need_clk clock after transceiver is initialized */
> -	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
> +	__raw_writel((__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN), USB_CTRL);

There's a pair of gratuitous parentheses here. Since you're changing the li=
ne
anyway you can just drop them as well.

Thierry

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+OSUwACgkQZ+BJyKLjJp8nxwCdFdMQLsyDK/85MkeqD3nt6b55
I0EAnRGcIuqimxaB5jTv8WTdjrxTu2Xc
=nKVk
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
