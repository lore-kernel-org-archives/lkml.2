Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2BBLVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:21:44 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:14649
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755583Ab2BBLVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:21:42 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz146fK1432N98dK4015Lzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYRJK0-01-1S5-02
X-M-MSG: 
Date: Thu, 2 Feb 2012 12:21:33 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20120202112133.GR16322@erda.amd.com>
References: <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
 <20111230095521.GA12077@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111230095521.GA12077@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 30.12.11 10:55:21, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > > Once something like 'perf report' works for some useful 
> > > looking sub-case you can also tack on all the extra IBS 
> > > goodies that specialized tools might need as well, i have no 
> > > problem with providing that.
> > 
> > Isn't that outlook I gave about pebs like implementation of 
> > the precise bit with IBS "useful enough"? This would be on top 
> > patches anyway, so no need to hold back current patches.
> 
> An 'outlook' is not something I can test before sending commits 
> to Linus.

The question was more if this is the direction you think may make
sense to go to. Of course, I would then implement and send patches for
this.

> To help your effort we could tentatively put the patches into a 
> separate tip:perf/ibs topic branch if everyone agrees otherwise, 
> which can go upstream once it's complete and usable.

This would be very helpful for me. So far I see following patches for
this on top of today's tip/perf/core (623ec99):

08e232d perf, x86: Implement IBS event configuration
05efba4 perf, x86: Implement IBS interrupt handler
b0532b2 perf, x86: Implement IBS pmu control ops
56ccf1a perf, x86: Implement 64 bit counter support for IBS
98e655c perf tool: Parse general/raw events from sysfs
aac22da perf tools: Add pmu mappings to header information
f1f062d perf script: Add script to collect and display IBS samples

Only 'perf tools: Add pmu mappings to header information' applies with
conflicts, so I could resend an updated version. This patch is also
independent from the other patches and can be applied separately.

If you wish I also can send all patches again, but they would be
unchanged anyway (except that one with the conflict).

Peter and Arnaldo,

please agree with a separate tip:perf/ibs development branch. It would
be easier to all of us because we don't have the effort of reviewing
patches again that will not change anymore.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

