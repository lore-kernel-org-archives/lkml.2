Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0ELC5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:57:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0ELC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:57:42 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=5sH3s8HGSoAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=nGFOhSPuOmMgoYj8RysA:9 a=cEKyLH7kyTwiDVF9Lv-d_toJwmIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: Lowering the footprint of
 TRACE_EVENTs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <1273608891.27703.5.camel@gandalf.stny.rr.com>
References: <20100511182022.826921702@goodmis.org>
	 <1273608891.27703.5.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 11 May 2010 22:57:39 -0400
Message-ID: <1273633059.27703.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:14 -0400, Steven Rostedt wrote:
> On Tue, 2010-05-11 at 14:20 -0400, Steven Rostedt wrote:
> > [ Final version! ]
> > 
> > Ingo,
> 
> > 
> > Please pull the latest tip/tracing/core tree, which can be found at:
> 
> Ingo,
> 
> Hold on, this breaks a few places on a allyesconfig. I missed some
> places that use the register_trace_* and this changes the API.
> 
> I'll have another patch set later tonight.
> 

I think I found all the cases, but I'm going to do a little more
testing. I'll have the patch set out tomorrow (today for you ;)

-- Steve


