Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1AET4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:56:15 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47968 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477Ab1AET4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:56:14 -0500
Date: Wed, 5 Jan 2011 14:56:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110105195612.GA9709@Krystal>
References: <20110104231629.996422888@efficios.com> <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere> <20110105001837.GA9737@Krystal> <20110105020759.GG2911@nowhere> <20110105023541.GA12950@Krystal> <20110105025848.GH2911@nowhere> <20110105135242.GC31831@Krystal> <20110105150245.GA1692@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105150245.GA1692@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:45:55 up 43 days, 49 min,  5 users,  load average: 0.08, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
[...]
> Looks good!
> 
> I might be missing corner things but it seems this would reduce the code
> footprint (one function less) and turn more rw into ro datas.
> 
> So it seems to be a very valuable reason to change the semicolon requirement
> all over the place.
> 
> If you come up with this feature along the massive semicolon requirement
> change, we will probably happily apply the whole.
> 
> But coming with only the semicolon change is more like an empty shell.

My proposal here is to incrementally improve the tracing code, starting by
cleaning up what is already there. I cannot do this if you keep asking me for
larger changes to both Ftrace and Perf before any of the prerequisite cleanups
can make their way in.

In this thread, I demonstrated that the TRACE_EVENT cleanup I proposed opens a
lot of code/data size reduction cleanups for Ftrace and Perf. But let's get the
cleanup in there first (it does not break the current way Ftrace and Perf are
working), and once all the code-base has moved to the semicolumn-less semantic,
then we can start improving Ftrace and Perf.

As we say in French, "il ne faut pas mettre la charrue devant les boeufs"
(roughly: don't put the cart before the horse)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
