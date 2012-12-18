Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab2LRGCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:02:12 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:42225 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2LRGCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:02:11 -0500
Date: Tue, 18 Dec 2012 07:00:09 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Olof Johansson <olof@lixom.net>
Cc: Dongjin Kim <tobetter@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 1/4] ODROID-X: dts: Add board dts file for ODROID-X
Message-ID: <20121218060009.GK23971@game.jcrosoft.org>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com>
 <1355774107-364-2-git-send-email-tobetter@gmail.com>
 <CAOesGMgZWNiCmTFGvr--zKf+vS51hX5jPnD+NZq8OvGFLS9rJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgZWNiCmTFGvr--zKf+vS51hX5jPnD+NZq8OvGFLS9rJA@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 493988585905040175
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehkedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehkedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:56 Mon 17 Dec     , Olof Johansson wrote:
> On Mon, Dec 17, 2012 at 11:55 AM, Dongjin Kim <tobetter@gmail.com> wrote:
> > Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412 SoC.
> >
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> > ---
> >  arch/arm/boot/dts/Makefile               |    1 +
> >  arch/arm/boot/dts/exynos4412-odroidx.dts |   52 ++++++++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
> >
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index ca6fb8e..3355af9 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -45,6 +45,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
> >         exynos5250-smdk5250.dtb \
> >         exynos5440-ssdk5440.dtb \
> >         exynos4412-smdk4412.dtb \
> > +       exynos4412-odroidx.dtb \
> 
> Please add them alphabetically, so before smdk.
we need to drop the \ \ stuff it will end with merge conflict
as if you add 2 dtb at the end you will end with 2 patch that touch the same
previous line
> 
> > diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
> > new file mode 100644
> > index 0000000..786ddd7
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> > @@ -0,0 +1,52 @@
> > +/*
> > + * Hardkernel's Exynos4412 based ODROID-X board device tree source
> > + *
> > + * Copyright (c) 2012-2013 Dongjin Kim <tobetter@gmail.com>
> 
> Are you from the future?
> 
> > + *
> > + * Device tree source file for Hardkernel's ODROID-X board which is based on
> > + * Samsung's Exynos4412 SoC.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > +*/
> > +
> > +/dts-v1/;
> > +/include/ "exynos4412.dtsi"
> > +
> > +/ {
> > +       model = "Hardkernel ODROID-X board based on Exynos4412";
> > +       compatible = "samsung,exynos4412";
> 
> It should have a more specific compatible value first, i.e.
> "hardkernel,odroid-x" or similar.
> 
> 
> > +       memory {
> > +               reg = <0x40000000 0x40000000>;
> > +       };
> > +
> > +       chosen {
> > +               bootargs ="root=/dev/mmcblk0p3 rw console=ttySAC1,115200 init=/sbin/init delay=2";
> 
> Bootargs should be passed in from u-boot, don't specify them in the
> static device tree.

why not we can choose to have a default cmdline and even usit as a complement
of the bootloader one

it's up to the dts maintainer to choose

Best Regards,
J.
