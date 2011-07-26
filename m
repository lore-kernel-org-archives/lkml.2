Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1GZVxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:53:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56588 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab1GZVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:53:01 -0400
Date: Tue, 26 Jul 2011 17:52:59 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends
 on MSM
In-Reply-To: <20110726213910.GA11358@huya.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1107261752240.12766@xanadu.home>
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org> <1311614362-9011-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1107251624560.12766@xanadu.home> <20110725203114.GF14955@n2100.arm.linux.org.uk> <4E2EFC0E.8020805@codeaurora.org>
 <alpine.LFD.2.00.1107261418250.12766@xanadu.home> <20110726213910.GA11358@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, David Brown wrote:

> On Tue, Jul 26, 2011 at 02:24:26PM -0400, Nicolas Pitre wrote:
> > On Tue, 26 Jul 2011, Stephen Boyd wrote:
> > 
> > > On 07/25/2011 01:31 PM, Russell King - ARM Linux wrote:
> > > > On Mon, Jul 25, 2011 at 04:25:26PM -0400, Nicolas Pitre wrote:
> > > >> On Mon, 25 Jul 2011, Stephen Boyd wrote:
> > > >>
> > > >>> MSM no longer requires the 16bit version of dynamic P2V. Drop the
> > > >>> dependency.
> > > >>>
> > > >>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > >>> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > >>> Cc: David Brown <davidb@codeaurora.org>
> > > >> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > > As it's now unused, we can kill the additional code which makes things
> > > > needlessly more complex...
> > > 
> > > Ok. I'll remove the extra code in v3.
> > 
> > Something like this (untested):
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> 
> I've tested this on MSM8660.  Works with CONFIG_ARM_PATCH_PHYS_VIRT
> enabled (but an offset of zero).
> 
> I'd like to make this up into a patch, Nicolas, do you want to be the
> author (and do you sign-off)?

Sure.


Nicolas
