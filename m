Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab2CUSN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:13:26 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19023 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab2CUSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:13:24 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432N98dK4015I148cMzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M18YM2-02-BFZ-02
X-M-MSG: 
Date: Wed, 21 Mar 2012 19:13:14 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20120321181314.GK16322@erda.amd.com>
References: <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
 <20111230095521.GA12077@elte.hu>
 <20120202112133.GR16322@erda.amd.com>
 <20120308121924.GA19674@elte.hu>
 <20120309114112.GR16322@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120309114112.GR16322@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 09.03.12 12:41:12, Robert Richter wrote:
> > I suspect being able to skid-less profile on AMD CPUs, using 
> > IBS, would be a useful feature to users. What would be required 
> > for that to work?
> 
> thanks for putting this into tip. This helps a lot.
> 
> I am just looking into skid-less sampling. The effort of attaching the
> rip taken from the IBS sample for events 0x76/0xc1 should be feasable.

I have some patches ready for release after the merge window. I
noticed conflicts between my development tree on top of
tip/perf/x86-ibs and tip/perf/core. Could you merge tip/perf/core into
tip/perf/x86-ibs? I will rebase my current patches then. This avoids
diverging the trees to much and reduces later conflicts.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

