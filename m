Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2GZLhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:37:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab2GZLhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:37:37 -0400
Date: Thu, 26 Jul 2012 12:37:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 16/21] ASoC: Ux500: Enable MOP500 driver for Device Tree
Message-ID: <20120726113734.GZ3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-17-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwN3S3mscniL3FCL"
Content-Disposition: inline
In-Reply-To: <1343298534-13611-17-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dwN3S3mscniL3FCL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 11:28:49AM +0100, Lee Jones wrote:

>  arch/arm/mach-ux500/board-mop500-msp.c |    3 ---
>  sound/soc/ux500/mop500.c               |   41 ++++++++++++++++++++++++++++++++

There is no binding documentation here.  All bindings should be
documented.

> -	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
> -	platform_device_register(&snd_soc_mop500);
> -

This should be done separately - if it's going to be merged with
something it should be the patch that adds the relevant DT fragments.

--dwN3S3mscniL3FCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQESv4AAoJEBus8iNuMP3dQogP/ihizgNZtgkuVvzYcqi2miSd
m53YyoBYZDz8JIj8u5+guTFezRqyK5m0K1/EzRyEUOTjRrc4sy3KB8HS/VUjXWEO
UKFFca7RCgmJ7seIgPAx4TNygREXxScIT5GBwD9SV3GsvABo9C5nfURNYWW2iUSk
+/ilMrNMf0PCzQO3XnuPefKwgf1YPy7mSG9/dtrK9DrWCIS6BpXaZ8bHVcONmVJm
eI6NXTi8SumQljsfEPwRTlR1ODhctLZ08GPlOZeBBt30sjeP8E8l8QFDKyd8QCKu
ieiOqfR3tUU9rthkw/dXZWvjNo/IchS2rcABllMgPXsrLTRIpbqCvWkSyLpb0nx4
/uI0dkC086VmvWTPv6mMlA5yxMhDbce5y8ldxIXN7MGzZZWSq4zbunMRV1QKQqL2
plongRa33lu0Y0r3Zmz2+lxqwEgSI8mj8xUl0obKZBWHQ1qjMR0/PXEAOc1ukvqk
gEtIAXz1PU5czmSql7bn80yh982FtyFRAS9lhrlKLkFwZYrLqwb7edIEZvli0P1Q
lLUneXhyBuHaEbVcRiK+743tUqNLcrIlf/L62SBWJzgKkMtzvyZPtIAZyZfDZFQw
58lHXnaFYUDYL6LoRaCYx6Kl8iXwkSHtFlQg4sSnIW/pw/SMXQGS+G9nAFHcdMyU
2+cv1j3EPr0fb83VZd8/
=ruwj
-----END PGP SIGNATURE-----

--dwN3S3mscniL3FCL--
