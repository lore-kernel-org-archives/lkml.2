Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2CVHwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:52:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48188 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2CVHwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:52:03 -0400
Date: Thu, 22 Mar 2012 08:51:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20120322075159.GC31810@gmail.com>
References: <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
 <20111230095521.GA12077@elte.hu>
 <20120202112133.GR16322@erda.amd.com>
 <20120308121924.GA19674@elte.hu>
 <20120309114112.GR16322@erda.amd.com>
 <20120321181314.GK16322@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321181314.GK16322@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> On 09.03.12 12:41:12, Robert Richter wrote:
> > > I suspect being able to skid-less profile on AMD CPUs, using 
> > > IBS, would be a useful feature to users. What would be required 
> > > for that to work?
> > 
> > thanks for putting this into tip. This helps a lot.
> > 
> > I am just looking into skid-less sampling. The effort of attaching the
> > rip taken from the IBS sample for events 0x76/0xc1 should be feasable.
> 
> I have some patches ready for release after the merge window. 
> I noticed conflicts between my development tree on top of 
> tip/perf/x86-ibs and tip/perf/core. Could you merge 
> tip/perf/core into tip/perf/x86-ibs? I will rebase my current 
> patches then. This avoids diverging the trees to much and 
> reduces later conflicts.

Feel free to do the merge yourself - that way you can also test 
the merged tree.

Thanks,

	Ingo
