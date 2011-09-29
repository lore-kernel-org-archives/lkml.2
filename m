Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1I2P2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:28:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14824 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab1I2P2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:28:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 29 Sep 2011 08:27:55 -0700
Date: Thu, 29 Sep 2011 18:27:52 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] arm/tegra: add support for ventana pinmuxing
Message-ID: <20110929152752.GO21166@tbergstrom-lnx.Nvidia.com>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
 <1317248978-10829-3-git-send-email-pdeschrijver@nvidia.com>
 <20110929092951.GE23944@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110929092951.GE23944@n2100.arm.linux.org.uk>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 11:29:51AM +0200, Russell King - ARM Linux wrote:
> On Thu, Sep 29, 2011 at 01:29:35AM +0300, Peter De Schrijver wrote:
> > diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> > index f11b910..91a07e1 100644
> > --- a/arch/arm/mach-tegra/Makefile
> > +++ b/arch/arm/mach-tegra/Makefile
> > @@ -31,6 +31,7 @@ obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
> >  
> >  obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
> >  obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
> > +obj-${CONFIG_MACH_TEGRA_DT}             += board-seaboard-pinmux.o
> 
> Since when did Tegra start using braces instead of parens in its Makefile?
> I note some of Tegra's makefile is using braces and some of it parens.
> What's the reason for this alternative style to the rest of kbuild?

I have no idea. I just followed the style used for the other CONFIG_MACH_TEGRA_DT entries. Colin or Olof, any idea?

Thanks,

Peter.
