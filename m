Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0I2RAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:00:11 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:15565
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752340Ab0I2RAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:00:09 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK1432N98dN4015L179dN2f55kzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IPVX-01-EZ5-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 18:59:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] oprofile, arm: proper release resources on failure
Message-ID: <20100929165958.GQ13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
 <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
 <20100929165027.GP13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100929165027.GP13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 18:50:27, Robert Richter wrote:

> > Hmm, these three hunks conflict with the patches I posted last
> > month to fix the resource allocation and freeing. Can't we
> > merge those patches instead? I have versions against -rc6 here:
> 
> Yes, these patches are also in my oprofile/core branch and its changes
> conflict, but are scheduled for the next merge window. This fix is for
> urgent and for 2.6.36. We will then merge back rc7 or 2.6.36 to
> oprofile/core and solve the conflicts. But if you don't have something
> else for -rc7/.36 that conflicts, this should be ok.

So, it would be ok then to test only this fix on -rc6 without your
other patches.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

