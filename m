Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1J0UZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:25:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54342 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1J0UZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:25:15 -0400
Date: Thu, 27 Oct 2011 21:24:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4/6] arm/tegra: implement support for tegra30
Message-ID: <20111027202449.GQ19187@n2100.arm.linux.org.uk>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com> <1319561644-6160-5-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B6@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B6@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:10:10PM -0700, Stephen Warren wrote:
> Peter De Schrijver wrote at  Tuesday, October 25, 2011 10:54 AM:
> > From: Peter De Schrijver <pdeschrijver@nvidia.com>
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Some description here would be nice.

Definitely - it's something which Andrew Morton commented on during
the kernel summit.  Commit messages really should sell the patch
they're attached to, so that people reading the kernel commit log
(a) have some idea what the patch is doing and (b) why it's being
added.

So maybe something like:

Add support for the Tegra T30 SoC, found in x, y and z.  This
includes a device tree compatible type for this SoC ("nvidia,tegra30")
and adapts the kernels L2 cache initialization for this new SoC.

(That's my best guess based on the contents of this patch.)
