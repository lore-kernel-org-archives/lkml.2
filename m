Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0IJHnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:43:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:44627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0IJHnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:43:50 -0400
Subject: Re: [RFC][PATCH 00/19] perf pmu interface changes -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org
In-Reply-To: <20100910043952.GA9100@drongo>
References: <20100907164633.879932949@chello.nl>
	 <20100910043952.GA9100@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 09:43:04 +0200
Message-ID: <1284104584.402.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 14:39 +1000, Paul Mackerras wrote:
> > that it currently doesn't allow to mix software and hardware events into a
> > single group (should be fixed soon).
> 
> I see Ingo committed this series into the tip perf/core branch.  Did
> this problem get fixed before that, or does it still need to be fixed? 

I thought I fixed it, but I realized I only fixed half of it.

The current state is that it allows to add software events to hardware
groups, but does not allow adding a hardware event to a pure software
group.

I'll try and get a patch done that attempts fixing that.


