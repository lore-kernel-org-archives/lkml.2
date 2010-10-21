Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0JUNfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:35:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0JUNfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:35:21 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=8eYBim7neI8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=CG3p_s7I1h95krVFPr4A:9 a=KoCpZLJOrdlCxv6cGYUA:7 a=sFe7dviuRWdQs8BoeKv1OtzI9tcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 0/8] [GIT PULL] ring-buffer: various updates
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101021013906.507064528@goodmis.org>
References: <20101021013906.507064528@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 09:35:18 -0400
Message-ID: <1287668118.16971.576.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Would you be able to pull this for 2.6.37?

Thanks,

-- Steve


On Wed, 2010-10-20 at 21:39 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Thomas suggested that I try to fine grain the big patch in this series.
> It contained some minor clean ups, so I pulled them out of that patch.
> But that patch is still a bit big. Just because it changes the fact
> that the ring buffer functions can now accept a time extend as well
> as a data event. Those changes were rather trivial though.
> 
> Please pull the latest tip/perf/ringbuffer-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/ringbuffer-2
> 
> 
> Steven Rostedt (8):
>       ring-buffer: Make write slow path out of line
>       ring-buffer: Pass timestamp by value and not by reference
>       ring-buffer: Pass delta by value and not by reference
>       ring-buffer: Remove ring_buffer_event_time_delta()
>       ring-buffer: Bind time extend and data events together
>       ring-buffer: Remove condition to add timestamp in fast path
>       ring-buffer: Micro-optimize with some strategic inlining
>       ring-buffer: Remove unused macro RB_TIMESTAMPS_PER_PAGE
> 
> ----
>  include/linux/ring_buffer.h |   12 --
>  kernel/trace/ring_buffer.c  |  335 ++++++++++++++++++++++---------------------
>  2 files changed, 172 insertions(+), 175 deletions(-)


