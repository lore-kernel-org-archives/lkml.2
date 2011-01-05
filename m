Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1AEN26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:28:58 -0500
Received: from mail.openrapids.net ([64.15.138.104]:37716 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752014Ab1AEN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:28:57 -0500
Date: Wed, 5 Jan 2011 08:28:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC patch 5/5] trace event sched: remove TP_perf_assign
Message-ID: <20110105132856.GB31831@Krystal>
References: <20110104231629.996422888@efficios.com> <20110104232419.782205410@efficios.com> <1294221486.2016.212.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294221486.2016.212.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:26:08 up 42 days, 18:29,  1 user,  load average: 0.16, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Tue, 2011-01-04 at 18:16 -0500, Mathieu Desnoyers wrote:
> > plain text document attachment (trace-event-sched-remove-perf-count.patch)
> > The TP_perf_assign part of 2 scheduler TRACE_EVENT are not used and don't act as
> > TRACE_EVENT fields per se.
> 
> Hrm,. they should be used, include/trace/ftrace.h uses __perf_count().
> If it doesn't actually work them something broke.
> 
> So NAK on removing them.

Good point, a fresh look at perf's use of __perf_count() shows that the __count
and __addr local variables are acutally used. I'm therefore dropping this patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
