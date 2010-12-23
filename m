Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0LWRVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:21:15 -0500
Received: from xenotime.net ([72.52.115.56]:43316 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752286Ab0LWRVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:21:14 -0500
Date: Thu, 23 Dec 2010 09:21:08 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        oleg <oleg@redhat.com>, john.stultz@linaro.org, roland@redhat.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
Message-Id: <20101223092108.3f28d853.rdunlap@xenotime.net>
In-Reply-To: <1293121303.3390.185.camel@Palantir>
References: <1293121303.3390.185.camel@Palantir>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 17:21:43 +0100 Dario Faggioli wrote:

> Trying to read CLOCK_THREAD_CPUTIME_ID of a thread from outside
> the process that spawned it with this code:
> 
>         if (clock_getcpuclockid(tid, &clockid) != 0) {
>                 perror("clock_getcpuclockid");
>                 exit(EXIT_FAILURE);
>         }
> 
> results in this:
>   ### Testing tid 24207: CPU-time clock for PID 24207 is 1.132371729 seconds
>   ### Testing tid 24209: clock_getcpuclockid: Success
> 
> OTH, if full-fledged processes are involved, the behaviour is this:
>   ### Testing tid 24218: CPU-time clock for PID 24218 is 0.001059305 seconds
>   ### Testing tid 24220: CPU-time clock for PID 24220 is 1.044057391 seconds
> 
> Test programs available here: http://gitorious.org/clockid.


"DNS service for this domain has expired with DNS Made Easy"  :(

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
