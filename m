Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1LIPwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:52:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11196 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1LIPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:52:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Dec 2011 07:52:06 -0800
Date: Fri, 9 Dec 2011 17:52:03 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] arm/tegra: add support for tegra30 based
 board cardhu
Message-ID: <20111209155203.GM27578@tbergstrom-lnx.Nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
 <1323348254-29072-11-git-send-email-pdeschrijver@nvidia.com>
 <4EE21B67.5040006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EE21B67.5040006@gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  choice
> >          prompt "Low-level debug console UART"
> >          default TEGRA_DEBUG_UART_NONE
> > diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
> > index cf51a00..7c1110f 100644
> > --- a/arch/arm/mach-tegra/Makefile.boot
> > +++ b/arch/arm/mach-tegra/Makefile.boot
> > @@ -7,3 +7,4 @@ dtb-$(CONFIG_MACH_PAZ00) += tegra-paz00.dtb
> >  dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
> >  dtb-$(CONFIG_MACH_TRIMSLICE) += tegra-trimslice.dtb
> >  dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
> > +dtb-$(CONFIG_MACH_CARDHU) += tegra-cardhu.dtb
> 
> Likewise, this should be more like:
> dtb-$(CONFIG_MACH_TEGRA_DT) += tegra-seaboard.dtb tegra-trimslice.dtb
> tegra-ventana.dtb ...
> 

I think is subject of a different patch.

Cheers,

Peter.
