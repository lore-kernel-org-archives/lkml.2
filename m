Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0I2Rj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:39:57 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53961 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0I2Rj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:39:56 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2cK936eK1432N98dN179dN168aJ2f55kzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IRQA-02-AP3-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 19:39:47 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] oprofile, arm: proper release resources on failure
Message-ID: <20100929173947.GS13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
 <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
 <20100929165027.GP13563@erda.amd.com>
 <20100929165958.GQ13563@erda.amd.com>
 <1285781578.22669.4.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285781578.22669.4.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 13:32:58, Will Deacon wrote:
> Robert,
> 
> On Wed, 2010-09-29 at 17:59 +0100, Robert Richter wrote:
> > On 29.09.10 18:50:27, Robert Richter wrote:
> > 
> > > > Hmm, these three hunks conflict with the patches I posted last
> > > > month to fix the resource allocation and freeing. Can't we
> > > > merge those patches instead? I have versions against -rc6 here:
> > >
> > > Yes, these patches are also in my oprofile/core branch and its changes
> > > conflict, but are scheduled for the next merge window. This fix is for
> > > urgent and for 2.6.36. We will then merge back rc7 or 2.6.36 to
> > > oprofile/core and solve the conflicts. But if you don't have something
> > > else for -rc7/.36 that conflicts, this should be ok.
> > 
> > So, it would be ok then to test only this fix on -rc6 without your
> > other patches.
> > 
> 
> Gotcha - this is a minimal fixup for -stable which we'll tackle properly
> in the merge window with the stuff in oprofile/core. In that case I'm
> happy for this to go upstream now:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> 
> I also built an -rc6 kernel with this change on top and OProfile worked
> happily across module loads/unloads.
> 
> As for oprofile/core; will you handle the conflicts there or do I need
> to resend my previous patches?

Yes, I will merge it after it went upstream and let you know.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

