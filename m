Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab0JSOIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:08:25 -0400
Received: from www.tglx.de ([62.245.132.106]:34219 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab0JSOIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:08:24 -0400
Date: Tue, 19 Oct 2010 16:07:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <1287496495.16971.372.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com>  <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>  <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>  <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> 
 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>  <20101019132236.GA19197@Krystal>  <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Steven Rostedt wrote:

> On Tue, 2010-10-19 at 15:41 +0200, Thomas Gleixner wrote:
> > On Tue, 19 Oct 2010, Mathieu Desnoyers wrote:
> 
> > Dudes, a vector computation is hardly a performance problem in that
> > function and definitely not an excuse for designing such horrible
> > interfaces.
> 
> Yes, now we can be a bit more liberal. But when these tracepoints were
> going in, people were watching to make sure they have practically zero
> impact when tracing was disabled.
> 
> Now that people are more use to tracepoints, they are more understanding
> to have cleaner code over that extra few more lines of machine code in
> the fast path.

The vector computation is compared to the extra tracing induced jumps
probably not even measurable. Stop defending horrible coding with
handwavy performance and impact arguments.

Thanks,

	tglx
