Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2C3App (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:45:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50471 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630Ab2C3Aph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:45:37 -0400
Date: Fri, 30 Mar 2012 02:45:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@ti.com>, Geoff Levand <geoff@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Ingo Molnar <mingo@kernel.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Max Krasnyansky <maxk@qualcomm.com>, Zen Lin <zen@openhuawei.org>,
        Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
Message-ID: <20120330004527.GB2571@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <87r4wbhqqd.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4wbhqqd.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 05:33:46PM -0700, Kevin Hilman wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > There are still a lot of things to handle. Especially about
> > what is done by scheduler_tick() but we also need to:
> >
> > - completely handle cputime accounting (need to find every "reader"
> > of cputime and flush cputimes for all of them).
> > -handle  perf
> > - handle irqtime finegrained accounting
> > - handle ilb load balancing
> > - etc...
> 
>   - add more arch support :)
> 
> For ARM, I've started hacking things into place and have some
> preliminary patches to add ARM support for the new IPI, syscall support,
> exception hooks, etc.[1]
> 
> This is enough to get some basic things running and test the nohz
> cpusets functionality on ARM, and for others to start trying it out.
> 
> For anyone interested in collaborating on ARM support, my
> work-in-progress branch is below[1] based on Frederic's cpuset-v2
> branch.  Patches and testing welcome.
> 
> Kevin
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git wip/arm-nohz-cpusets

Nice! Thanks for working on this. You may want to work with Geoff Levand who's working
on the ARM port too.
