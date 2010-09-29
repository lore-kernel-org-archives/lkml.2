Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0I2QXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:23:00 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40737 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0I2QW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:22:59 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bh8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IO5Z-02-4YN-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 18:22:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Stephane Eranian <eranian@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929162249.GM13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100929152745.GC9440@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 11:27:45, Cyrill Gorcunov wrote:
> On Wed, Sep 29, 2010 at 05:12:53PM +0200, Robert Richter wrote:
> > On 29.09.10 17:01:40, Robert Richter wrote:
> > > Right, I wasn't remembering correctly, it was P6 and core. And yes, P4
> > > requires the fix. Will send a patch for this.
> > 
> > Ok, Cyrill is sending the patch.
> > 
> > Thanks,
> > 
> > -Robert
> >
> 
> Managed to implement it earlier then I thought.
> 
>   Cyrill
> ---
> Subject: [PATCH -tip] perf, x86: Handle in flight IRQs on P4 platform
> 
> Stephane reported we've missed to guard P4 platform
> against spurious in-flight performance IRQs. Fix it.
> 
> [ the patch is a complement to commit 63e6be6d98e1 ]
> 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Robert Richter <robert.richter@amd.com>
> CC: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

The fix looks correct to me.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

