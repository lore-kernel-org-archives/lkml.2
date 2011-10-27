Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1J0URQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:17:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49116 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1J0URP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:17:15 -0400
Date: Thu, 27 Oct 2011 21:16:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/6] arm/tegra: prepare early init for multiple tegra
	variants
Message-ID: <20111027201657.GP19187@n2100.arm.linux.org.uk>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com> <1319561644-6160-4-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B2@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B2@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:06:13PM -0700, Stephen Warren wrote:
> Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> > -static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> > +void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
> 
> I'm not sure why you moved that, but I suppose it's fine.

Note that Nicolas has a patch set during KS which cleans the arch_reset
business out of mach/system.h, and effectively gets rid of arch_reset
entirely, so this probably conflicts with those changes.
