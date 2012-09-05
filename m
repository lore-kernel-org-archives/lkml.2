Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2IERPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:15:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2IERO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:14:59 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=18yvFWKpt00A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=irYwWJVkUgEA:10 a=TvQq1q_CqGoA:10 a=Rx3P8Oq71xYA:10 a=Dkbg8qHGoJsA:10 a=APHIi6T3EdUA:10 a=YhtTla6GYR8A:10 a=D19gQVrFAAAA:8 a=JYXWXqpfWk1sZVYSuIIA:9 a=PUjeQqilurYA:10 a=b3D6R9wpAFoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346865298.27919.58.camel@gandalf.local.home>
Subject: Re: lockdep WARNING for run_timer_softirq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 13:14:58 -0400
In-Reply-To: <1346864947.2600.33.camel@twins>
References: <20120831072149.GA7821@localhost>
	 <1346845644.2461.27.camel@laptop>
	 <1346854836.27919.51.camel@gandalf.local.home>
	 <1346864947.2600.33.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 19:09 +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 10:20 -0400, Steven Rostedt wrote:
> > Well, the branch tracer was active. That means all 'if()'s were being
> > traced. It comes down to how you define 'if' ;-) 
> 
> Yeah, I tried making an argument for:
> 
>   we tell lockdep irqs are enabled hit an if() end up in lockdep code
> through the branch tracer and find borken state, or vice-versa.
> 
> Just couldn't find it in the provided stack-trace. Might be I didn't
> look hard enough, might be there's something else entirely.
> 
> All I know is I've never seen it on real hardware, then again, I hardly
> ever have CONFIG_PARAVIRT or CONFIG_TRACE_BRANCH_PROFILING, let alone
> both.
> 

This looks very familiar to Fengguang's previous bug report. I can't
seem to find it on LKML.org. Probably because of the two attachments
(dmesg and config) caused lkml to nuke it.

I'll forward it to you.

-- Steve


