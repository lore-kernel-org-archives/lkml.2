Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab1KJQ7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:59:35 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:45009
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932832Ab1KJQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:59:33 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz9371K1432N98dK4015Lzz1202hzz8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUGF73-02-MA4-02
X-M-MSG: 
Date: Thu, 10 Nov 2011 17:59:21 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        <mingo@elte.hu>, <ming.m.lin@intel.com>, <ak@linux.intel.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111110165921.GC15738@erda.amd.com>
References: <20111107110149.GA5177@quad>
 <1320935860.13800.25.camel@twins>
 <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.11 16:09:32, Stephane Eranian wrote:
> On Thu, Nov 10, 2011 at 3:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Just throwing this out there (hasn't event been compiled etc..).
> >
> > The idea is to try the fixed counters first so that we don't
> > 'accidentally' fill a GP counter with something that could have lived on
> > the fixed purpose one and then end up under utilizing the PMU that way.
> >
> > It ought to solve the most common PMU programming fail on Intel
> > thingies.

Peter, what exactly are that Intel constraints you try to solve? Could
you give a short example.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

