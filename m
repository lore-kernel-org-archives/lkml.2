Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1KGMsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:48:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9697 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KGMr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:47:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Nov 2011 04:47:49 -0800
Date: Mon, 7 Nov 2011 14:47:46 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] arm/tegra: implement support for tegra30
Message-ID: <20111107124746.GP29978@tbergstrom-lnx.Nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-8-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E4F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E4F@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 09:43:57PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Wednesday, November 02, 2011 8:09 AM:
> > Add support for tegra30 SoC. This includes a device tree compatible type for
> > this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
> > The clock framework is still missing, which prevents most drivers from working.
> ...
> > diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> ...
> > @@ -17,7 +14,18 @@ config ARCH_TEGRA_2x_SOC
> >  	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
> >  	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
> > 
> > -endchoice
> > +config ARCH_TEGRA_3x_SOC
> 
> Wasn't that config option already used earlier in the series, e.g. in
> [PATCH v2 6/8] arm/tegra: pinmux tables and definitions for tegra30.

It is. Is that a problem?

Cheers,

Peter.
