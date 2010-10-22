Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0JVOg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:36:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33043 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab0JVOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:36:58 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Gud7DDN9fBCyTX4z4WMA:9 a=-BDPpHcDK4WClnj-4cYb5UYFI5YA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, tj@kernel.org
In-Reply-To: <1287757382.15336.45.camel@twins>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <1287659656.16971.573.camel@gandalf.stny.rr.com>
	 <20101021112614.GB26984@elte.hu> <20101022014441.GA1948@redhat.com>
	 <1287735271.15336.18.camel@twins>  <20101022141349.GA6498@redhat.com>
	 <1287757382.15336.45.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Oct 2010 10:36:55 -0400
Message-ID: <1287758215.16971.638.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:23 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-22 at 10:13 -0400, Jason Baron wrote:

> Can this be reproduced in qemu? I don't have a i386-smp machine around
> to use.
> 
> Could you trace the thing with all sched (except the sched_stat)
> tracepoints enabled? I think there's a sysrq key to dump the trace once
> the machine's stuck.. 
> 
> Hopefully that disables ftrace before it starts dumping otherwise the
> dump is useless -- Steven?

The ftrace_dump_on_oops does disable ftrace before it runs.

-- Steve


