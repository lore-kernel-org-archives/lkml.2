Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1LVUtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:49:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:37841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1LVUtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90606160"
Date: Thu, 22 Dec 2011 12:49:15 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, gregkh@suse.de
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
Message-ID: <20111222204915.GA14770@alboin.amr.corp.intel.com>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <4EF27517.6010609@zytor.com>
 <20111222001441.GB10955@alboin.amr.corp.intel.com>
 <201112221629.16656.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112221629.16656.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 04:29:16PM +0100, Thomas Renninger wrote:
> On Thursday, December 22, 2011 01:14:41 AM Andi Kleen wrote:
> > > So this should be:
> > > 
> > > 1. added to the scattered CPUID features list;
> > > 2. artificially set in the AMD-specific initialization code for the
> > > older CPUs.
> > 
> > Not sure (2) is correct. As far as I understand it's actually different
> > mechanisms, just implemented by the same driver.
> > 
> > Keeping the list for old CPUs is not a big issue anyways.
> > 
> > Agreed with (1)
> > 
> > Anyways someone with the hardware should do it. Thomas?
> I have something.
> 
> Andi: If you don't mind, I'll pick up your patches,
> use drivers/base/cpu.c instead of cpuid driver. Then there
> will never show up a cpuid version mainline.
> I'll call it v4 and this patchset then depends on Kay's work.

I would prefer to keep them separated, Kay's patchkit is gigantic.

They can be always merged later, but a dependency is not really
needed. It doesn't matter much whether it's in cpuid or in cpu.

> 
> I'll also adjust:
>   - the microcode typo (in patch fix)
>   - add a cpuid hw_pstate (new patch)
>   - adjust powernow-k8 to make use of it via x86cpu autoloading
>     (in patch adjustings)
> 
> Tell me (best in the next hour) if something else should
> still be added.

I have nothing else.

-Andi
