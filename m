Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1I1RMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:12:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17508 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1I1RMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:12:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Sep 2011 10:11:53 -0700
Date: Wed, 28 Sep 2011 20:11:51 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] arm/tegra: device tree support for ventana board
Message-ID: <20110928171151.GN21166@tbergstrom-lnx.Nvidia.com>
References: <1317171902-14736-1-git-send-email-pdeschrijver@nvidia.com>
 <1317171902-14736-4-git-send-email-pdeschrijver@nvidia.com>
 <201109281516.42513.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201109281516.42513.arnd@arndb.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 03:16:42PM +0200, Arnd Bergmann wrote:
> On Wednesday 28 September 2011, Peter De Schrijver wrote:
> > --- a/arch/arm/mach-tegra/board-dt.c
> > +++ b/arch/arm/mach-tegra/board-dt.c
> > @@ -47,7 +47,7 @@
> >  
> >  void harmony_pinmux_init(void);
> >  void seaboard_pinmux_init(void);
> > -
> > +void ventana_pinmux_init(void);
> >  
> >  struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
> >         OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
> > @@ -95,6 +95,8 @@ static void __init tegra_dt_init(void)
> >                 harmony_pinmux_init();
> >         else if (of_machine_is_compatible("nvidia,seaboard"))
> >                 seaboard_pinmux_init();
> > +       else if (of_machine_is_compatible("nvidia,ventana"))
> > +               ventana_pinmux_init();
> 
> Are you (Peter, Colin, Olof) confident that this is not getting out
> of hand before it's getting better?
> 

We don't planning to add more derived boards besides ventana until we have the
devicetree bindings for the new pinmux API in at which point this code
will become obsolete.

Cheers,

Peter.
