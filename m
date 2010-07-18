Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0GRThl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 15:37:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41063 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab0GRThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 15:37:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>,
        paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
In-Reply-To: <20100708111936.GA5926@elte.hu>
References: <20100624142804.431553874@chello.nl> <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com> <1277464589.32034.276.camel@twins> <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com> <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop> <1277996555.1917.205.camel@laptop> <20100701153112.GA13511@console-pimps.org> <1277998793.1917.212.camel@laptop> <1278587622.1900.79.camel@laptop> <20100708111936.GA5926@elte.hu>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sun, 18 Jul 2010 20:37:39 +0100
Message-ID: <87k4oszim4.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 13:19:36 +0200, Ingo Molnar <mingo@elte.hu> wrote:
> 
> And if the platform code implements this then the tooling side already takes 
> care of it - even if the CPU itself cannot geneate interrupts based on say 
> cachemisses or branches (but can measure them via counts).

I finally got a bit of time to work on this. I'm confused about how the
tools will take care of this at the moment. How much support currently
exists for these sorts of weighted samples? The only thing I can find
that looks related is PERF_SAMPLE_READ, but I don't think that's exactly
what we need.

Could someone point me in the right direction?
