Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2DSLiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:38:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab2DSLiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:38:23 -0400
Date: Thu, 19 Apr 2012 12:38:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 1/6] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120419113818.GA3046@opensource.wolfsonmicro.com>
References: <20120418214703.GA31606@kroah.com>
 <1334803298-24260-1-git-send-email-myungjoo.ham@samsung.com>
 <1334803298-24260-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1334803298-24260-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 11:41:33AM +0900, MyungJoo Ham wrote:
> External connector class (extcon) is based on and an extension of
> Android kernel's switch class located at linux/drivers/switch/.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +comment "Extcon Class Configuration"
> +
> +config EXTCON_ANDROID_COMPATIBLE
> +	bool "Class name uses 'switch' to be compatible with Android kernel"
> +	depends on ANDROID
> +	help
> +	  The class name of extcon device drivers are set 'switch' in order
> +	  to be compatible with Android kernel switch framework. With this
> +	  option enabled, Android userspace platform may use extcon device
> +	  drivers as if they are switch device drivers.

Though I think this is out of date now?  Not a big deal and could be
fixed up later.

> +#if defined(CONFIG_ANDROID) && !defined(CONFIG_ANDROID_SWITCH)
> +		switch_class = class_compat_register("switch");
> +		if (WARN(!switch_class, "cannot allocate"))
> +			return -ENOMEM;
> +#endif /* CONFIG_ANDROID && !defined(CONFIG_ANDROID_SWITCH) */

This does the above but differently.

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPj/kjAAoJEBus8iNuMP3dkVsP/ityE2CVp6nOxyu3/vc65rP5
1V8e0uCujqPPDJLPDl3K4hb9SRzJDXzD3AETq58CPdaEmZ22MktC+tJ0Lx9AMAKQ
AoYJekaY2GDHrYQuR64WzIPmFENsUWiy6/9fXnqVK0Z/ogKqJju9E+yrGwta2PIt
DnvSWxwKHsBmCw073bEHC3ZOtk3YcntzFDHFc22LshitojFB9ZD/e7oBNyEbshKi
eGix0aY9TEsH+JIcURWPr63/V5FCwKTBA70y7oDYqdAXODvjHwvwe2Jqf3VPzQkx
ZiLIAXuUgRxTnQdQAoT9wAZAVYxGZjWgpEFYMZTRgWWj10wbOnjkQBllmQAnwcYT
/mosr6wVaNsCodxdpmKdabfmShWf3pB1Zh14j0KjjXGp6FueMFHZqmBglkbG8eYB
0IR6MCoOGuvFd/xCpWzHZufCsh3NuxVlGa/TiO+3FzXfQm9fO+rR3PM73Qc8il9o
kngx7FDutmrgJj8jld0iDufal3OKW1Da8xvaIwNBGcKPTz0Qz1D1Bi2ml6Bimfk5
jCtAyMfhggpmrhM4g2SD7WArG2KJGNVmTH0DAeIdYrXEnY54PyMcBlF10G2Dwdck
toEDLnPOPYB7oN/3ICI/SdESIrpeF7q1Aug2kmxDziNDflsCYajkW9NtmatsvfxB
cbIfZrDl1+rpkKsIYuOL
=VfRo
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
