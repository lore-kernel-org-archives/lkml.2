Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1KHLwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:52:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14878 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1KHLwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:52:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 08 Nov 2011 03:51:56 -0800
Date: Tue, 8 Nov 2011 13:51:53 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/8] Add support for tegra30 and cardhu
Message-ID: <20111108115153.GU29978@tbergstrom-lnx.Nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A50F3@HQMAIL01.nvidia.com>
 <20111108114559.GT29978@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111108114559.GT29978@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 12:45:59PM +0100, Peter De Schrijver wrote:
> On Mon, Nov 07, 2011 at 08:10:29PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Monday, November 07, 2011 7:20 AM:
> > > This patchset adds support for the tegra30 SoC and the cardhu development
> > > board.
> > > 
> > > Pathset is on top of Will Deacon's ARM reset work.
> > 
> > A few minor issues:
> > 
> > 1) If I enable just ARCH_TEGRA_3x_SOC, but not ARCH_TEGRA_2x_SOC, the
> > kernel fails to build because arch/arm/mach-tegra/include/mach/irqs.h
> > only defines NR_IRQS if ARCH_TEGRA_2x_SOC is defined.
> > 
> > 2) All the Tegra20 boards don't depend on ARCH_TEGRA_2x_SOC, so they can
> > be enabled even if only Tegra30 support is enabled.
> > 
> 
> Indeed. I also noticed that MACH_VENTANA lacks select MACH_SEABOARD...

I take that back. It's not needed.

> Maybe I should submit a seperate patch to fix all this?
> 

I will make a patch to cleanup the ARCH_TEGRA_2x_SOC dependencies. Or do you
want this as part of the tegra30/cardhu series?

Cheers,

Peter.
