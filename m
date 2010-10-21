Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0JUMpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:45:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0JUMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:45:42 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VvixNBtZ7ssjy6iVYRwA:9 a=muDT2MM-ciBST79SeK5PSOeTTe8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <1287659008.3488.102.camel@twins>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <20101020164324.GC7348@redhat.com>  <4CBFAC70.30602@hitachi.com>
	 <1287645744.3488.57.camel@twins>
	 <1287658862.16971.569.camel@gandalf.stny.rr.com>
	 <1287659008.3488.102.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 08:45:39 -0400
Message-ID: <1287665139.16971.575.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 13:03 +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 07:01 -0400, Steven Rostedt wrote:

> Possibly, but wouldn't it make sense to batch up the work and simply
> call stop_machine only once? I mean, if you already know you're going to
> do this...

That has actually been talked about. By adding some sort of
trace_point_batch_enable(). But this is not the usual normal case.

-- Steve


