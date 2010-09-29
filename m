Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0I2PCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:02:01 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:29379
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751546Ab0I2PB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:01:59 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2cK1432N98dN9371Pzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IKER-02-W1Y-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 17:01:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929150140.GK13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 09:28:56, Stephane Eranian wrote:
> On Wed, Sep 29, 2010 at 3:13 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Wed, Sep 29, 2010 at 2:54 PM, Robert Richter <robert.richter@amd.com> wrote:
> >> On 29.09.10 14:53:01, Robert Richter wrote:
> >>> Stephane,
> >>>
> >>> On 29.09.10 08:26:41, Stephane Eranian wrote:
> >>> > You've applied the fix only to the generic X86 interrupt handler
> >>> > which is currently used by AMD64 processors.
> >>>
> >>> (... and P4).
> >>>

> Well, in tip-x86, I don't see your fix in p4_pmu_handle_irq(). Is
> that pending?

Right, I wasn't remembering correctly, it was P6 and core. And yes, P4
requires the fix. Will send a patch for this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

