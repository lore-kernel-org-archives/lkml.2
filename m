Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1KANiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:38:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14522 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1KANiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:38:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Nov 2011 06:37:50 -0700
Date: Tue, 1 Nov 2011 15:37:47 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, "Olof Johansson" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] arm/tegra: prepare early init for multiple tegra
 variants
Message-ID: <20111101133747.GF13358@tbergstrom-lnx.Nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B2@HQMAIL01.nvidia.com>
 <20111027201657.GP19187@n2100.arm.linux.org.uk>
 <20111028161933.GK23539@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111028161933.GK23539@mudshark.cambridge.arm.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 06:19:34PM +0200, Will Deacon wrote:
> On Thu, Oct 27, 2011 at 09:16:57PM +0100, Russell King - ARM Linux wrote:
> > On Thu, Oct 27, 2011 at 01:06:13PM -0700, Stephen Warren wrote:
> > > Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> > > > -static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> > > > +void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
> > > 
> > > I'm not sure why you moved that, but I suppose it's fine.
> > 
> > Note that Nicolas has a patch set during KS which cleans the arch_reset
> > business out of mach/system.h, and effectively gets rid of arch_reset
> > entirely, so this probably conflicts with those changes.
> 
> I've spammed the ARM list with this patch series now, so the state of the
> conflicts should be evident.
> 

Will be taken into account in the next version.

Chers,

Peter.
